-- PustakaKu: upgrade aman agar petugas bisa menambah buku dari website.
-- Jalankan SEKALI di Supabase SQL Editor setelah schema awal (supabase.sql) selesai.
-- Jangan memasukkan service_role/secret key ke file HTML.

create schema if not exists private;

create table if not exists public.admin_users (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

alter table public.admin_users enable row level security;
revoke all on table public.admin_users from anon, authenticated;

create or replace function private.is_library_admin()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.admin_users
    where user_id = (select auth.uid())
  );
$$;

revoke all on function private.is_library_admin() from public;
grant usage on schema private to authenticated;
grant execute on function private.is_library_admin() to authenticated;

-- Pastikan pembaca publik hanya dapat membaca buku aktif.
-- Kebijakan baca awal "Public can read active books" tetap dipakai.
grant select on public.books to anon, authenticated;
grant insert on public.books to authenticated;

drop policy if exists "Library admins can add books" on public.books;
create policy "Library admins can add books"
on public.books
for insert
to authenticated
with check ((select private.is_library_admin()));

-- Tidak membuat policy publik untuk mengubah/menghapus koleksi.
-- Pengubahan stok dan penghapusan tetap melalui dashboard Supabase oleh pemilik proyek.
