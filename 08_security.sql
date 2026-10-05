USE LojistikDepoFinalDB;
GO

/* 
   GUVENLIK ISLEMLERI

   Bu bolumde veri tabanina yeni bir kullanici
   eklenmis ve belirli tablolara erisim yetkisi
   verilmiþtir.
 */

/* Login olusturma */

CREATE LOGIN LojistikKullanici
WITH PASSWORD = 'Admin1234!';
GO

/* Database kullanicisi olusturma */

CREATE USER LojistikKullanici
FOR LOGIN LojistikKullanici;
GO

/* Musteri tablosuna okuma yetkisi */

GRANT SELECT
ON dbo.Musteri
TO LojistikKullanici;
GO

/* Siparis tablosuna okuma yetkisi */

GRANT SELECT
ON dbo.Siparis
TO LojistikKullanici;
GO

/* Stok tablosuna okuma yetkisi */

GRANT SELECT
ON dbo.Stok
TO LojistikKullanici;
GO

/* Yetki kontrolu */

SELECT
    dp.name AS KullaniciAdi,
    dp.type_desc AS KullaniciTipi
FROM sys.database_principals dp
WHERE dp.name = 'LojistikKullanici';
GO