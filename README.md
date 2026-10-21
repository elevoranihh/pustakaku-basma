# PustakaKu — Perpustakaan SMA Negeri 1 Banjarangkan

Starter website gratis untuk katalog buku, pengajuan peminjaman/pengembalian, dan ulasan. Website ini belum resmi sampai mendapat persetujuan sekolah dan selesai diuji.

## Isi paket
- `index.html` — antarmuka web responsif
- `supabase.sql` — skema database dan Row Level Security (RLS)
- `README.md` — panduan penerapan

## Penting tentang “tanpa login”
Siswa dapat melihat katalog, mengajukan pinjam, mengajukan pengembalian, dan mengirim ulasan tanpa akun. Karena admin tanpa login tidak aman, area admin publik sengaja tidak diberi akses untuk menyetujui transaksi atau mengubah stok. Untuk tahap awal, petugas mengelola data lewat Supabase Dashboard menggunakan akun petugas. Jika sekolah ingin admin bekerja dari website, aktifkan Supabase Auth dan role admin sebelum penggunaan resmi.

Pengajuan pinjam bukan otomatis peminjaman yang disetujui. Petugas harus memverifikasi permohonan dan mengelola stok. Ulasan baru disimpan tersembunyi sampai disetujui.

## Langkah A — Siapkan database Supabase
1. Buka https://supabase.com/ lalu buat akun dan project baru (paket gratis cukup untuk prototipe).
2. Simpan password database di tempat aman; jangan taruh dalam file website.
3. Buka **SQL Editor → New query**, salin isi `supabase.sql`, lalu jalankan.
4. Buka **Project Settings / API** (nama menu bisa berubah). Salin Project URL dan publishable key/anon key. Jangan pernah gunakan `service_role` key di browser.
5. Edit `index.html`, cari:
   - `ISI_SUPABASE_PROJECT_URL`
   - `ISI_SUPABASE_PUBLISHABLE_OR_ANON_KEY`
   Ganti masing-masing dengan URL project dan publishable/anon key.
6. Uji tabel `books` di Table Editor. Pastikan contoh buku muncul.

## Langkah B — Publikasikan gratis dengan Vercel
1. Buka https://vercel.com/ dan buat akun.
2. Buat repository GitHub baru, misalnya `pustakaku-perpustakaan`.
3. Unggah `index.html` ke akar repository. File `supabase.sql` boleh disertakan untuk dokumentasi, tetapi jangan unggah password atau secret key.
4. Di Vercel pilih **Add New → Project**, impor repository GitHub, lalu tekan **Deploy**. Untuk HTML statis tidak perlu build command.
5. Setelah deploy sukses, Vercel memberikan URL `https://...vercel.app`. Buka URL itu dari HP dan uji fitur.
6. Bila mengubah kode, commit/push ke GitHub agar Vercel melakukan deploy ulang.

## Langkah C — Buat QR Code
1. Pastikan URL Vercel berfungsi dan gunakan URL HTTPS lengkap.
2. Buat QR Code dari URL tersebut melalui generator QR tepercaya atau gunakan aplikasi pembuat QR di perangkat.
3. Uji QR dengan dua HP/perangkat berbeda sebelum dicetak.
4. Cetak di poster perpustakaan dengan teks “Scan untuk membuka katalog Perpustakaan SMA Negeri 1 Banjarangkan”.
5. Jangan buat QR dari URL lokal atau preview sementara. QR hanya akan bekerja selama URL publik masih aktif.

## Keamanan dan hal yang perlu diselesaikan sebelum dipakai resmi
- Minta izin kepala sekolah/pengelola perpustakaan untuk nama dan logo sekolah.
- Saat ini pengajuan transaksi publik tidak memakai akun. Siapa pun yang memiliki link dapat mengirim pengajuan; pertimbangkan CAPTCHA/rate limit dan verifikasi petugas.
- Kebijakan publik tidak mengizinkan pembacaan data peminjam. Pengembalian di versi awal perlu ditangani hati-hati oleh petugas; jangan menampilkan data siswa di halaman publik.
- Untuk admin web yang benar-benar aman, implementasikan Supabase Auth, role admin (mis. tabel `profiles`/claim yang tervalidasi), dan RLS yang hanya mengizinkan admin terverifikasi mengubah buku, stok, status pinjaman, serta moderasi ulasan. Jangan mengandalkan password admin yang ditulis di JavaScript.
- Uji skenario: stok habis, tanggal tidak valid, pengajuan ganda, ulasan spam, dan pengembalian salah kode.
- Buat backup berkala. Periksa batas paket gratis Supabase/Vercel karena kebijakan dapat berubah.
- Jangan masukkan NISN, nomor HP, alamat rumah, tanggal lahir, atau informasi pribadi yang tidak diperlukan.
- Website belum menjadi “resmi” secara institusional hanya karena sudah online; persetujuan sekolah tetap diperlukan.

## Batasan versi starter
- Ini bukan sistem manajemen perpustakaan produksi lengkap.
- Form pengajuan pinjam/pengembalian memerlukan petugas untuk memprosesnya.
- Pengembalian perlu dikonfirmasi petugas melalui Dashboard dan belum mengubah stok secara otomatis.
- Fitur laporan admin langsung di web, login admin, CAPTCHA, dan notifikasi belum dibuat.
