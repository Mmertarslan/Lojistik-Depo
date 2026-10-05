/*
=========================================================
LOJISTIK DEPO YONETIM SISTEMI
01_DDL.SQL

Bu dosya proje kapsaminda kullanilan veritabani
tablolarini, iliskileri ve indexleri olusturur.

Olusturulan Tablolar:
1. Depo
2. Tedarikci
3. Musteri
4. Urun
5. Siparis
6. SiparisDetay
7. Stok

=========================================================
*/
CREATE DATABASE 
LojistikdepofinalDB;
GO
USE LojistikDepoFinalDB;
GO

CREATE TABLE dbo.Depo (
    DepoID INT PRIMARY KEY IDENTITY(1,1),
    DepoAdi NVARCHAR(100) NOT NULL,
    Sehir NVARCHAR(50) NOT NULL,
    Adres NVARCHAR(200),
    Kapasite INT CHECK (Kapasite > 0)
);
GO

CREATE TABLE dbo.Tedarikci (
    TedarikciID INT PRIMARY KEY IDENTITY(1,1),
    FirmaAdi NVARCHAR(100) NOT NULL,
    Telefon NVARCHAR(12) UNIQUE,
    Email NVARCHAR(100) UNIQUE,
    Sehir NVARCHAR(50) NOT NULL
);
GO

CREATE TABLE dbo.Musteri (
    MusteriID INT PRIMARY KEY IDENTITY(1,1),
    AdSoyad NVARCHAR(100) NOT NULL,
    Telefon NVARCHAR(12) UNIQUE,
    Email NVARCHAR(100) UNIQUE,
    Adres NVARCHAR(200),
    MusteriTipi NVARCHAR(20) CHECK (MusteriTipi IN ('Bireysel', 'Kurumsal'))
);
GO

CREATE TABLE dbo.Urun (
    UrunID INT PRIMARY KEY IDENTITY(1,1),
    TedarikciID INT NOT NULL,
    UrunAdi NVARCHAR(100) NOT NULL,
    Kategori NVARCHAR(50),
    BirimFiyat DECIMAL(10,2) CHECK (BirimFiyat > 0),
    Barkod NVARCHAR(50) UNIQUE,

    CONSTRAINT FK_Urun_Tedarikci
        FOREIGN KEY (TedarikciID)
        REFERENCES dbo.Tedarikci(TedarikciID)
);
GO

CREATE TABLE dbo.Siparis (
    SiparisID INT PRIMARY KEY IDENTITY(1,1),
    MusteriID INT NOT NULL,
    SiparisTarihi DATE DEFAULT GETDATE(),
    SiparisDurumu NVARCHAR(30)
        CHECK (SiparisDurumu IN ('Hazýrlanýyor', 'Yolda', 'TeslimEdildi', 'Iptal')),
    ToplamTutar DECIMAL(10,2) DEFAULT 0 CHECK (ToplamTutar >= 0),

    CONSTRAINT FK_Siparis_Musteri
        FOREIGN KEY (MusteriID)
        REFERENCES dbo.Musteri(MusteriID)
);
GO

CREATE TABLE dbo.SiparisDetay (
    SiparisDetayID INT PRIMARY KEY IDENTITY(1,1),
    SiparisID INT NOT NULL,
    UrunID INT NOT NULL,
    Miktar INT NOT NULL CHECK (Miktar > 0),
    BirimFiyat DECIMAL(10,2) NOT NULL CHECK (BirimFiyat > 0),
    SatirToplam AS (Miktar * BirimFiyat),

    CONSTRAINT FK_SiparisDetay_Siparis
        FOREIGN KEY (SiparisID)
        REFERENCES dbo.Siparis(SiparisID),

    CONSTRAINT FK_SiparisDetay_Urun
        FOREIGN KEY (UrunID)
        REFERENCES dbo.Urun(UrunID)
);
GO

CREATE TABLE dbo.Stok (
    StokID INT PRIMARY KEY IDENTITY(1,1),
    DepoID INT NOT NULL,
    UrunID INT NOT NULL,
    Miktar INT NOT NULL CHECK (Miktar >= 0),
    SonGuncelleme DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_Stok_Depo
        FOREIGN KEY (DepoID)
        REFERENCES dbo.Depo(DepoID),

    CONSTRAINT FK_Stok_Urun
        FOREIGN KEY (UrunID)
        REFERENCES dbo.Urun(UrunID)
);
GO

CREATE NONCLUSTERED INDEX IX_Urun_UrunAdi
ON dbo.Urun(UrunAdi);
GO

CREATE NONCLUSTERED INDEX IX_Siparis_MusteriID
ON dbo.Siparis(MusteriID);
GO

CREATE NONCLUSTERED INDEX IX_SiparisDetay_SiparisID_UrunID
ON dbo.SiparisDetay(SiparisID, UrunID);
GO

CREATE NONCLUSTERED INDEX IX_Stok_DepoID_UrunID
ON dbo.Stok(DepoID, UrunID);
GO