-- =====================================================================
-- DATABASE DESIGN: Sistem Informasi Website Yayasan Darul Furqan Pariaman
-- Mata Kuliah  : Information Systems Analysis and Design
-- Referensi    : LN 7 (Designing the Database), LN 4 (Domain Modelling)
--                Satzinger et al. (2016), Chapter 7
-- DBMS         : MySQL 8.0+
-- =====================================================================

-- Buat database
CREATE DATABASE IF NOT EXISTS db_darul_furqan CHARACTER
SET
    utf8mb4 COLLATE utf8mb4_unicode_ci;

USE db_darul_furqan;

-- =====================================================================
-- TABEL 1: users
-- Deskripsi : Data pengguna admin sistem (back-end)
-- Asosiasi  : Direferensikan oleh berita, galeri, guru, pendaftar,
--             profil_sekolah, kontak_pesan
-- =====================================================================
CREATE TABLE users (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL COMMENT 'Hashed dengan bcrypt',
    role ENUM(
        'super_admin',
        'admin_konten',
        'operator_ppdb'
    ) NOT NULL DEFAULT 'admin_konten',
    is_active TINYINT (1) NOT NULL DEFAULT 1,
    last_login TIMESTAMP NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_role (role),
    INDEX idx_active (is_active)
) ENGINE = InnoDB COMMENT = 'Data pengguna admin sistem';

-- =====================================================================
-- TABEL 2: profil_sekolah
-- Deskripsi : Informasi dasar yayasan dan sekolah
-- Asosiasi  : FK updated_by → users.id
-- =====================================================================
CREATE TABLE profil_sekolah (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nama_yayasan VARCHAR(200) NOT NULL,
    nama_sekolah VARCHAR(200) NOT NULL,
    visi TEXT,
    misi TEXT COMMENT 'Dapat disimpan sebagai JSON array atau paragraf',
    sejarah TEXT,
    alamat TEXT NOT NULL,
    kota VARCHAR(100) NOT NULL,
    provinsi VARCHAR(100) NOT NULL DEFAULT 'Sumatera Barat',
    kode_pos VARCHAR(10),
    telepon VARCHAR(20),
    email VARCHAR(100),
    website VARCHAR(200),
    logo VARCHAR(255) COMMENT 'Path relatif file logo',
    maps_embed TEXT COMMENT 'URL embed Google Maps',
    tahun_berdiri YEAR,
    akreditasi VARCHAR(5) COMMENT 'A / B / C / Belum Terakreditasi',
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    updated_by INT UNSIGNED NULL,
    CONSTRAINT fk_profil_user FOREIGN KEY (updated_by) REFERENCES users (id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB COMMENT = 'Informasi dasar sekolah dan yayasan';

-- =====================================================================
-- TABEL 3: program_sekolah
-- Deskripsi : Program pendidikan yang diselenggarakan
-- Asosiasi  : Direferensikan oleh ppdb, guru
-- =====================================================================
CREATE TABLE program_sekolah (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    kode_program VARCHAR(20) NOT NULL UNIQUE,
    nama_program VARCHAR(100) NOT NULL,
    jenjang ENUM(
        'PAUD',
        'SD',
        'SMP',
        'SMA',
        'Pesantren'
    ) NOT NULL,
    deskripsi TEXT,
    keunggulan TEXT COMMENT 'Keunggulan dan keistimewaan program',
    gambar VARCHAR(255) COMMENT 'Path file gambar program',
    is_active TINYINT (1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_jenjang (jenjang),
    INDEX idx_active (is_active)
) ENGINE = InnoDB COMMENT = 'Program pendidikan yang tersedia';

-- =====================================================================
-- TABEL 4: tahun_ajaran
-- Deskripsi : Data tahun ajaran akademik
-- Asosiasi  : Direferensikan oleh ppdb
-- =====================================================================
CREATE TABLE tahun_ajaran (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(20) NOT NULL UNIQUE COMMENT 'Format: 2024/2025',
    tanggal_mulai DATE NOT NULL,
    tanggal_selesai DATE NOT NULL,
    is_active TINYINT (1) NOT NULL DEFAULT 0 COMMENT '1 = tahun ajaran berjalan',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_active (is_active)
) ENGINE = InnoDB COMMENT = 'Data tahun ajaran akademik';

-- =====================================================================
-- TABEL 5: ppdb
-- Deskripsi : Konfigurasi periode Penerimaan Peserta Didik Baru
-- Asosiasi  : FK tahun_ajaran_id → tahun_ajaran.id
--             FK program_id      → program_sekolah.id
-- =====================================================================
CREATE TABLE ppdb (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    tahun_ajaran_id INT UNSIGNED NOT NULL,
    program_id INT UNSIGNED NOT NULL,
    tanggal_buka DATE NOT NULL,
    tanggal_tutup DATE NOT NULL,
    kuota INT NOT NULL DEFAULT 30,
    biaya_pendaftaran DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    persyaratan TEXT COMMENT 'Daftar persyaratan pendaftaran',
    catatan TEXT,
    status ENUM(
        'akan_datang',
        'buka',
        'tutup'
    ) NOT NULL DEFAULT 'akan_datang',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_ppdb_tahun_ajaran FOREIGN KEY (tahun_ajaran_id) REFERENCES tahun_ajaran (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_ppdb_program FOREIGN KEY (program_id) REFERENCES program_sekolah (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_status (status),
    INDEX idx_tahun_ajaran (tahun_ajaran_id),
    INDEX idx_program (program_id)
) ENGINE = InnoDB COMMENT = 'Konfigurasi periode PPDB per program dan tahun ajaran';

-- =====================================================================
-- TABEL 6: pendaftar
-- Deskripsi : Data calon siswa yang mendaftar melalui PPDB
-- Asosiasi  : FK ppdb_id      → ppdb.id
--             FK verified_by  → users.id
-- =====================================================================
CREATE TABLE pendaftar (
    id                      INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    ppdb_id                 INT UNSIGNED NOT NULL,
    no_pendaftaran          VARCHAR(30)  NOT NULL UNIQUE COMMENT 'Auto-generated: DF-2025-0001',

-- Data Calon Siswa
nama_lengkap VARCHAR(150) NOT NULL,
jenis_kelamin ENUM('L', 'P') NOT NULL,
tempat_lahir VARCHAR(100) NOT NULL,
tanggal_lahir DATE NOT NULL,
agama VARCHAR(30) NOT NULL DEFAULT 'Islam',
anak_ke INT NOT NULL DEFAULT 1,
alamat TEXT NOT NULL,
asal_sekolah VARCHAR(150),

-- Data Orang Tua
nama_ayah VARCHAR(150) NOT NULL,
nama_ibu VARCHAR(150) NOT NULL,
pekerjaan_ayah VARCHAR(100),
pekerjaan_ibu VARCHAR(100),
pendidikan_ayah VARCHAR(50),
pendidikan_ibu VARCHAR(50),
telepon_ortu VARCHAR(20) NOT NULL,
email_ortu VARCHAR(100),

-- Dokumen
file_akta_kelahiran VARCHAR(255) COMMENT 'Path file akta kelahiran',
file_kartu_keluarga VARCHAR(255) COMMENT 'Path file KK',
file_ktp_ortu VARCHAR(255) COMMENT 'Path file KTP orang tua',
file_foto VARCHAR(255) COMMENT 'Path foto calon siswa',

-- Status
status                  ENUM('menunggu','diterima','ditolak','cadangan') NOT NULL DEFAULT 'menunggu',
    catatan_operator        TEXT,
    verified_by             INT UNSIGNED NULL,
    verified_at             TIMESTAMP NULL,
    created_at              TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_pendaftar_ppdb FOREIGN KEY (ppdb_id)
        REFERENCES ppdb(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_pendaftar_verifier FOREIGN KEY (verified_by)
        REFERENCES users(id) ON DELETE SET NULL ON UPDATE CASCADE,

    INDEX idx_ppdb_id       (ppdb_id),
    INDEX idx_status        (status),
    INDEX idx_no_pendaftar  (no_pendaftaran),
    INDEX idx_tanggal_lahir (tanggal_lahir)
) ENGINE=InnoDB COMMENT='Data calon siswa peserta PPDB';

-- =====================================================================
-- TABEL 7: berita
-- Deskripsi : Artikel berita, kegiatan, dan informasi sekolah
-- Asosiasi  : FK user_id → users.id
-- =====================================================================
CREATE TABLE berita (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    judul VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL UNIQUE COMMENT 'URL-friendly: judul-berita-01',
    konten LONGTEXT NOT NULL,
    ringkasan TEXT COMMENT 'Ringkasan 150-200 karakter untuk preview',
    gambar_utama VARCHAR(255) COMMENT 'Path thumbnail gambar',
    kategori ENUM(
        'berita',
        'artikel',
        'kegiatan',
        'pengumuman'
    ) NOT NULL DEFAULT 'berita',
    tags VARCHAR(255) COMMENT 'Tag dalam format CSV: pendidikan,ppdb,prestasi',
    user_id INT UNSIGNED NOT NULL,
    tanggal_publish DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status ENUM(
        'draft',
        'published',
        'archived'
    ) NOT NULL DEFAULT 'draft',
    views INT UNSIGNED NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_berita_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_slug (slug),
    INDEX idx_kategori (kategori),
    INDEX idx_status (status),
    INDEX idx_tanggal_publish (tanggal_publish),
    FULLTEXT idx_search (judul, konten)
) ENGINE = InnoDB COMMENT = 'Konten berita dan artikel sekolah';

-- =====================================================================
-- TABEL 8: galeri
-- Deskripsi : Galeri foto dan video kegiatan sekolah
-- Asosiasi  : FK user_id → users.id
-- =====================================================================
CREATE TABLE galeri (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    judul VARCHAR(200) NOT NULL,
    deskripsi TEXT,
    tipe ENUM('foto', 'video') NOT NULL DEFAULT 'foto',
    file_path VARCHAR(255) NOT NULL COMMENT 'Path file lokal / URL YouTube',
    thumbnail VARCHAR(255) COMMENT 'Path thumbnail untuk video',
    kategori VARCHAR(100) NOT NULL DEFAULT 'Umum',
    tanggal_kegiatan DATE COMMENT 'Tanggal kegiatan berlangsung',
    is_featured TINYINT (1) NOT NULL DEFAULT 0 COMMENT 'Tampilkan di beranda',
    user_id INT UNSIGNED NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_galeri_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_tipe (tipe),
    INDEX idx_kategori (kategori),
    INDEX idx_featured (is_featured),
    INDEX idx_tgl_kegiatan (tanggal_kegiatan)
) ENGINE = InnoDB COMMENT = 'Galeri foto dan video kegiatan sekolah';

-- =====================================================================
-- TABEL 9: guru
-- Deskripsi : Data guru dan tenaga pendidik
-- Asosiasi  : FK program_id → program_sekolah.id
-- =====================================================================
CREATE TABLE guru (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nip VARCHAR(30) UNIQUE COMMENT 'Nomor Induk Pegawai (opsional)',
    nama VARCHAR(150) NOT NULL,
    jabatan VARCHAR(100) NOT NULL,
    mata_pelajaran VARCHAR(200) COMMENT 'Mata pelajaran yang diampu',
    program_id INT UNSIGNED NOT NULL,
    pendidikan_terakhir VARCHAR(100),
    universitas VARCHAR(200) COMMENT 'Asal perguruan tinggi',
    tahun_bergabung YEAR,
    bio TEXT COMMENT 'Biografi singkat',
    gambar VARCHAR(255) COMMENT 'Path foto profil',
    is_active TINYINT (1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_guru_program FOREIGN KEY (program_id) REFERENCES program_sekolah (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_program (program_id),
    INDEX idx_jabatan (jabatan),
    INDEX idx_active (is_active)
) ENGINE = InnoDB COMMENT = 'Data guru dan tenaga pendidik';

-- =====================================================================
-- TABEL 10: prestasi
-- Deskripsi : Prestasi siswa dan sekolah di berbagai kompetisi
-- =====================================================================
CREATE TABLE prestasi (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    judul VARCHAR(255) NOT NULL,
    deskripsi TEXT,
    jenis ENUM(
        'akademik',
        'non_akademik',
        'lembaga'
    ) NOT NULL DEFAULT 'akademik',
    tingkat ENUM(
        'kecamatan',
        'kota',
        'provinsi',
        'nasional',
        'internasional'
    ) NOT NULL,
    peraih VARCHAR(200) COMMENT 'Nama siswa peraih (kosong jika prestasi lembaga)',
    penyelenggara VARCHAR(200) NOT NULL,
    tahun YEAR NOT NULL,
    juara VARCHAR(50) COMMENT 'Contoh: Juara 1, Medali Emas',
    gambar VARCHAR(255) COMMENT 'Path foto piagam atau trofi',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_jenis (jenis),
    INDEX idx_tingkat (tingkat),
    INDEX idx_tahun (tahun)
) ENGINE = InnoDB COMMENT = 'Data prestasi siswa dan sekolah';

-- =====================================================================
-- TABEL 11: kontak_pesan
-- Deskripsi : Pesan dari pengunjung website melalui form kontak
-- Asosiasi  : FK dibaca_oleh → users.id
-- =====================================================================
CREATE TABLE kontak_pesan (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    telepon VARCHAR(20),
    subjek VARCHAR(200) NOT NULL,
    pesan TEXT NOT NULL,
    status ENUM(
        'belum_dibaca',
        'sudah_dibaca',
        'dibalas'
    ) NOT NULL DEFAULT 'belum_dibaca',
    catatan_balasan TEXT COMMENT 'Catatan atau draft balasan dari admin',
    dibaca_oleh INT UNSIGNED NULL,
    dibaca_at TIMESTAMP NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_pesan_admin FOREIGN KEY (dibaca_oleh) REFERENCES users (id) ON DELETE SET NULL ON UPDATE CASCADE,
    INDEX idx_status (status),
    INDEX idx_email (email),
    INDEX idx_created (created_at)
) ENGINE = InnoDB COMMENT = 'Pesan masuk dari pengunjung website';

-- =====================================================================
-- TABEL 12: statistik_kunjungan
-- Deskripsi : Agregasi log kunjungan website harian
-- =====================================================================
CREATE TABLE statistik_kunjungan (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    tanggal DATE NOT NULL UNIQUE,
    jumlah_kunjungan INT UNSIGNED NOT NULL DEFAULT 0,
    jumlah_pengunjung_unik INT UNSIGNED NOT NULL DEFAULT 0,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_tanggal (tanggal)
) ENGINE = InnoDB COMMENT = 'Statistik kunjungan harian website';

-- =====================================================================
-- SAMPLE DATA — Data awal untuk pengujian sistem
-- =====================================================================

-- Sample: Super Admin
INSERT INTO
    users (nama, email, password, role)
VALUES (
        'Administrator Utama',
        'admin@darulfurqan.sch.id',
        '$2y$10$examplehash',
        'super_admin'
    ),
    (
        'Staff Humas',
        'humas@darulfurqan.sch.id',
        '$2y$10$examplehash',
        'admin_konten'
    ),
    (
        'Operator PPDB',
        'ppdb@darulfurqan.sch.id',
        '$2y$10$examplehash',
        'operator_ppdb'
    );

-- Sample: Profil Sekolah
INSERT INTO
    profil_sekolah (
        nama_yayasan,
        nama_sekolah,
        visi,
        misi,
        sejarah,
        alamat,
        kota,
        provinsi,
        telepon,
        email,
        tahun_berdiri,
        akreditasi,
        updated_by
    )
VALUES (
        'Yayasan Darul Furqan Pariaman',
        'SDIT Alam Darul Furqan',
        'Menjadi sekolah Islam terpadu yang unggul, berkarakter, dan berdaya saing di tingkat nasional.',
        'Menyelenggarakan pendidikan Islam terpadu yang berkualitas; Membentuk generasi yang berakhlak mulia dan berprestasi; Membangun lingkungan belajar yang kondusif dan menyenangkan.',
        'Yayasan Darul Furqan Pariaman didirikan pada tahun 2018 di Kota Pariaman, Sumatera Barat. Berawal dari visi membangun pendidikan Islam berkualitas, yayasan ini mendirikan PAUD, SDIT Alam, dan Pondok Pesantren.',
        'Jl. Raya Pariaman No. 1, Kota Pariaman',
        'Pariaman',
        'Sumatera Barat',
        '0751-XXXXX',
        'info@darulfurqan.sch.id',
        2018,
        'B',
        1
    );

-- Sample: Program Sekolah
INSERT INTO
    program_sekolah (
        kode_program,
        nama_program,
        jenjang,
        deskripsi,
        is_active
    )
VALUES (
        'PAUD',
        'PAUD Darul Furqan',
        'PAUD',
        'Pendidikan Anak Usia Dini berbasis Islam dengan metode fun learning',
        1
    ),
    (
        'SDIT',
        'SDIT Alam Darul Furqan',
        'SD',
        'Sekolah Dasar Islam Terpadu berbasis alam dengan kurikulum nasional dan keislaman',
        1
    ),
    (
        'PONPES',
        'Pondok Pesantren Darul Furqan',
        'Pesantren',
        'Pondok pesantren modern dengan program tahfidz dan pendidikan formal',
        1
    );

-- Sample: Tahun Ajaran
INSERT INTO
    tahun_ajaran (
        nama,
        tanggal_mulai,
        tanggal_selesai,
        is_active
    )
VALUES (
        '2024/2025',
        '2024-07-15',
        '2025-06-30',
        0
    ),
    (
        '2025/2026',
        '2025-07-14',
        '2026-06-30',
        1
    );

-- Sample: PPDB
INSERT INTO
    ppdb (
        tahun_ajaran_id,
        program_id,
        tanggal_buka,
        tanggal_tutup,
        kuota,
        biaya_pendaftaran,
        persyaratan,
        status
    )
VALUES (
        2,
        1,
        '2025-05-01',
        '2025-06-30',
        30,
        0.00,
        'Akta Kelahiran, KK, KTP Orang Tua, Foto 3x4',
        'buka'
    ),
    (
        2,
        2,
        '2025-05-01',
        '2025-06-30',
        60,
        0.00,
        'Akta Kelahiran, KK, KTP Orang Tua, Foto 3x4, Ijazah TK/PAUD',
        'buka'
    ),
    (
        2,
        3,
        '2025-04-01',
        '2025-05-31',
        40,
        0.00,
        'Akta Kelahiran, KK, KTP Orang Tua, Ijazah SD, Foto 3x4',
        'tutup'
    );

-- Sample: Pendaftar
INSERT INTO
    pendaftar (
        ppdb_id,
        no_pendaftaran,
        nama_lengkap,
        jenis_kelamin,
        tempat_lahir,
        tanggal_lahir,
        agama,
        anak_ke,
        alamat,
        nama_ayah,
        nama_ibu,
        pekerjaan_ayah,
        telepon_ortu,
        status
    )
VALUES (
        2,
        'DF-2025-SDIT-0001',
        'Ahmad Fauzan',
        'L',
        'Pariaman',
        '2019-03-10',
        'Islam',
        1,
        'Jl. Merdeka No. 5, Pariaman',
        'Budi Santoso',
        'Sari Indah',
        'PNS',
        '082112345678',
        'diterima'
    ),
    (
        2,
        'DF-2025-SDIT-0002',
        'Siti Aisyah',
        'P',
        'Pariaman',
        '2019-06-22',
        'Islam',
        2,
        'Jl. Nusa Indah No. 8, Pariaman',
        'Rudi Hartono',
        'Dewi Safitri',
        'Wiraswasta',
        '081287654321',
        'menunggu'
    );

-- Sample: Berita
INSERT INTO
    berita (
        judul,
        slug,
        konten,
        ringkasan,
        kategori,
        user_id,
        tanggal_publish,
        status
    )
VALUES (
        'PPDB Tahun Ajaran 2025/2026 Resmi Dibuka',
        'ppdb-tahun-ajaran-2025-2026-resmi-dibuka',
        '<p>Yayasan Darul Furqan Pariaman dengan bangga mengumumkan pembukaan Penerimaan Peserta Didik Baru (PPDB) untuk tahun ajaran 2025/2026. Pendaftaran dibuka mulai 1 Mei 2025.</p>',
        'PPDB Tahun Ajaran 2025/2026 resmi dibuka mulai 1 Mei 2025.',
        'pengumuman',
        1,
        NOW(),
        'published'
    ),
    (
        'Siswa SDIT Alam Raih Juara 1 Olimpiade Matematika Tingkat Kota',
        'siswa-sdit-raih-juara-olimpiade-matematika',
        '<p>Kebanggaan bagi keluarga besar SDIT Alam Darul Furqan! Murid kami berhasil meraih Juara 1 dalam Olimpiade Matematika Tingkat Kota Pariaman 2025.</p>',
        'Siswa SDIT Alam meraih Juara 1 Olimpiade Matematika Tingkat Kota 2025.',
        'berita',
        2,
        NOW(),
        'published'
    );

-- Sample: Prestasi
INSERT INTO
    prestasi (
        judul,
        jenis,
        tingkat,
        peraih,
        penyelenggara,
        tahun,
        juara
    )
VALUES (
        'Olimpiade Matematika Tingkat Kota',
        'akademik',
        'kota',
        'Ahmad Fauzan',
        'Dinas Pendidikan Kota Pariaman',
        2025,
        'Juara 1'
    ),
    (
        'Lomba Tahfidz Quran Tingkat Provinsi',
        'akademik',
        'provinsi',
        'Siti Aisyah',
        'Kemenag Sumatera Barat',
        2025,
        'Juara 2'
    ),
    (
        'Lomba Robotik Tingkat Kota',
        'non_akademik',
        'kota',
        'Tim SDIT Alam',
        'Dinas Kominfo Pariaman',
        2024,
        'Juara 3'
    );

-- Sample: Guru
INSERT INTO
    guru (
        nama,
        jabatan,
        mata_pelajaran,
        program_id,
        pendidikan_terakhir,
        tahun_bergabung,
        is_active
    )
VALUES (
        'Ustadz Hidayat, S.Pd.I',
        'Kepala Sekolah',
        NULL,
        2,
        'S1 Pendidikan Islam',
        2018,
        1
    ),
    (
        'Ustadzah Rahma, S.Pd',
        'Guru Kelas 1',
        'Matematika, Bahasa Indonesia',
        2,
        'S1 PGSD',
        2019,
        1
    ),
    (
        'Ustadzah Fatimah, S.Pd.I',
        'Guru Al-Quran',
        'Tahfidz, Al-Quran',
        2,
        'S1 Pendidikan Agama Islam',
        2020,
        1
    ),
    (
        'Ustadz Arif, S.Pd',
        'Guru PAUD',
        'Semua Mata Pelajaran PAUD',
        1,
        'S1 PAUD',
        2021,
        1
    );

-- =====================================================================
-- VIEWS — Untuk query yang sering digunakan
-- =====================================================================

-- View: Ringkasan pendaftar PPDB aktif
CREATE OR REPLACE VIEW v_ringkasan_ppdb AS
SELECT
    p.id AS ppdb_id,
    ta.nama AS tahun_ajaran,
    ps.nama_program AS program,
    p.kuota AS kuota,
    COUNT(pf.id) AS total_pendaftar,
    SUM(
        CASE
            WHEN pf.status = 'diterima' THEN 1
            ELSE 0
        END
    ) AS diterima,
    SUM(
        CASE
            WHEN pf.status = 'menunggu' THEN 1
            ELSE 0
        END
    ) AS menunggu,
    SUM(
        CASE
            WHEN pf.status = 'ditolak' THEN 1
            ELSE 0
        END
    ) AS ditolak,
    SUM(
        CASE
            WHEN pf.status = 'cadangan' THEN 1
            ELSE 0
        END
    ) AS cadangan,
    (
        p.kuota - SUM(
            CASE
                WHEN pf.status = 'diterima' THEN 1
                ELSE 0
            END
        )
    ) AS sisa_kuota,
    p.status AS status_ppdb
FROM
    ppdb p
    JOIN tahun_ajaran ta ON ta.id = p.tahun_ajaran_id
    JOIN program_sekolah ps ON ps.id = p.program_id
    LEFT JOIN pendaftar pf ON pf.ppdb_id = p.id
GROUP BY
    p.id,
    ta.nama,
    ps.nama_program,
    p.kuota,
    p.status;

-- View: Berita yang sudah dipublikasikan (untuk front-end)
CREATE OR REPLACE VIEW v_berita_published AS
SELECT
    b.id,
    b.judul,
    b.slug,
    b.ringkasan,
    b.gambar_utama,
    b.kategori,
    b.tags,
    b.tanggal_publish,
    b.views,
    u.nama AS nama_penulis
FROM berita b
    JOIN users u ON u.id = b.user_id
WHERE
    b.status = 'published'
ORDER BY b.tanggal_publish DESC;

-- View: Statistik pesan kontak
CREATE OR REPLACE VIEW v_statistik_pesan AS
SELECT
    COUNT(*) AS total_pesan,
    SUM(
        CASE
            WHEN status = 'belum_dibaca' THEN 1
            ELSE 0
        END
    ) AS belum_dibaca,
    SUM(
        CASE
            WHEN status = 'sudah_dibaca' THEN 1
            ELSE 0
        END
    ) AS sudah_dibaca,
    SUM(
        CASE
            WHEN status = 'dibalas' THEN 1
            ELSE 0
        END
    ) AS sudah_dibalas
FROM kontak_pesan;

-- =====================================================================
-- STORED PROCEDURE — Generate nomor pendaftaran otomatis
-- =====================================================================
DELIMITER / /

CREATE PROCEDURE sp_generate_no_pendaftaran(
    IN  p_ppdb_id   INT UNSIGNED,
    OUT p_no_pend   VARCHAR(30)
)
BEGIN
    DECLARE v_program_kode  VARCHAR(20);
    DECLARE v_tahun         YEAR;
    DECLARE v_counter       INT;

    -- Ambil kode program dan tahun ajaran
    SELECT ps.kode_program, YEAR(ta.tanggal_mulai)
    INTO v_program_kode, v_tahun
    FROM ppdb p
    JOIN program_sekolah ps ON ps.id = p.program_id
    JOIN tahun_ajaran ta    ON ta.id = p.tahun_ajaran_id
    WHERE p.id = p_ppdb_id;

    -- Hitung urutan pendaftar untuk ppdb ini
    SELECT COUNT(*) + 1 INTO v_counter
    FROM pendaftar
    WHERE ppdb_id = p_ppdb_id;

    -- Format: DF-2025-SDIT-0001
    SET p_no_pend = CONCAT('DF-', v_tahun, '-', v_program_kode, '-', LPAD(v_counter, 4, '0'));
END //

DELIMITER;

-- =====================================================================
-- QUERY CONTOH (Sample Queries untuk keperluan operasional)
-- =====================================================================

-- Q1: Daftar semua pendaftar PPDB yang masih menunggu verifikasi
-- SELECT pf.no_pendaftaran, pf.nama_lengkap, ps.nama_program, ta.nama AS tahun_ajaran,
--        pf.telepon_ortu, pf.created_at
-- FROM pendaftar pf
-- JOIN ppdb p             ON p.id = pf.ppdb_id
-- JOIN program_sekolah ps ON ps.id = p.program_id
-- JOIN tahun_ajaran ta    ON ta.id = p.tahun_ajaran_id
-- WHERE pf.status = 'menunggu'
-- ORDER BY pf.created_at ASC;

-- Q2: Laporan rekap PPDB aktif
-- SELECT * FROM v_ringkasan_ppdb WHERE status_ppdb = 'buka';

-- Q3: Berita terbaru untuk ditampilkan di beranda (5 berita)
-- SELECT * FROM v_berita_published LIMIT 5;

-- Q4: Galeri foto terbaru untuk homepage (12 foto)
-- SELECT g.id, g.judul, g.file_path, g.kategori, g.tanggal_kegiatan
-- FROM galeri g
-- WHERE g.tipe = 'foto' AND g.is_featured = 1
-- ORDER BY g.tanggal_kegiatan DESC
-- LIMIT 12;

-- Q5: Statistik dashboard admin
-- SELECT
--     (SELECT COUNT(*) FROM pendaftar WHERE YEAR(created_at) = YEAR(NOW())) AS total_pendaftar_tahun_ini,
--     (SELECT COUNT(*) FROM berita WHERE status = 'published')              AS total_berita,
--     (SELECT COUNT(*) FROM kontak_pesan WHERE status = 'belum_dibaca')    AS pesan_belum_dibaca,
--     (SELECT SUM(jumlah_kunjungan) FROM statistik_kunjungan
--      WHERE tanggal >= DATE_SUB(CURDATE(), INTERVAL 30 DAY))              AS kunjungan_30_hari;

-- Q6: Cek status pendaftaran berdasarkan nomor pendaftaran
-- SELECT pf.no_pendaftaran, pf.nama_lengkap, pf.status,
--        ps.nama_program, ta.nama AS tahun_ajaran, pf.catatan_operator
-- FROM pendaftar pf
-- JOIN ppdb p             ON p.id = pf.ppdb_id
-- JOIN program_sekolah ps ON ps.id = p.program_id
-- JOIN tahun_ajaran ta    ON ta.id = p.tahun_ajaran_id
-- WHERE pf.no_pendaftaran = 'DF-2025-SDIT-0001';