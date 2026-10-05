USE LojistikDepoFinalDB;
GO

/* 
   TRANSACTION 1 - STOK GIRISI

   Bu islemde Tokat Deposundaki Su urunune
   yeni gelen 16 adetlik stok eklenmektedir.

   DepoID = 1  = Tokat Depo
   UrunID = 3  = Su
   Çünkü bir koli suda 16 tane vardýr.
 */

BEGIN TRANSACTION;

UPDATE dbo.Stok
SET 
    Miktar = Miktar + 16,
    SonGuncelleme = GETDATE()
WHERE DepoID = 1
  AND UrunID = 3;

COMMIT TRANSACTION;
GO

/* 
   TRANSACTION 2 - SIPARIS DURUMU GUNCELLEME

   Bu islemde 1 numarali siparisin durumu
   hazirlaniyor durumundan kargoda durumuna
   guncellenmektedir.
 */

BEGIN TRANSACTION;

UPDATE dbo.Siparis
SET SiparisDurumu = 'Kargoda'
WHERE SiparisID = 1;

COMMIT TRANSACTION;
GO

/* 
   TRANSACTION 3 - TRY CATCH ILE HATA KONTROLU

   Bu islemde mevcut bir siparise gecersiz durum
   degeri verilmeye calisilmaktadir.

   SiparisDurumu alaninda sadece:
   Hazirlaniyor, Kargoda, TeslimEdildi, Iptal
   degerlerine izin verilmektedir.

   Bu nedenle 'Beklemede' degeri CHECK kisitina
   uymadigi icin hata olusur ve ROLLBACK calisir.
 */

BEGIN TRY
    BEGIN TRANSACTION;

    UPDATE dbo.Siparis
    SET SiparisDurumu = 'Beklemede'
    WHERE SiparisID = 2;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;

    SELECT
        ERROR_NUMBER() AS HataNo,
        ERROR_MESSAGE() AS HataMesaji;
END CATCH;
GO

/* 
   KONTROL SORGULARI
 */

SELECT * FROM dbo.Stok;
SELECT * FROM dbo.Siparis;
GO