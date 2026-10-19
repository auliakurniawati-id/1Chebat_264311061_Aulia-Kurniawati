-- SOAL 1 --

-- 1. Tabel Mahasiswa (Master) --

CREATE TABLE tb_nasabah (
    ID_Nasabah INT PRIMARY KEY,
    Nama_Nasabah VARCHAR(100) NOT NULL,
    Jenis_Rekening VARCHAR(50) NOT NULL,
    Status_Nasabah VARCHAR(30) NOT NULL
);

-- 2. Tabel Master 2: tb_laporan
CREATE TABLE tb_laporan (
    No_Laporan VARCHAR(30) PRIMARY KEY,
    Tanggal_Pemeriksaan DATE NOT NULL,
    Status_Laporan VARCHAR(100) NOT NULL
);

-- 3. Tabel Transaksi: tb_transaksi
CREATE TABLE tb_transaksi (
    ID_Transaksi VARCHAR(30) PRIMARY KEY,
    Tanggal_Pengiriman DATE NOT NULL,
    ID_Pengirim INT NOT NULL,
    ID_Penerima INT NOT NULL,
    Nominal DECIMAL(15,2) NOT NULL,
    Jenis_Transaksi VARCHAR(50) NOT NULL,
    No_Laporan VARCHAR(30) NULL,
    Indikasi VARCHAR(100) NULL,
    CONSTRAINT fk_transaksi_pengirim FOREIGN KEY (ID_Pengirim) REFERENCES tb_nasabah(ID_Nasabah),
    CONSTRAINT fk_transaksi_penerima FOREIGN KEY (ID_Penerima) REFERENCES tb_nasabah(ID_Nasabah),
    CONSTRAINT fk_transaksi_laporan FOREIGN KEY (No_Laporan) REFERENCES tb_laporan(No_Laporan)
);

-- SOAL 2 --

-- 1. [CREATE] INSERT minimal 3 baris data dummy ke masing-masing tabel (Total = 9 baris data)

-- Insert 3 baris ke Tabel Induk 1 (tb_nasabah)
INSERT INTO tb_nasabah (ID_Nasabah, Nama_Nasabah, Jenis_Rekening, Status_Nasabah) VALUES
(1001, 'Andi Pratama', 'Perorangan', 'Aktif'),
(1002, 'Budi Santoso', 'Perorangan', 'Aktif'),
(1003, 'Citra Mandiri', 'Perusahaan', 'Aktif');

-- Insert 3 baris ke Tabel Induk 2 (tb_laporan)
INSERT INTO tb_laporan (No_Laporan, Tanggal_Pemeriksaan, Status_Laporan) VALUES
('LTM-001', '2026-09-16', 'Perlu pemeriksaan lebih lanjut'),
('LTM-002', '2026-09-17', 'Dalam Investigasi'),
('LTM-003', '2026-09-18', 'Selesai Analisis');

-- Insert 3 baris ke Tabel Transaksi (tb_transaksi)
INSERT INTO tb_transaksi (ID_Transaksi, Tanggal_Pengiriman, ID_Pengirim, ID_Penerima, Nominal, Jenis_Transaksi, No_Laporan, Indikasi) VALUES
('TRX001', '2026-09-15', 1001, 1002, 50000000.00, 'Transfer', 'LTM-001', 'Transaksi berantai'),
('TRX002', '2026-09-15', 1002, 1003, 48000000.00, 'Transfer', 'LTM-001', 'Transaksi berantai'),
('TRX003', '2026-09-15', 1003, 1001, 45000000.00, 'Transfer', 'LTM-001', 'Membentuk siklus');


-- 2. [READ] Tampilkan seluruh isi salah satu Tabel Induk
SELECT * FROM tb_nasabah;


-- 3. [UPDATE] Mengubah satu nilai data pada Tabel Transaksi menggunakan WHERE pada Primary Key
UPDATE tb_transaksi
SET Indikasi = 'Membentuk siklus terkonfirmasi'
WHERE ID_Transaksi = 'TRX003';


-- 4. [DELETE] Menghapus salah satu baris data dummy pada Tabel Transaksi menggunakan WHERE
DELETE FROM tb_transaksi
WHERE ID_Transaksi = 'TRX003';

-- SOAL 3 --

SELECT 
    l.No_Laporan,
    COUNT(t.ID_Transaksi) AS Jumlah_Transaksi,
    SUM(t.Nominal) AS Total_Nominal
FROM tb_transaksi t
JOIN tb_laporan l ON t.No_Laporan = l.No_Laporan
WHERE t.No_Laporan IS NOT NULL
GROUP BY l.No_Laporan;
