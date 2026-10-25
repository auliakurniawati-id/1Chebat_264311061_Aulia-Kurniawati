-- Soal 3. Pemodelan Fisik --
-- =========================================================================
-- PEMODELAN FISIK: SKRIP SQL DDL AML BERBASIS GRAF & DINAMIKA RISIKO
-- Studi Kasus: Deteksi Pencucian Uang (Anti-Money Laundering / AML) berbasis Graf
-- =========================================================================

-- 1. Tabel Analis
CREATE TABLE analis (
    id_analis VARCHAR(50) PRIMARY KEY,
    nama_analis VARCHAR(100) NOT NULL,
    jabatan VARCHAR(50) NOT NULL
);

-- 2. Tabel Pola Deteksi (Untuk Algoritma Analisis Graf/Anomali)
CREATE TABLE pola_deteksi (
    id_pola VARCHAR(50) PRIMARY KEY,
    nama_pola VARCHAR(100) NOT NULL,
    deskripsi TEXT,
    tingkat_keparahan VARCHAR(50) CHECK (tingkat_keparahan IN ('Rendah', 'Sedang', 'Tinggi', 'Kritis'))
);

-- 3. Tabel Cabang Bank
CREATE TABLE cabang (
    kode_cabang VARCHAR(50) PRIMARY KEY,
    nama_cabang VARCHAR(100) NOT NULL,
    kota VARCHAR(50) NOT NULL
);

-- 4. Tabel Nasabah (Mendukung Dynamic Profile & Risk Consistency)
-- Tingkat risiko dan jenis nasabah dapat diperbarui secara real-time
CREATE TABLE nasabah (
    id_nasabah VARCHAR(50) PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    berelasi_dengan VARCHAR(100),
    jenis_nasabah VARCHAR(50) NOT NULL, -- Contoh: Perorangan, UMKM
    alamat TEXT,
    tingkat_risiko VARCHAR(50) DEFAULT 'Rendah' CHECK (tingkat_risiko IN ('Rendah', 'Sedang', 'Tinggi'))
);

-- 5. Tabel Daftar Pantauan (Sanction Screening / Watchlist Kepatuhan)
CREATE TABLE daftar_pantauan (
    id_pantauan VARCHAR(50) PRIMARY KEY,
    nama_daftar VARCHAR(100) NOT NULL,
    sumber VARCHAR(100) NOT NULL, -- Contoh: PPATK, FATF, PEP
    id_nasabah VARCHAR(50) NOT NULL,
    CONSTRAINT fk_pantauan_nasabah FOREIGN KEY (id_nasabah) 
        REFERENCES nasabah(id_nasabah) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 6. Tabel Rekening (Menghubungkan Nasabah dan Cabang)
CREATE TABLE rekening (
    no_rekening VARCHAR(50) PRIMARY KEY,
    jenis_rekening VARCHAR(50) NOT NULL,
    tanggal_buka DATE DEFAULT (CURRENT_DATE),
    status VARCHAR(50) DEFAULT 'Aktif',
    kode_cabang VARCHAR(50),
    id_nasabah VARCHAR(50),
    CONSTRAINT fk_rekening_cabang FOREIGN KEY (kode_cabang) 
        REFERENCES cabang(kode_cabang) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_rekening_nasabah FOREIGN KEY (id_nasabah) 
        REFERENCES nasabah(id_nasabah) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 7. Tabel Kasus (Investigasi)
CREATE TABLE kasus (
    id_kasus VARCHAR(50) PRIMARY KEY,
    judul_kasus VARCHAR(100) NOT NULL,
    tanggal_dibuka DATE DEFAULT (CURRENT_DATE),
    status_kasus VARCHAR(50) DEFAULT 'Investigasi',
    id_analis VARCHAR(50),
    CONSTRAINT fk_kasus_analis FOREIGN KEY (id_analis) 
        REFERENCES analis(id_analis) ON DELETE SET NULL ON UPDATE CASCADE
);

-- 8. Tabel Alert / Peringatan Sistem Berdasarkan Pola Graf
CREATE TABLE alert (
    id_alert VARCHAR(50) PRIMARY KEY,
    waktu_alert TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    skor_risiko INT DEFAULT 0,
    status_alert VARCHAR(50) DEFAULT 'Pending',
    id_kasus VARCHAR(50),
    id_pola VARCHAR(50),
    CONSTRAINT fk_alert_kasus FOREIGN KEY (id_kasus) 
        REFERENCES kasus(id_kasus) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_alert_pola FOREIGN KEY (id_pola) 
        REFERENCES pola_deteksi(id_pola) ON DELETE SET NULL ON UPDATE CASCADE
);

-- 9. Tabel Transaksi (Inti Aliran Dana / High-Velocity Data)
CREATE TABLE transaksi (
    id_transaksi VARCHAR(50) PRIMARY KEY,
    waktu_transaksi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    nominal DECIMAL(18,2) NOT NULL CHECK (nominal >= 0),
    jenis_transaksi VARCHAR(50) NOT NULL,
    media_trans VARCHAR(50),
    id_alert VARCHAR(50),
    no_rekening VARCHAR(50),
    CONSTRAINT fk_transaksi_alert FOREIGN KEY (id_alert) 
        REFERENCES alert(id_alert) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_transaksi_rekening FOREIGN KEY (no_rekening) 
        REFERENCES rekening(no_rekening) ON DELETE SET NULL ON UPDATE CASCADE
);

4. -- Tambahan Tabel Proses Bisnis --
      Audit_trail_profil
-- =========================================================================
-- TAMBAHAN TABEL PROSES BISNIS: AUDIT TRAIL PERUBAHAN PROFIL & RISIKO
-- Studi Kasus: Deteksi Pencucian Uang (Anti-Money Laundering / AML) berbasis Graf
-- =========================================================================

CREATE TABLE audit_trail_profil (
    id_audit VARCHAR(50) PRIMARY KEY,
    id_nasabah VARCHAR(50) NOT NULL,
    perubahan_field VARCHAR(100) NOT NULL, -- Contoh: 'tingkat_risiko', 'jenis_nasabah'
    nilai_lama TEXT,
    nilai_baru TEXT,
    waktu_perubahan TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    alasan_perubahan TEXT NOT NULL,
    CONSTRAINT fk_audit_nasabah FOREIGN KEY (id_nasabah) 
        REFERENCES nasabah(id_nasabah) ON DELETE CASCADE ON UPDATE CASCADE
);
