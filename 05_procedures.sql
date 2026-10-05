USE LojistikDepoFinalDB;
GO

/* 
   PROSEDUR 1 

   Bu prosedur girilen MusteriID degerine gore
   musterinin siparislerini listeler.
 */

CREATE PROCEDURE sp_MusteriSiparisleri
    @MusteriID INT
AS
BEGIN
    SELECT
        Siparis.SiparisID,
        Siparis.SiparisTarihi,
        Siparis.SiparisDurumu,
        Siparis.ToplamTutar
    FROM dbo.Siparis
    WHERE Siparis.MusteriID = @MusteriID;
END;
GO

/* Ornek */
EXEC sp_MusteriSiparisleri @MusteriID = 1;
GO

/* 
   PROSEDUR 2

   Bu prosedur depo ve urun bilgisine gore
   stok miktarini gunceller.
 */

CREATE PROCEDURE sp_StokGuncelle
    @DepoID INT,
    @UrunID INT,
    @YeniMiktar INT
AS
BEGIN
    UPDATE dbo.Stok
    SET
        Miktar = @YeniMiktar,
        SonGuncelleme = GETDATE()
    WHERE DepoID = @DepoID
      AND UrunID = @UrunID;
END;
GO

/* Ornek */
EXEC sp_StokGuncelle
    @DepoID = 1,
    @UrunID = 4,
    @YeniMiktar = 100;
GO

/* Kontrol etme */
SELECT * FROM dbo.Stok;
GO