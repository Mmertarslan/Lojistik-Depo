USE LojistikDepoFinalDB;
GO

/* 
   VERI AMBARI KATMANI

   Bu bolumde satislari analiz etmek icin
   basit bir yildiz sema kurulmustur.

   Dimension tablolar:
   - DimUrun
   - DimMusteri

   Fact tablo:
   - FactSatis
 */

CREATE TABLE dbo.DimUrun (
    DimUrunID INT PRIMARY KEY IDENTITY(1,1),
    UrunID INT,
    UrunAdi NVARCHAR(100),
    Kategori NVARCHAR(50)
);
GO

CREATE TABLE dbo.DimMusteri (
    DimMusteriID INT PRIMARY KEY IDENTITY(1,1),
    MusteriID INT,
    AdSoyad NVARCHAR(100),
    MusteriTipi NVARCHAR(20)
);
GO

CREATE TABLE dbo.FactSatis (
    FactSatisID INT PRIMARY KEY IDENTITY(1,1),
    SiparisID INT,
    UrunID INT,
    MusteriID INT,
    Miktar INT,
    BirimFiyat DECIMAL(10,2),
    ToplamTutar DECIMAL(10,2)
);
GO

/* 
   ETL ISLEMLERI

   Ana tablolardaki veriler veri ambari
   tablolarina aktarilmaktadir.
 */

INSERT INTO dbo.DimUrun
(UrunID, UrunAdi, Kategori)
SELECT
    UrunID,
    UrunAdi,
    Kategori
FROM dbo.Urun;
GO

INSERT INTO dbo.DimMusteri
(MusteriID, AdSoyad, MusteriTipi)
SELECT
    MusteriID,
    AdSoyad,
    MusteriTipi
FROM dbo.Musteri;
GO

INSERT INTO dbo.FactSatis
(SiparisID, UrunID, MusteriID, Miktar, BirimFiyat, ToplamTutar)
SELECT
    SiparisDetay.SiparisID,
    SiparisDetay.UrunID,
    Siparis.MusteriID,
    SiparisDetay.Miktar,
    SiparisDetay.BirimFiyat,
    SiparisDetay.Miktar * SiparisDetay.BirimFiyat AS ToplamTutar
FROM dbo.SiparisDetay
INNER JOIN dbo.Siparis
    ON SiparisDetay.SiparisID = Siparis.SiparisID;
GO

/* 
   OLAP SORGUSU - ROLLUP

   Urun kategorisi ve musteri tipine gore
   toplam satis tutari hesaplanmistir.
 */

SELECT
    DimUrun.Kategori,
    DimMusteri.MusteriTipi,
    SUM(FactSatis.ToplamTutar) AS ToplamSatis,
    SUM(FactSatis.Miktar) AS ToplamMiktar
FROM dbo.FactSatis
INNER JOIN dbo.DimUrun
    ON FactSatis.UrunID = DimUrun.UrunID
INNER JOIN dbo.DimMusteri
    ON FactSatis.MusteriID = DimMusteri.MusteriID
GROUP BY ROLLUP (DimUrun.Kategori, DimMusteri.MusteriTipi);
GO