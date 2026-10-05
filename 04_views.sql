USE LojistikDepoFinalDB;
GO

/* Eski view'lar varsa silinir */
DROP VIEW IF EXISTS dbo.vw_UrunListesi;
GO

DROP VIEW IF EXISTS dbo.vw_SiparisMusteri;
GO

DROP VIEW IF EXISTS dbo.vw_KategoriStokOzeti;
GO

/* 
   VIEW 1 - Urun Listesi

   Urunlerin tedarikci bilgileri ile birlikte
   goruntulenmesi amaclanmistir.
*/

CREATE VIEW dbo.vw_UrunListesi
AS
SELECT
    Urun.UrunID,
    Urun.UrunAdi,
    Urun.Kategori,
    Urun.BirimFiyat,
    Tedarikci.FirmaAdi
FROM dbo.Urun
INNER JOIN dbo.Tedarikci
    ON Urun.TedarikciID = Tedarikci.TedarikciID;
GO

/* 
   VIEW 2 - Siparis ve Musteri Bilgileri

   Musterilerin verdigi siparisleri
   birlikte goruntulemek icin kullanilmistir.
*/

CREATE VIEW dbo.vw_SiparisMusteri
AS
SELECT
    Musteri.AdSoyad,
    Musteri.MusteriTipi,
    Siparis.SiparisID,
    Siparis.SiparisTarihi,
    Siparis.SiparisDurumu,
    Siparis.ToplamTutar
FROM dbo.Musteri
INNER JOIN dbo.Siparis
    ON Musteri.MusteriID = Siparis.MusteriID;
GO

/* 
   VIEW 3 - Kategori Stok Ozeti

   Urun kategorilerine gore toplam stok
   miktarlarini goruntulemek icin kullanilmistir.
*/

CREATE VIEW dbo.vw_KategoriStokOzeti
AS
SELECT
    Urun.Kategori,
    SUM(Stok.Miktar) AS ToplamStok
FROM dbo.Urun
INNER JOIN dbo.Stok
    ON Urun.UrunID = Stok.UrunID
GROUP BY Urun.Kategori;
GO

/* View kontrol sorgulari */
SELECT * FROM dbo.vw_UrunListesi;
SELECT * FROM dbo.vw_SiparisMusteri;
SELECT * FROM dbo.vw_KategoriStokOzeti;
GO