-- =============================================================================
-- DATABASE DESIGN: Sistem Informasi Yayasan Darul Furqan Pariaman
-- Nama Database: db_darul_furqan
-- Platform: MySQL 8.0+
-- Dibuat: 2026
-- =============================================================================

CREATE DATABASE IF NOT EXISTS db_darul_furqan CHARACTER
SET
    utf8mb4 COLLATE utf8mb4_unicode_ci;

USE db_darul_furqan;

-- =============================================================================
-- TABEL INTI SISTEM & AUTENTIKASI
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Tabel: roles
-- Deskripsi: Master data peran/role untuk akun admin
-- -----------------------------------------------------------------------------
CREATE TABLE roles (
    id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE, -- 'super_admin', 'admin_konten', 'operator_ppdb', 'kepala_sekolah'
    display_name VARCHAR(100) NOT NULL,
    description TEXT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = 'Master role/peran admin';

-- -----------------------------------------------------------------------------
-- Tabel: admin_users
-- Deskripsi: Akun pengguna back-end (admin sistem)
-- -----------------------------------------------------------------------------
CREATE TABLE admin_users (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    role_id TINYINT UNSIGNED NOT NULL,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(191) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL, -- bcrypt hash
    avatar VARCHAR(255) NULL,
    is_active TINYINT (1) NOT NULL DEFAULT 1,
    last_login_at TIMESTAMP NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_admin_role FOREIGN KEY (role_id) REFERENCES roles (id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = 'Akun admin back-end';

-- -----------------------------------------------------------------------------
-- Tabel: admin_activity_logs
-- Deskripsi: Log aktivitas semua admin untuk audit trail
-- -----------------------------------------------------------------------------
CREATE TABLE admin_activity_logs (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    admin_id INT UNSIGNED NOT NULL,
    action VARCHAR(100) NOT NULL, -- 'create', 'update', 'delete', 'login', dll
    module VARCHAR(100) NOT NULL, -- 'berita', 'ppdb', 'galeri', dll
    description TEXT NULL,
    ip_address VARCHAR(45) NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_log_admin FOREIGN KEY (admin_id) REFERENCES admin_users (id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = 'Audit log aktivitas admin';

-- -----------------------------------------------------------------------------
-- Tabel: wali_murid
-- Deskripsi: Akun wali murid untuk portal PPDB online
-- -----------------------------------------------------------------------------
CREATE TABLE wali_murid (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(191) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL, -- bcrypt hash
    phone VARCHAR(20) NOT NULL,
    is_email_verified TINYINT (1) NOT NULL DEFAULT 0,
    email_verified_at TIMESTAMP NULL,
    remember_token VARCHAR(100) NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = 'Akun wali murid untuk PPDB online';

-- =============================================================================
-- MODUL PROFIL SEKOLAH & CMS
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Tabel: profil_sekolah
-- Deskripsi: Konten statis profil yayasan (satu baris saja / singleton)
-- -----------------------------------------------------------------------------
CREATE TABLE profil_sekolah (
    id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nama_yayasan VARCHAR(200) NOT NULL,
    nama_sekolah VARCHAR(200) NOT NULL,
    tagline VARCHAR(300) NULL,
    sejarah LONGTEXT NULL,
    visi TEXT NULL,
    misi LONGTEXT NULL,
    sambutan_kepala LONGTEXT NULL,
    nama_kepala VARCHAR(150) NULL,
    foto_kepala VARCHAR(255) NULL,
    npsn VARCHAR(20) NULL, -- Nomor Pokok Sekolah Nasional
    akreditasi VARCHAR(10) NULL, -- A, B, C
    tahun_berdiri YEAR NULL,
    alamat TEXT NOT NULL,
    kota VARCHAR(100) NOT NULL,
    provinsi VARCHAR(100) NOT NULL,
    kode_pos VARCHAR(10) NULL,
    latitude DECIMAL(10, 8) NULL,
    longitude DECIMAL(11, 8) NULL,
    telepon VARCHAR(20) NULL,
    whatsapp VARCHAR(20) NULL,
    email VARCHAR(191) NULL,
    website_url VARCHAR(255) NULL,
    facebook_url VARCHAR(255) NULL,
    instagram_url VARCHAR(255) NULL,
    youtube_url VARCHAR(255) NULL,
    logo VARCHAR(255) NULL,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = 'Profil dan informasi yayasan/sekolah';

-- -----------------------------------------------------------------------------
-- Tabel: unit_sekolah
-- Deskripsi: Unit-unit sekolah di bawah yayasan (PAUD, SDIT, Pesantren)
-- -----------------------------------------------------------------------------
CREATE TABLE unit_sekolah (
    id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
    kode VARCHAR(20) NOT NULL UNIQUE, -- 'PAUD', 'SDIT', 'PESANTREN'
    nama VARCHAR(150) NOT NULL,
    deskripsi LONGTEXT NULL,
    kurikulum TEXT NULL,
    usia_masuk VARCHAR(50) NULL,
    foto_cover VARCHAR(255) NULL,
    urutan TINYINT UNSIGNED NOT NULL DEFAULT 0,
    is_active TINYINT (1) NOT NULL DEFAULT 1,
    PRIMARY KEY (id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = 'Unit-unit sekolah di bawah yayasan';

-- -----------------------------------------------------------------------------
-- Tabel: struktur_organisasi
-- Deskripsi: Bagan organisasi yayasan dan sekolah
-- -----------------------------------------------------------------------------
CREATE TABLE struktur_organisasi (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    parent_id INT UNSIGNED NULL, -- Hierarki self-referencing
    unit_id TINYINT UNSIGNED NULL, -- NULL berarti level yayasan
    jabatan VARCHAR(150) NOT NULL,
    nama_pejabat VARCHAR(150) NOT NULL,
    foto VARCHAR(255) NULL,
    urutan SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    is_active TINYINT (1) NOT NULL DEFAULT 1,
    PRIMARY KEY (id),
    CONSTRAINT fk_orgs_parent FOREIGN KEY (parent_id) REFERENCES struktur_organisasi (id) ON DELETE SET NULL,
    CONSTRAINT fk_orgs_unit FOREIGN KEY (unit_id) REFERENCES unit_sekolah (id) ON DELETE SET NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = 'Struktur organisasi yayasan';

-- =============================================================================
-- MODUL GURU & STAFF
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Tabel: jabatan_guru
-- Deskripsi: Master data jabatan untuk guru dan staff
-- -----------------------------------------------------------------------------
CREATE TABLE jabatan_guru (
    id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nama VARCHAR(100) NOT NULL,
    PRIMARY KEY (id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = 'Master jabatan guru dan staff';

-- -----------------------------------------------------------------------------
-- Tabel: guru_staff
-- Deskripsi: Data lengkap guru dan tenaga kependidikan
-- -----------------------------------------------------------------------------
CREATE TABLE guru_staff (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    unit_id TINYINT UNSIGNED NOT NULL,
    jabatan_id SMALLINT UNSIGNED NULL,
    nip VARCHAR(30) NULL UNIQUE,
    nama VARCHAR(150) NOT NULL,
    bidang_studi VARCHAR(150) NULL,
    pendidikan VARCHAR(50) NULL, -- S1, S2, S3, D3, dll
    universitas VARCHAR(200) NULL,
    pengalaman_tahun TINYINT UNSIGNED NULL,
    foto VARCHAR(255) NULL,
    bio TEXT NULL,
    is_active TINYINT (1) NOT NULL DEFAULT 1,
    urutan SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_guru_unit FOREIGN KEY (unit_id) REFERENCES unit_sekolah (id),
    CONSTRAINT fk_guru_jabatan FOREIGN KEY (jabatan_id) REFERENCES jabatan_guru (id) ON DELETE SET NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = 'Data guru dan tenaga kependidikan';

-- =============================================================================
-- MODUL FASILITAS, EKSKUL & PRESTASI
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Tabel: fasilitas
-- Deskripsi: Data fasilitas yang dimiliki sekolah
-- -----------------------------------------------------------------------------
CREATE TABLE fasilitas (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    unit_id TINYINT UNSIGNED NULL, -- NULL = fasilitas bersama
    nama VARCHAR(150) NOT NULL,
    deskripsi TEXT NULL,
    foto VARCHAR(255) NULL,
    urutan SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    is_active TINYINT (1) NOT NULL DEFAULT 1,
    PRIMARY KEY (id),
    CONSTRAINT fk_fas_unit FOREIGN KEY (unit_id) REFERENCES unit_sekolah (id) ON DELETE SET NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = 'Fasilitas sekolah';

-- -----------------------------------------------------------------------------
-- Tabel: ekstrakurikuler
-- Deskripsi: Data kegiatan ekstrakurikuler
-- -----------------------------------------------------------------------------
CREATE TABLE ekstrakurikuler (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    unit_id TINYINT UNSIGNED NULL,
    nama VARCHAR(150) NOT NULL,
    deskripsi TEXT NULL,
    jadwal VARCHAR(200) NULL, -- "Setiap Sabtu, 08.00 - 10.00 WIB"
    pembina VARCHAR(150) NULL,
    foto VARCHAR(255) NULL,
    is_active TINYINT (1) NOT NULL DEFAULT 1,
    urutan SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    CONSTRAINT fk_ekskul_unit FOREIGN KEY (unit_id) REFERENCES unit_sekolah (id) ON DELETE SET NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = 'Kegiatan ekstrakurikuler';

-- -----------------------------------------------------------------------------
-- Tabel: prestasi
-- Deskripsi: Data prestasi siswa dan sekolah
-- -----------------------------------------------------------------------------
CREATE TABLE prestasi (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    unit_id TINYINT UNSIGNED NULL,
    judul VARCHAR(200) NOT NULL,
    jenis ENUM(
        'akademik',
        'non_akademik',
        'lembaga'
    ) NOT NULL DEFAULT 'akademik',
    tingkat ENUM(
        'kecamatan',
        'kabupaten_kota',
        'provinsi',
        'nasional',
        'internasional'
    ) NOT NULL,
    juara VARCHAR(50) NULL, -- "Juara 1", "Best Paper", dll
    penyelenggara VARCHAR(200) NULL,
    tanggal DATE NOT NULL,
    deskripsi TEXT NULL,
    foto VARCHAR(255) NULL,
    is_active TINYINT (1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_prestasi_unit FOREIGN KEY (unit_id) REFERENCES unit_sekolah (id) ON DELETE SET NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = 'Prestasi sekolah dan siswa';

-- =============================================================================
-- MODUL BERITA & PENGUMUMAN
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Tabel: kategori_berita
-- Deskripsi: Master kategori untuk berita dan artikel
-- -----------------------------------------------------------------------------
CREATE TABLE kategori_berita (
    id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nama VARCHAR(100) NOT NULL,
    slug VARCHAR(120) NOT NULL UNIQUE,
    PRIMARY KEY (id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = 'Kategori berita';

-- -----------------------------------------------------------------------------
-- Tabel: berita
-- Deskripsi: Berita dan artikel yang dipublikasikan
-- -----------------------------------------------------------------------------
CREATE TABLE berita (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    kategori_id SMALLINT UNSIGNED NULL,
    admin_id INT UNSIGNED NOT NULL,
    judul VARCHAR(300) NOT NULL,
    slug VARCHAR(320) NOT NULL UNIQUE,
    ringkasan VARCHAR(500) NULL,
    konten LONGTEXT NOT NULL,
    foto_cover VARCHAR(255) NULL,
    status ENUM(
        'draft',
        'published',
        'archived'
    ) NOT NULL DEFAULT 'draft',
    views INT UNSIGNED NOT NULL DEFAULT 0,
    published_at TIMESTAMP NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_berita_kategori FOREIGN KEY (kategori_id) REFERENCES kategori_berita (id) ON DELETE SET NULL,
    CONSTRAINT fk_berita_admin FOREIGN KEY (admin_id) REFERENCES admin_users (id),
    INDEX idx_berita_status (status),
    INDEX idx_berita_published_at (published_at)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = 'Berita dan artikel sekolah';

-- -----------------------------------------------------------------------------
-- Tabel: pengumuman
-- Deskripsi: Pengumuman resmi sekolah
-- -----------------------------------------------------------------------------
CREATE TABLE pengumuman (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    admin_id INT UNSIGNED NOT NULL,
    judul VARCHAR(300) NOT NULL,
    isi LONGTEXT NOT NULL,
    kategori ENUM(
        'ppdb',
        'akademik',
        'umum',
        'pesantren'
    ) NOT NULL DEFAULT 'umum',
    is_urgent TINYINT (1) NOT NULL DEFAULT 0,
    status ENUM(
        'draft',
        'published',
        'archived'
    ) NOT NULL DEFAULT 'draft',
    tayang_mulai DATE NULL,
    tayang_selesai DATE NULL,
    lampiran VARCHAR(255) NULL, -- path file PDF lampiran
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_peng_admin FOREIGN KEY (admin_id) REFERENCES admin_users (id),
    INDEX idx_peng_status (status),
    INDEX idx_peng_tayang (tayang_mulai, tayang_selesai)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = 'Pengumuman resmi sekolah';

-- =============================================================================
-- MODUL GALERI
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Tabel: kategori_galeri
-- Deskripsi: Master kategori galeri
-- -----------------------------------------------------------------------------
CREATE TABLE kategori_galeri (
    id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nama VARCHAR(100) NOT NULL,
    slug VARCHAR(120) NOT NULL UNIQUE,
    PRIMARY KEY (id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = 'Kategori galeri';

-- -----------------------------------------------------------------------------
-- Tabel: galeri
-- Deskripsi: Koleksi foto dan video dokumentasi
-- -----------------------------------------------------------------------------
CREATE TABLE galeri (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    kategori_id SMALLINT UNSIGNED NULL,
    admin_id INT UNSIGNED NOT NULL,
    judul VARCHAR(200) NOT NULL,
    deskripsi TEXT NULL,
    tipe ENUM('foto', 'video') NOT NULL DEFAULT 'foto',
    file_path VARCHAR(255) NULL, -- untuk foto
    video_url VARCHAR(500) NULL, -- untuk video (YouTube/Vimeo embed URL)
    thumbnail VARCHAR(255) NULL,
    is_active TINYINT (1) NOT NULL DEFAULT 1,
    urutan SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_galeri_kat FOREIGN KEY (kategori_id) REFERENCES kategori_galeri (id) ON DELETE SET NULL,
    CONSTRAINT fk_galeri_admin FOREIGN KEY (admin_id) REFERENCES admin_users (id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = 'Galeri foto dan video sekolah';

-- =============================================================================
-- MODUL KONTAK
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Tabel: pesan_kontak
-- Deskripsi: Pesan masuk dari formulir kontak pengunjung
-- -----------------------------------------------------------------------------
CREATE TABLE pesan_kontak (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nama VARCHAR(150) NOT NULL,
    email VARCHAR(191) NOT NULL,
    subjek VARCHAR(200) NOT NULL,
    pesan TEXT NOT NULL,
    ip_address VARCHAR(45) NULL,
    is_read TINYINT (1) NOT NULL DEFAULT 0,
    read_at TIMESTAMP NULL,
    read_by INT UNSIGNED NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_pesan_admin FOREIGN KEY (read_by) REFERENCES admin_users (id) ON DELETE SET NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = 'Pesan dari formulir kontak pengunjung';

-- =============================================================================
-- MODUL PPDB (PENERIMAAN PESERTA DIDIK BARU)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Tabel: tahun_ppdb
-- Deskripsi: Tahun ajaran dan konfigurasi PPDB
-- -----------------------------------------------------------------------------
CREATE TABLE tahun_ppdb (
    id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    tahun_ajaran VARCHAR(20) NOT NULL UNIQUE, -- "2026/2027"
    is_aktif TINYINT (1) NOT NULL DEFAULT 0,
    kuota_total SMALLINT UNSIGNED NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = 'Tahun ajaran PPDB';

-- -----------------------------------------------------------------------------
-- Tabel: fase_ppdb
-- Deskripsi: Jadwal per fase/tahap PPDB
-- -----------------------------------------------------------------------------
CREATE TABLE fase_ppdb (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    tahun_id SMALLINT UNSIGNED NOT NULL,
    unit_id TINYINT UNSIGNED NOT NULL,
    nama_fase VARCHAR(150) NOT NULL, -- "Pendaftaran", "Tes Seleksi", "Pengumuman", "Daftar Ulang"
    urutan TINYINT UNSIGNED NOT NULL DEFAULT 1,
    tanggal_mulai DATE NOT NULL,
    tanggal_selesai DATE NOT NULL,
    waktu_mulai TIME NULL,
    waktu_selesai TIME NULL,
    keterangan TEXT NULL,
    is_buka_daftar TINYINT (1) NOT NULL DEFAULT 0, -- Apakah fase ini membuka pendaftaran online
    PRIMARY KEY (id),
    CONSTRAINT fk_fase_tahun FOREIGN KEY (tahun_id) REFERENCES tahun_ppdb (id) ON DELETE CASCADE,
    CONSTRAINT fk_fase_unit FOREIGN KEY (unit_id) REFERENCES unit_sekolah (id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = 'Jadwal tahapan PPDB per unit sekolah';

-- -----------------------------------------------------------------------------
-- Tabel: persyaratan_ppdb
-- Deskripsi: Daftar persyaratan dokumen untuk mendaftar
-- -----------------------------------------------------------------------------
CREATE TABLE persyaratan_ppdb (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    unit_id TINYINT UNSIGNED NOT NULL,
    tahun_id SMALLINT UNSIGNED NOT NULL,
    nama_syarat VARCHAR(200) NOT NULL, -- "Akta Kelahiran", "Kartu Keluarga", dll
    keterangan TEXT NULL,
    is_wajib TINYINT (1) NOT NULL DEFAULT 1,
    urutan TINYINT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    CONSTRAINT fk_syarat_unit FOREIGN KEY (unit_id) REFERENCES unit_sekolah (id),
    CONSTRAINT fk_syarat_tahun FOREIGN KEY (tahun_id) REFERENCES tahun_ppdb (id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = 'Persyaratan dokumen pendaftaran PPDB';

-- -----------------------------------------------------------------------------
-- Tabel: calon_siswa
-- Deskripsi: Data diri calon siswa yang mendaftar
-- -----------------------------------------------------------------------------
CREATE TABLE calon_siswa (
    id                  INT UNSIGNED        NOT NULL AUTO_INCREMENT,
    wali_id             INT UNSIGNED        NOT NULL,
    unit_id             TINYINT UNSIGNED    NOT NULL,
    tahun_id            SMALLINT UNSIGNED   NOT NULL,

-- Data Calon Siswa
nama_lengkap VARCHAR(150) NOT NULL,
nama_panggilan VARCHAR(50) NULL,
nik VARCHAR(20) NULL UNIQUE,
jenis_kelamin ENUM('L', 'P') NOT NULL,
tempat_lahir VARCHAR(100) NOT NULL,
tanggal_lahir DATE NOT NULL,
agama VARCHAR(30) NOT NULL DEFAULT 'Islam',
anak_ke TINYINT UNSIGNED NULL,
jumlah_saudara TINYINT UNSIGNED NULL,
asal_sekolah VARCHAR(200) NULL,
foto VARCHAR(255) NULL,

-- Data Orang Tua / Wali
nama_ayah VARCHAR(150) NULL,
pekerjaan_ayah VARCHAR(100) NULL,
nama_ibu VARCHAR(150) NULL,
pekerjaan_ibu VARCHAR(100) NULL,
nama_wali VARCHAR(150) NULL,
hubungan_wali VARCHAR(50) NULL,
alamat_ortu TEXT NULL,
kota_ortu VARCHAR(100) NULL,
kode_pos_ortu VARCHAR(10) NULL,
no_hp_ortu VARCHAR(20) NOT NULL,
email_ortu VARCHAR(191) NULL,

-- Tracking
nomor_pendaftaran   VARCHAR(30)         NOT NULL UNIQUE,  -- Auto-generate: PPDB-2026-SDIT-0001
    status              ENUM(
                            'draft',
                            'submitted',
                            'menunggu_verifikasi_berkas',
                            'berkas_lengkap',
                            'berkas_tidak_lengkap',
                            'menunggu_pembayaran',
                            'pembayaran_terverifikasi',
                            'lulus_seleksi',
                            'tidak_lulus',
                            'daftar_ulang',
                            'diterima',
                            'mengundurkan_diri'
                        )                   NOT NULL DEFAULT 'draft',
    catatan_admin       TEXT                NULL,
    submitted_at        TIMESTAMP           NULL,
    created_at          TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP           NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_cs_wali  FOREIGN KEY (wali_id)  REFERENCES wali_murid(id),
    CONSTRAINT fk_cs_unit  FOREIGN KEY (unit_id)  REFERENCES unit_sekolah(id),
    CONSTRAINT fk_cs_tahun FOREIGN KEY (tahun_id) REFERENCES tahun_ppdb(id),
    INDEX idx_cs_status (status),
    INDEX idx_cs_nomor_daftar (nomor_pendaftaran)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Data calon siswa pendaftar PPDB';

-- -----------------------------------------------------------------------------
-- Tabel: dokumen_pendaftaran
-- Deskripsi: File dokumen yang diupload calon siswa
-- -----------------------------------------------------------------------------
CREATE TABLE dokumen_pendaftaran (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    calon_siswa_id INT UNSIGNED NOT NULL,
    syarat_id INT UNSIGNED NULL, -- Referensi ke persyaratan_ppdb
    nama_dokumen VARCHAR(200) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    file_size INT UNSIGNED NULL, -- bytes
    mime_type VARCHAR(100) NULL,
    status_verif ENUM(
        'menunggu',
        'valid',
        'tidak_valid'
    ) NOT NULL DEFAULT 'menunggu',
    catatan TEXT NULL,
    verified_by INT UNSIGNED NULL,
    verified_at TIMESTAMP NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_dok_cs FOREIGN KEY (calon_siswa_id) REFERENCES calon_siswa (id) ON DELETE CASCADE,
    CONSTRAINT fk_dok_syarat FOREIGN KEY (syarat_id) REFERENCES persyaratan_ppdb (id) ON DELETE SET NULL,
    CONSTRAINT fk_dok_verif FOREIGN KEY (verified_by) REFERENCES admin_users (id) ON DELETE SET NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = 'Dokumen yang diupload oleh calon siswa';

-- -----------------------------------------------------------------------------
-- Tabel: pembayaran_ppdb
-- Deskripsi: Data pembayaran biaya pendaftaran PPDB
-- -----------------------------------------------------------------------------
CREATE TABLE pembayaran_ppdb (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    calon_siswa_id INT UNSIGNED NOT NULL UNIQUE, -- 1 calon siswa = 1 pembayaran
    jumlah DECIMAL(12, 2) NOT NULL,
    bank_tujuan VARCHAR(100) NULL,
    no_rekening VARCHAR(50) NULL,
    atas_nama VARCHAR(150) NULL,
    tanggal_bayar DATE NULL,
    bukti_transfer VARCHAR(500) NULL, -- path file bukti
    status ENUM(
        'belum_bayar',
        'menunggu_verifikasi',
        'terverifikasi',
        'ditolak'
    ) NOT NULL DEFAULT 'belum_bayar',
    catatan TEXT NULL,
    verified_by INT UNSIGNED NULL,
    verified_at TIMESTAMP NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_bayar_cs FOREIGN KEY (calon_siswa_id) REFERENCES calon_siswa (id) ON DELETE CASCADE,
    CONSTRAINT fk_bayar_verif FOREIGN KEY (verified_by) REFERENCES admin_users (id) ON DELETE SET NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = 'Pembayaran biaya pendaftaran PPDB';

-- -----------------------------------------------------------------------------
-- Tabel: riwayat_status_ppdb
-- Deskripsi: Riwayat perubahan status pendaftaran untuk audit trail
-- -----------------------------------------------------------------------------
CREATE TABLE riwayat_status_ppdb (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    calon_siswa_id INT UNSIGNED NOT NULL,
    admin_id INT UNSIGNED NULL, -- NULL jika perubahan otomatis sistem
    status_lama VARCHAR(50) NULL,
    status_baru VARCHAR(50) NOT NULL,
    keterangan TEXT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_riwayat_cs FOREIGN KEY (calon_siswa_id) REFERENCES calon_siswa (id) ON DELETE CASCADE,
    CONSTRAINT fk_riwayat_admin FOREIGN KEY (admin_id) REFERENCES admin_users (id) ON DELETE SET NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = 'Riwayat perubahan status pendaftaran PPDB';

-- -----------------------------------------------------------------------------
-- Tabel: notifikasi_ppdb
-- Deskripsi: Riwayat notifikasi yang dikirim ke wali murid
-- -----------------------------------------------------------------------------
CREATE TABLE notifikasi_ppdb (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    calon_siswa_id INT UNSIGNED NOT NULL,
    judul VARCHAR(200) NOT NULL,
    isi TEXT NOT NULL,
    kanal ENUM('email', 'sms', 'whatsapp') NOT NULL DEFAULT 'email',
    status_kirim ENUM(
        'pending',
        'terkirim',
        'gagal'
    ) NOT NULL DEFAULT 'pending',
    dikirim_at TIMESTAMP NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_notif_cs FOREIGN KEY (calon_siswa_id) REFERENCES calon_siswa (id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = 'Log notifikasi yang dikirim ke wali murid';

-- =============================================================================
-- MODUL PENGATURAN WEBSITE
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Tabel: pengaturan_website
-- Deskripsi: Key-value store untuk konfigurasi website
-- -----------------------------------------------------------------------------
CREATE TABLE pengaturan_website (
    id          INT UNSIGNED    NOT NULL AUTO_INCREMENT,
    `key`       VARCHAR(100)    NOT NULL UNIQUE,
    value       TEXT            NULL,
    label       VARCHAR(200)    NULL,   -- Label deskriptif untuk admin UI
    tipe        ENUM('text','textarea','image','boolean','number') NOT NULL DEFAULT 'text',
    grup        VARCHAR(50)     NOT NULL DEFAULT 'umum',  -- 'umum', 'seo', 'tampilan', 'kontak'
    updated_at  TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Pengaturan dan konfigurasi website';

-- -----------------------------------------------------------------------------
-- Tabel: slider_banner
-- Deskripsi: Gambar slider / hero banner halaman beranda
-- -----------------------------------------------------------------------------
CREATE TABLE slider_banner (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    judul VARCHAR(200) NULL,
    subjudul VARCHAR(300) NULL,
    gambar VARCHAR(255) NOT NULL,
    link_url VARCHAR(500) NULL,
    link_teks VARCHAR(100) NULL,
    is_active TINYINT (1) NOT NULL DEFAULT 1,
    urutan TINYINT UNSIGNED NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = 'Slider banner halaman beranda';

-- =============================================================================
-- DATA AWAL (SEED DATA)
-- =============================================================================

-- Roles default
INSERT INTO
    roles (
        name,
        display_name,
        description
    )
VALUES (
        'super_admin',
        'Super Administrator',
        'Akses penuh ke semua fitur sistem'
    ),
    (
        'admin_konten',
        'Admin Konten',
        'Mengelola konten website: berita, galeri, profil'
    ),
    (
        'operator_ppdb',
        'Operator PPDB',
        'Memproses dan memverifikasi data pendaftaran PPDB'
    ),
    (
        'kepala_sekolah',
        'Kepala Sekolah',
        'Akses laporan dan persetujuan pengumuman'
    );

-- Unit Sekolah default
INSERT INTO
    unit_sekolah (kode, nama, urutan)
VALUES (
        'PAUD',
        'PAUD Darul Furqan',
        1
    ),
    (
        'SDIT',
        'SDIT Alam Darul Furqan',
        2
    ),
    (
        'PESANTREN',
        'Pondok Pesantren Darul Furqan',
        3
    );

-- Kategori Berita default
INSERT INTO
    kategori_berita (nama, slug)
VALUES ('Umum', 'umum'),
    ('Akademik', 'akademik'),
    ('Kegiatan', 'kegiatan'),
    ('Prestasi', 'prestasi'),
    ('PPDB', 'ppdb'),
    ('Pesantren', 'pesantren');

-- Kategori Galeri default
INSERT INTO
    kategori_galeri (nama, slug)
VALUES (
        'Kegiatan Belajar',
        'kegiatan-belajar'
    ),
    ('Fasilitas', 'fasilitas'),
    ('Prestasi', 'prestasi'),
    (
        'Ekstrakurikuler',
        'ekstrakurikuler'
    ),
    ('PPDB', 'ppdb');

-- Tahun PPDB awal
INSERT INTO
    tahun_ppdb (tahun_ajaran, is_aktif)
VALUES ('2026/2027', 1);

-- Pengaturan website dasar
INSERT INTO pengaturan_website (`key`, value, label, tipe, grup) VALUES
('site_title',       'Yayasan Darul Furqan Pariaman', 'Judul Website',        'text',    'umum'),
('site_description', 'Website resmi Yayasan Darul Furqan Pariaman',           'Deskripsi Website', 'textarea', 'seo'),
('maintenance_mode', '0',                             'Mode Maintenance',      'boolean', 'umum'),
('ppdb_is_open',     '1',                             'Status PPDB Terbuka',  'boolean', 'ppdb'),
('footer_text',      '© 2026 Yayasan Darul Furqan Pariaman. All rights reserved.', 'Teks Footer', 'text', 'tampilan');

-- =============================================================================
-- INDEKS TAMBAHAN UNTUK PERFORMA QUERY
-- =============================================================================

CREATE INDEX idx_berita_slug ON berita (slug);

CREATE INDEX idx_berita_kategori ON berita (kategori_id);

CREATE INDEX idx_galeri_kategori ON galeri (kategori_id);

CREATE INDEX idx_galeri_tipe ON galeri (tipe);

CREATE INDEX idx_calon_unit_tahun ON calon_siswa (unit_id, tahun_id);

CREATE INDEX idx_calon_wali ON calon_siswa (wali_id);

CREATE INDEX idx_riwayat_cs ON riwayat_status_ppdb (calon_siswa_id);

CREATE INDEX idx_dokumen_cs ON dokumen_pendaftaran (calon_siswa_id);

CREATE INDEX idx_log_admin ON admin_activity_logs (admin_id);

CREATE INDEX idx_log_created ON admin_activity_logs (created_at);

CREATE INDEX idx_prestasi_tahun ON prestasi (tanggal);

CREATE INDEX idx_pengaturan_key ON pengaturan_website(`key`);

-- =============================================================================
-- VIEWS UNTUK PELAPORAN DAN DASHBOARD
-- =============================================================================

-- View: Ringkasan statistik PPDB per unit per tahun
CREATE VIEW v_statistik_ppdb AS
SELECT
    t.tahun_ajaran,
    u.nama AS unit,
    COUNT(cs.id) AS total_pendaftar,
    SUM(cs.status = 'submitted') AS submitted,
    SUM(cs.status = 'berkas_lengkap') AS berkas_lengkap,
    SUM(
        cs.status = 'pembayaran_terverifikasi'
    ) AS pembayaran_verified,
    SUM(cs.status = 'lulus_seleksi') AS lulus_seleksi,
    SUM(cs.status = 'diterima') AS diterima,
    SUM(cs.status = 'tidak_lulus') AS tidak_lulus
FROM
    calon_siswa cs
    JOIN tahun_ppdb t ON cs.tahun_id = t.id
    JOIN unit_sekolah u ON cs.unit_id = u.id
GROUP BY
    t.tahun_ajaran,
    u.nama;

-- View: Detail pendaftar dengan info wali dan status pembayaran
CREATE VIEW v_detail_pendaftar AS
SELECT
    cs.id,
    cs.nomor_pendaftaran,
    t.tahun_ajaran,
    u.nama AS unit_sekolah,
    cs.nama_lengkap AS nama_calon,
    cs.jenis_kelamin,
    cs.tanggal_lahir,
    cs.asal_sekolah,
    wm.name AS nama_wali,
    wm.email AS email_wali,
    cs.no_hp_ortu,
    cs.status,
    p.status AS status_pembayaran,
    cs.submitted_at,
    cs.created_at
FROM
    calon_siswa cs
    JOIN tahun_ppdb t ON cs.tahun_id = t.id
    JOIN unit_sekolah u ON cs.unit_id = u.id
    JOIN wali_murid wm ON cs.wali_id = wm.id
    LEFT JOIN pembayaran_ppdb p ON p.calon_siswa_id = cs.id;

-- =============================================================================
-- END OF SCHEMA
-- =============================================================================