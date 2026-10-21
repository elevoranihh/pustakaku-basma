-- PustakaKu / Perpustakaan SMA Negeri 1 Banjarangkan
-- Jalankan di Supabase SQL Editor setelah membuat project.
-- Catatan: kebijakan publik ini mengizinkan pengajuan pinjam/ulasan tanpa akun.
-- Pengajuan bersifat publik; jangan simpan NISN, nomor HP, alamat, atau data sensitif.
-- Transaksi siswa tidak dapat dibaca publik. Admin mengelola melalui dashboard Supabase
-- sampai login admin + kebijakan role admin dibangun.

create extension if not exists pgcrypto;

create table if not exists public.books (
  id uuid primary key default gen_random_uuid(),
  title text not null check (char_length(title) between 1 and 200),
  author text not null default '' check (char_length(author) <= 160),
  category text not null default 'Umum' check (char_length(category) <= 80),
  description text not null default '' check (char_length(description) <= 1000),
  total_copies integer not null default 1 check (total_copies >= 0),
  available_copies integer not null default 1 check (available_copies >= 0 and available_copies <= total_copies),
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.loan_requests (
  id bigint generated always as identity primary key,
  student_name text not null check (char_length(student_name) between 1 and 100),
  class_name text not null check (char_length(class_name) between 1 and 20),
  book_id uuid not null references public.books(id),
  borrow_date date not null,
  status text not null default 'pending' check (status in ('pending','approved','borrowed','returned','rejected')),
  created_at timestamptz not null default now()
);

create table if not exists public.return_requests (
  id bigint generated always as identity primary key,
  loan_id bigint not null references public.loan_requests(id),
  status text not null default 'pending' check (status in ('pending','approved','rejected')),
  created_at timestamptz not null default now()
);

create table if not exists public.reviews (
  id uuid primary key default gen_random_uuid(),
  reviewer_name text not null check (char_length(reviewer_name) between 1 and 60),
  book_id uuid not null references public.books(id),
  rating integer not null check (rating between 1 and 5),
  comment text not null check (char_length(comment) between 1 and 1200),
  is_visible boolean not null default false,
  created_at timestamptz not null default now()
);

alter table public.books enable row level security;
alter table public.loan_requests enable row level security;
alter table public.return_requests enable row level security;
alter table public.reviews enable row level security;

-- Publik hanya boleh melihat koleksi aktif.
create policy "Public can read active books" on public.books
for select to anon, authenticated using (is_active = true);

-- Publik dapat mengirim permohonan. Tidak ada policy SELECT/UPDATE/DELETE untuk publik.
create policy "Public can submit loan requests" on public.loan_requests
for insert to anon, authenticated
with check (
  status = 'pending'
  and char_length(trim(student_name)) between 1 and 100
  and char_length(trim(class_name)) between 1 and 20
  and borrow_date >= current_date
);

-- Pengajuan pengembalian hanya dapat dibuat untuk kode transaksi yang diketahui.
-- Data transaksi tetap tidak dapat dibaca publik; petugas harus memverifikasi kode.
create policy "Public can submit return requests" on public.return_requests
for insert to anon, authenticated
with check (status = 'pending');

-- Publik hanya dapat membaca ulasan yang telah disetujui.
create policy "Public can read visible reviews" on public.reviews
for select to anon, authenticated using (is_visible = true);

-- Ulasan baru selalu disimpan tersembunyi; petugas meninjau lalu menyetel is_visible=true.
create policy "Public can submit moderated reviews" on public.reviews
for insert to anon, authenticated
with check (
  is_visible = false
  and rating between 1 and 5
  and char_length(trim(reviewer_name)) between 1 and 60
  and char_length(trim(comment)) between 1 and 1200
);

-- Contoh data buku; aman dijalankan sekali untuk demo.
insert into public.books (title,author,category,description,total_copies,available_copies)
select v.title,v.author,v.category,v.description,v.total_copies,v.available_copies
from (values
 ('Laskar Pelangi','Andrea Hirata','Fiksi','Novel tentang pendidikan dan persahabatan.',3,3),
 ('Bumi','Tere Liye','Fiksi','Novel petualangan fantasi.',2,2),
 ('Filosofi Teras','Henry Manampiring','Pengembangan Diri','Pengantar filsafat Stoikisme.',2,2),
 ('Matematika SMA','Tim Pendidikan','Pendidikan','Buku penunjang pembelajaran.',5,5)
) as v(title,author,category,description,total_copies,available_copies)
where not exists (select 1 from public.books b where b.title = v.title);

-- Petugas: gunakan Supabase Dashboard (akses pemilik project).
-- Untuk menyetujui ulasan: UPDATE public.reviews SET is_visible=true WHERE id='...';
-- Jangan pernah membuat policy publik untuk UPDATE/DELETE data transaksi atau stok.
