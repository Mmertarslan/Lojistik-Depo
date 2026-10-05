USE LojistikDepoFinalDB;
GO

/* 
   LOG TABLOSU

   Trigger calistiginda olusan islemleri
   kaydetmek icin kullanilmaktadir.
 */

CREATE TABLE dbo.LogKayit (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    IslemTarihi DATETIME DEFAULT GETDATE(),
    Aciklama NVARCHAR(180)
);
GO

/* 
   TRG 1

   Siparis tablosuna yeni kayit eklendiginde
   LogKayit tablosuna bilgi ekler.
 */

CREATE TRIGGER trg_SiparisLog
ON dbo.Siparis
AFTER INSERT
AS
BEGIN
    INSERT INTO dbo.LogKayit (Aciklama)
    SELECT
        'Yeni siparis eklendi. SiparisID: '
        + CAST(SiparisID AS NVARCHAR(20))
    FROM inserted;
END;
GO

/* 
   TRG 2

   Stok tablosunda miktar guncellendiginde
   LogKayit tablosuna bilgi ekler.
 */

CREATE TRIGGER trg_StokGuncellemeLog
ON dbo.Stok
AFTER UPDATE
AS
BEGIN
    INSERT INTO dbo.LogKayit (Aciklama)
    SELECT
        'Stok miktari guncellendi. StokID: '
        + CAST(StokID AS NVARCHAR(20))
    FROM inserted;
END;
GO

/* TEST ISLEMLERI */

INSERT INTO dbo.Siparis
(MusteriID, SiparisTarihi, SiparisDurumu, ToplamTutar)
VALUES
(1, GETDATE(), 'Hazirlaniyor', 50);
GO

UPDATE dbo.Stok
SET Miktar = Miktar + 50
WHERE StokID = 1;
GO
/* BURADA +50 DEMEMÝN SEBEBÝ DEPODAKÝ STOÐU GÜNCELLERKEN HER KOLÝDEN 50 GÝBÝ BÝR SAYIDA ÜRÜN ÇIKMASIDIR */
 

SELECT * FROM dbo.LogKayit;
GO