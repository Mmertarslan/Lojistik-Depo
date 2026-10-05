USE LojistikDepoFinalDB;
GO

/* 
   SORGU 1 - INNER JOIN

   Bu sorguda Musteri ve Siparis tablolari
   birlestirilmiþtir. Hangi musterinin hangi
   siparisi verdigi goruntulenmektedir.
 */

SELECT
    Musteri.AdSoyad,
    Siparis.SiparisID,
    Siparis.SiparisTarihi,
    Siparis.SiparisDurumu,
    Siparis.ToplamTutar
FROM dbo.Musteri
INNER JOIN dbo.Siparis
    ON Musteri.MusteriID = Siparis.MusteriID;
GO

/* 
   SORGU 2 - LEFT JOIN

   Bu sorguda tum depolar listelenmistir.
   Depoda urun varsa urun ve stok bilgileri
   de ekrana getirilmektedir.
 */

SELECT
    Depo.DepoAdi,
    Depo.Sehir,
    Urun.UrunAdi,
    Stok.Miktar
FROM dbo.Depo
LEFT JOIN dbo.Stok
    ON Depo.DepoID = Stok.DepoID
LEFT JOIN dbo.Urun
    ON Stok.UrunID = Urun.UrunID;
GO

/* 
   SORGU 3 - RIGHT JOIN

   Bu sorguda tum urunler listelenmektedir.
   Urunun stok bilgisi varsa birlikte
   gosterilmektedir.
 */

SELECT
    Urun.UrunAdi,
    Urun.Kategori,
    Stok.Miktar
FROM dbo.Stok
RIGHT JOIN dbo.Urun
    ON Stok.UrunID = Urun.UrunID;
GO

/* 
   SORGU 4 - ALT SORGU

   Ortalama siparis tutari hesaplanmis ve
   ortalamanin ustunde kalan siparisler
   listelenmistir.
 */

SELECT
    SiparisID,
    MusteriID,
    ToplamTutar
FROM dbo.Siparis
WHERE ToplamTutar >
(
    SELECT AVG(ToplamTutar)
    FROM dbo.Siparis
);
GO

/* 
   SORGU 5 - EXISTS

   Bu sorguda en az bir siparisi bulunan
   musteriler listelenmektedir.
 */

SELECT
    Musteri.MusteriID,
    Musteri.AdSoyad,
    Musteri.MusteriTipi
FROM dbo.Musteri
WHERE EXISTS
(
    SELECT 1
    FROM dbo.Siparis
    WHERE Siparis.MusteriID = Musteri.MusteriID
);
GO

/* 
   SORGU 6 - GROUP BY ve HAVING

   Musteriler bireysel ve kurumsal olarak
   gruplandirilmistir. Her grubun siparis
   sayisi ve toplam siparis tutari hesaplanmistir.
 */

SELECT
    Musteri.MusteriTipi,
    COUNT(Siparis.SiparisID) AS SiparisSayisi,
    SUM(Siparis.ToplamTutar) AS ToplamSiparisTutari
FROM dbo.Musteri
INNER JOIN dbo.Siparis
    ON Musteri.MusteriID = Siparis.MusteriID
GROUP BY Musteri.MusteriTipi
HAVING SUM(Siparis.ToplamTutar) >= 200
GO

/* 
   SORGU 7 - GROUP BY

   Urunler kategorilerine gore gruplandirilmis
   ve toplam stok miktarlari hesaplanmistir.
*/

SELECT
    Urun.Kategori,
    SUM(Stok.Miktar) AS ToplamStok,
    AVG(Stok.Miktar) AS OrtalamaStok
FROM dbo.Urun
INNER JOIN dbo.Stok
    ON Urun.UrunID = Stok.UrunID
GROUP BY Urun.Kategori;
GO

/* 
   SORGU 8 - CROSS JOIN

   Bu sorguda depo ve urun tablolarindaki
   tum olasi kombinasyonlar listelenmektedir.
 */

SELECT
    Depo.DepoAdi,
    Urun.UrunAdi
FROM dbo.Depo
CROSS JOIN dbo.Urun;
GO