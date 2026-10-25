-- SOAL 1. Pemodelan Konseptual -- 
-- Mengaktifkan pengecekan foreign key (Khusus untuk MySQL/SQLite jika diperlukan)
SET FOREIGN_KEY_CHECKS = 1;

-- ==========================================
-- 1. TABEL UTAMA & SPESIALISASI (MASTER NASABAH)
-- ==========================================

-- Tabel Induk Nasabah (Supertype)
CREATE TABLE tb_nasabah (
    ID_Nasabah VARCHAR(50) NOT NULL,
    Nama_Nasabah VARCHAR(100) NOT NULL,
    Jenis_Rekening VARCHAR(50) NOT NULL,
    Status_Nasabah VARCHAR(50) NOT NULL,
    PRIMARY KEY (ID_Nasabah)
);

-- Tabel Subtipe UMKM (Spesialisasi IS-A)
CREATE TABLE tb_nasabah_umkm (
    ID_Nasabah VARCHAR(50) NOT NULL,
    Jenis_Usaha VARCHAR(100),
    Omzet_Tahunan DECIMAL(18, 2),
    NIB_IUMK VARCHAR(50),
    Kategori_UMKM VARCHAR(50),
    PRIMARY KEY (ID_Nasabah),
    FOREIGN KEY (ID_Nasabah) REFERENCES tb_nasabah(ID_Nasabah) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabel Subtipe Perorangan (Spesialisasi IS-A)[cite: 1]
CREATE TABLE tb_nasabah_perorangan (
    ID_Nasabah VARCHAR(50) NOT NULL,
    NIK VARCHAR(30),
    Pekerjaan VARCHAR(100),
    PRIMARY KEY (ID_Nasabah),
    FOREIGN KEY (ID_Nasabah) REFERENCES tb_nasabah(ID_Nasabah) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ==========================================
-- 2. TABEL LAPORAN PEMERIKSAAN
-- ==========================================

CREATE TABLE tb_laporan (
    No_Laporan VARCHAR(50) NOT NULL,
    Tanggal_Pemeriksaan DATE DEFAULT (CURRENT_DATE),
    Status_Laporan VARCHAR(50) DEFAULT 'Draft',
    PRIMARY KEY (No_Laporan)
);

-- ==========================================
-- 3. TABEL INTI TRANSAKSI KEUANGAN
-- ==========================================

CREATE TABLE tb_transaksi (
    ID_Transaksi VARCHAR(50) NOT NULL,
    Tanggal_Pengiriman DATE DEFAULT (CURRENT_DATE),
    Nominal DECIMAL(18, 2) NOT NULL,
    Jenis_Transaksi VARCHAR(50),
    Indikasi VARCHAR(100) DEFAULT 'Normal',
     ID_Nasabah_Pengirim VARCHAR(50),
    ID_Nasabah_Penerima VARCHAR(50),
    No_Laporan VARCHAR(50),
    PRIMARY KEY (ID_Transaksi),
    FOREIGN KEY (ID_Nasabah_Pengirim) REFERENCES tb_nasabah(ID_Nasabah) ON DELETE SET NULL,
    FOREIGN KEY (ID_Nasabah_Penerima) REFERENCES tb_nasabah(ID_Nasabah) ON DELETE SET NULL,
    FOREIGN KEY (No_Laporan) REFERENCES tb_laporan(No_Laporan) ON DELETE SET NULL,
    CONSTRAINT chk_nominal_positif CHECK (Nominal >= 0)
);

-- SOAL 2. Pemodelan Logis --
-- Mengisi Data Master Nasabah
INSERT INTO tb_nasabah (ID_Nasabah, Nama_Nasabah, Jenis_Rekening, Status_Nasabah) VALUES 
('NSB001', 'Budi Santoso', 'Giro Bisnis', 'Aktif'),
('NSB002', 'Siti Rahma', 'Tabungan Perorangan', 'Aktif'),
('NSB003', 'CV Berkah Jaya', 'Giro Korporat', 'Diawasi');

-- Mengisi Data Spesialisasi Nasabah UMKM & Perorangan[cite: 1]
INSERT INTO tb_nasabah_umkm (ID_Nasabah, Jenis_Usaha, Omzet_Tahunan, NIB_IUMK, Kategori_UMKM) VALUES 
('NSB003', 'Perdagangan Tekstil', 1500000000.00, '9120001234567', 'Menengah');

INSERT INTO tb_nasabah_perorangan (ID_Nasabah, NIK, Pekerjaan) VALUES 
('NSB001', '3515011234560001', 'Pengusaha'),
('NSB002', '3515029876540002', 'Karyawan Swasta');

-- Mengisi Data Laporan Pemeriksaan Audit
INSERT INTO tb_laporan (No_Laporan, Tanggal_Pemeriksaan, Status_Laporan) VALUES 
('LPR-2026-001', '2026-10-25', 'Investigasi Lanjut');

-- Mengisi Rekam Transaksi Keuangan (Simulasi Aliran Dana & Indikasi Pencucian Uang)
INSERT INTO tb_transaksi (ID_Transaksi, Tanggal_Pengiriman, Nominal, Jenis_Transaksi, Indikasi, ID_Nasabah_Pengirim, ID_Nasabah_Penerima, No_Laporan) VALUES 
('TRX-9901', '2026-10-24', 250000000.00, 'Transfer Pemindahbukuan', 'Structuring / Pecah Transaksi', 'NSB001', 'NSB003', 'LPR-2026-001');

-- SOAL 3. Pemodelan Fisik --
-- =========================================================================
-- PEMODELAN FISIK: SKRIP SQL DDL LENGKAP DENGAN EKSTENSI PROSES BISNIS
-- Studi Kasus: Deteksi Pola Pencucian Uang (Money Laundering)
-- =========================================================================

-- 1. Membuat Tabel Induk Nasabah (Supertype)
CREATE TABLE tb_nasabah (
    ID_Nasabah VARCHAR(50) NOT NULL,
    Nama_Nasabah VARCHAR(100) NOT NULL,
    Jenis_Rekening VARCHAR(50) NOT NULL,
    Status_Nasabah VARCHAR(50) NOT NULL,
    PRIMARY KEY (ID_Nasabah)
);

-- 2. Membuat Tabel Subtipe UMKM (Spesialisasi IS-A)[cite: 1]
CREATE TABLE tb_nasabah_umkm (
    ID_Nasabah VARCHAR(50) NOT NULL,
    Jenis_Usaha VARCHAR(100),
    Omzet_Tahunan DECIMAL(18,2),
    NIB_IUMK VARCHAR(50),
    Kategori_UMKM VARCHAR(50),
    PRIMARY KEY (ID_Nasabah),
    FOREIGN KEY (ID_Nasabah) REFERENCES tb_nasabah(ID_Nasabah) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- 3. Membuat Tabel Subtipe Perorangan (Spesialisasi IS-A)[cite: 1]
CREATE TABLE tb_nasabah_perorangan (
    ID_Nasabah VARCHAR(50) NOT NULL,
    NIK VARCHAR(30),
    Pekerjaan VARCHAR(100),
    PRIMARY KEY (ID_Nasabah),
    FOREIGN KEY (ID_Nasabah) REFERENCES tb_nasabah(ID_Nasabah) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- 4. Membuat Tabel Laporan Pemeriksaan Audit
CREATE TABLE tb_laporan (
    No_Laporan VARCHAR(50) NOT NULL,
    Tanggal_Pemeriksaan DATE DEFAULT (CURRENT_DATE),
    Status_Laporan VARCHAR(50) DEFAULT 'Draft',
    PRIMARY KEY (No_Laporan)
);

-- 5. Membuat Tabel Inti Transaksi Keuangan[cite: 1]
CREATE TABLE tb_transaksi (
    ID_Transaksi VARCHAR(50) NOT NULL,
    Tanggal_Pengiriman DATE DEFAULT (CURRENT_DATE),
    Nominal DECIMAL(18,2) NOT NULL,
    Jenis_Transaksi VARCHAR(50),
    Indikasi VARCHAR(100) DEFAULT 'Normal',
    ID_Nasabah_Pengirim VARCHAR(50),
    ID_Nasabah_Penerima VARCHAR(50),
    No_Laporan VARCHAR(50),
    PRIMARY KEY (ID_Transaksi),
    FOREIGN KEY (ID_Nasabah_Pengirim) REFERENCES tb_nasabah(ID_Nasabah) ON DELETE SET NULL,
    FOREIGN KEY (ID_Nasabah_Penerima) REFERENCES tb_nasabah(ID_Nasabah) ON DELETE SET NULL,
    FOREIGN KEY (No_Laporan) REFERENCES tb_laporan(No_Laporan) ON DELETE SET NULL,
    CONSTRAINT chk_nominal_positif CHECK (Nominal >= 0)
);

-- =========================================================================
-- 6. TABEL EKSTENSI PROSES BISNIS BARU: PENILAIAN RISIKO NASABAH
-- =========================================================================
CREATE TABLE tb_risiko_nasabah (
    ID_Risiko VARCHAR(50) NOT NULL,
    ID_Nasabah VARCHAR(50) NOT NULL,
    Skor_Risiko INT DEFAULT 0,
    Tingkat_Risiko VARCHAR(20) DEFAULT 'Rendah',
    Tanggal_Evaluasi DATE DEFAULT (CURRENT_DATE),
    PRIMARY KEY (ID_Risiko),
    FOREIGN KEY (ID_Nasabah) REFERENCES tb_nasabah(ID_Nasabah) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_tingkat_risiko CHECK (Tingkat_Risiko IN ('Rendah', 'Sedang', 'Tinggi'))
);

-- =========================================================================
-- 7. TABEL EKSTENSI PROSES BISNIS BARU: SANCTION SCREENING / WATCHLIST
-- =========================================================================
CREATE TABLE tb_watchlist (
    ID_Watchlist VARCHAR(50) NOT NULL,
    ID_Nasabah VARCHAR(50) NOT NULL,
    Sumber_List VARCHAR(100) NOT NULL,
    Alasan_Masuk TEXT NOT NULL,
    Status_Blokir VARCHAR(20) DEFAULT 'Aktif',
    PRIMARY KEY (ID_Watchlist),
    FOREIGN KEY (ID_Nasabah) REFERENCES tb_nasabah(ID_Nasabah) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_status_blokir CHECK (Status_Blokir IN ('Aktif', 'Dilepas'))
);
