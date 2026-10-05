USE LojistikDepoFinalDB;
GO

/* TEDARIKCI VERILERI */
INSERT INTO dbo.Tedarikci (FirmaAdi, Telefon, Email, Sehir)
VALUES
('Arslan Tedarik', '03560000001', 'info@arslantedarik.com', 'Tokat'),
('Kayar Lojistik', '02120000002', 'info@kayarlojistik.com', 'Istanbul'),
('Patlak Depolama', '02240000003', 'info@patlakdepo.com', 'Bursa'),
('Mert Dagitim', '03460000004', 'info@mertdagitim.com', 'Sivas'),
('Deniz Ticaret', '03560000005', 'info@denizticaret.com', 'Tokat');
GO

/* DEPO VERILERI */
INSERT INTO dbo.Depo (DepoAdi, Sehir, Adres, Kapasite)
VALUES
('Tokat Depo', 'Tokat', 'Merkez', 7500),
('Istanbul Depo', 'Istanbul', 'Basaksehir', 15000),
('Bursa Depo', 'Bursa', 'Nilufer', 4000),
('Sivas Depo', 'Sivas', 'Merkez', 1500),
('Erbaa Depo', 'Tokat', 'Erbaa', 1200);
GO

/* MUSTERI VERILERI */
INSERT INTO dbo.Musteri (AdSoyad, Telefon, Email, Adres, MusteriTipi)
VALUES
('Enhar Kayar', '05330000001', 'enhar@mail.com', 'Tokat', 'Bireysel'),
('Mert Arslan', '05330000002', 'mert@mail.com', 'Istanbul', 'Bireysel'),
('Deniz Patlak', '05330000003', 'deniz@mail.com', 'Bursa', 'Bireysel'),
('Ali Yildiz', '05330000004', 'ali@mail.com', 'Sivas', 'Bireysel'),
('Kayar Market', '02121234005', 'market@mail.com', 'Istanbul', 'Kurumsal');
GO

/* URUN VERILERI */
INSERT INTO dbo.Urun
(TedarikciID, DepoID, UrunAdi, Kategori, BirimFiyat, Barkod)
VALUES
(2, 1, 'Su', 'Icecek', 10, 'NMR100'),
(3, 2, 'Cay', 'Icecek', 25, 'NMR101'),
(4, 3, 'Kahve', 'Icecek', 80, 'NMR102'),
(1, 4, 'Biskuvi', 'Gida', 15, 'NMR103'),
(5, 5, 'Cikolata', 'Gida', 20, 'NMR104');
GO

/* SIPARIS VERILERI */
INSERT INTO dbo.Siparis (MusteriID, SiparisTarihi, SiparisDurumu, ToplamTutar)
VALUES
(1, '2026-05-20', 'Hazirlaniyor', 100),
(2, '2026-05-21', 'Kargoda', 200),
(3, '2026-05-22', 'TeslimEdildi', 150),
(4, '2026-05-23', 'Hazirlaniyor', 80),
(5, '2026-05-24', 'Kargoda', 120);
GO

/* SIPARIS DETAY VERILERI */
INSERT INTO dbo.SiparisDetay
(SiparisID, UrunID, Miktar, BirimFiyat)
VALUES
(1, 3, 10, 10),
(2, 5, 2, 80),
(3, 4, 6, 25),
(4, 6, 5, 15),
(5, 7, 6, 20);
GO

/* STOK VERILERI */
INSERT INTO dbo.Stok
(DepoID, UrunID, Miktar)
VALUES
(1, 3, 200),
(2, 4, 150),
(3, 5, 80),
(4, 6, 120),
(5, 7, 100);
GO