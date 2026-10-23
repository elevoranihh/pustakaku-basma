# PustakaKu — versi dengan fitur tambah buku

Nama tampilan: **Akshara Saraswati Widya Loka**  
Sekolah: **SMA Negeri 1 Banjarangkan**

## Isi paket
- `index.html`: katalog publik, formulir pinjam/kembali/ulasan, login petugas, dan formulir tambah buku.
- `supabase-admin-upgrade.sql`: tambahan keamanan agar hanya akun yang didaftarkan sebagai petugas yang dapat menambah buku.
- `README.md`: panduan pemasangan.

## Penting sebelum dipakai
Website ini memakai Supabase. Jangan gunakan kunci `service_role` atau `sb_secret_` di browser. Hanya Project URL dan publishable/anon key yang boleh ada di `index.html`. Kebijakan RLS tetap harus aktif.

## A. Perbarui index.html di GitHub
1. Buka repository `pustakaku-basma`.
2. Buka `index.html` → Edit (ikon pensil).
3. Ganti seluruh isi file dengan `index.html` dari paket ini.
4. Pada awal script, ganti dua placeholder berikut dengan nilai yang sudah kamu gunakan sebelumnya:
   - `ISI_SUPABASE_PROJECT_URL`
   - `ISI_SUPABASE_PUBLISHABLE_OR_ANON_KEY`
5. Jangan menaruh password admin, password database, `service_role`, atau `sb_secret_` di HTML.
6. Commit changes.

## B. Jalankan SQL tambahan
1. Buka Supabase Dashboard → SQL Editor → New query.
2. Buka `supabase-admin-upgrade.sql` dari paket ini dan salin seluruh isinya.
3. Tempel ke SQL Editor dan tekan Run.
4. Jalankan sekali saja. Jika muncul error, berhenti dan periksa pesannya sebelum mencoba lagi.

## C. Buat akun login petugas
1. Di Supabase Dashboard, buka Authentication → Users.
2. Tambahkan user baru dengan email petugas yang dikuasai sekolah dan password kuat. Jika ada opsi email confirmed, ikuti alur yang tersedia.
3. Jangan membagikan password admin ke siswa atau menyimpannya di kode.
4. Setelah akun dibuat, kembali ke SQL Editor dan jalankan query berikut dengan mengganti `EMAIL_PETUGAS_SEKOLAH` dengan email akun yang baru dibuat:

```sql
insert into public.admin_users (user_id)
select id
from auth.users
where lower(email) = lower('EMAIL_PETUGAS_SEKOLAH')
on conflict (user_id) do nothing;
```

Pastikan query memasukkan satu baris. Jika hasilnya nol baris, cek alamat email akun yang dibuat di Authentication → Users.

## D. Login dan tambah buku
1. Buka URL Vercel setelah deployment terbaru berstatus Ready.
2. Pilih tab `Petugas`.
3. Masuk memakai email dan password akun petugas tadi.
4. Isi judul, penulis, kategori, jumlah eksemplar, dan deskripsi.
5. Tekan `Simpan buku`. Buku akan masuk ke database Supabase dan muncul di katalog publik.

Jika tidak bisa menambah buku:
- pastikan SQL upgrade dijalankan;
- pastikan email akun petugas tercatat di `public.admin_users`;
- pastikan URL dan publishable/anon key di `index.html` benar;
- buka Console/Network bila memungkinkan dan periksa error;
- jangan mengatasi error dengan membuka izin insert buku untuk `anon`.

## E. Deployment
Setelah commit, Vercel biasanya membuat deployment baru otomatis. Buka Vercel → proyek → Deployments dan tunggu status Ready, lalu buka Visit. Jika tidak ada deployment baru, periksa apakah repository GitHub sudah terhubung.

## Batas versi ini
- Petugas dapat menambah buku dari website.
- Pengubahan stok, penyuntingan, penghapusan buku, dan moderasi transaksi/ulasan masih dikelola melalui Supabase Dashboard.
- Form peminjaman/pengembalian/ulasan perlu dites setelah pemasangan dan dicek kebijakan RLS sebelum dipakai siswa.
- Minta persetujuan sekolah sebelum dipakai secara resmi.


## F. Tambahkan 41 judul buku dari daftar petugas
1. Buka Supabase Dashboard untuk project perpustakaan.
2. Pilih **SQL Editor → New query**.
3. Buka file `tambahkan-daftar-buku.sql` dari paket ini, lalu salin seluruh isinya.
4. Tempel ke SQL Editor dan tekan **Run**.
5. Buka **Table Editor → books** untuk memeriksa daftar. Jika website sudah terhubung ke project Supabase yang sama, buku akan muncul di katalog tanpa perlu mengubah `index.html` atau deploy ulang.
6. Stok awal setiap judul disetel **1 eksemplar** sebagai nilai sementara. Sesuaikan di Supabase sesuai jumlah buku fisik yang benar-benar tersedia.

File SQL ini hanya menambahkan judul yang belum ada berdasarkan nama judul, sehingga aman dijalankan ulang tanpa menambahkan duplikat judul yang sama.
