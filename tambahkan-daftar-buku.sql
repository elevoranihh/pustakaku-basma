-- Tambahkan koleksi buku Akshara Saraswati Widya Loka
-- Aman dijalankan ulang: judul yang sudah ada (abaikan perbedaan huruf besar/kecil)
-- tidak akan dimasukkan lagi.
-- Stok awal tiap judul disetel 1 eksemplar; ubah lewat dashboard jika jumlah aslinya berbeda.
-- Jalankan di Supabase Dashboard > SQL Editor > New query > Run.
-- Jangan jalankan ulang supabase.sql atau SQL admin upgrade hanya untuk menambahkan daftar ini.

insert into public.books
  (title, author, category, description, total_copies, available_copies)
select v.title, v.author, v.category, v.description, v.total_copies, v.available_copies
from (values
  ('RPUL', 'Moh. Syamsul Hidayat, S.Pd.', 'Referensi', '', 1, 1),
  ('How to Respect Myself', 'Yoon Hong Gyun', 'Pengembangan Diri', '', 1, 1),
  ('Seorang Pendaki', 'Nugraha', 'Fiksi', '', 1, 1),
  ('Masirnya Telur Asin', 'Daryo Susmanto', 'Pengetahuan', '', 1, 1),
  ('Pintar Intisari Kata Bahasa Indonesia', 'R. Sutanto, S.Pd.', 'Bahasa', '', 1, 1),
  ('Dasar-Dasar Organisasi', 'Sutarto', 'Organisasi', '', 1, 1),
  ('From the Other World 6', 'Madoka Kawaguchi', 'Komik', '', 1, 1),
  ('Blikli Humor Paling Gokil', 'M. Haikal', 'Humor', '', 1, 1),
  ('Fun & Easy Speaking English!', 'Mr. Nandar', 'Bahasa Inggris', '', 1, 1),
  ('From Hero to Zero Survive', 'Theo Derick', 'Fiksi', '', 1, 1),
  ('The Alpha Girl''s Guide', 'Henry Manampiring', 'Pengembangan Diri', '', 1, 1),
  ('Berani Tidak Disukai', 'Ichiro Kishimi & Fumitake Koga', 'Pengembangan Diri', '', 1, 1),
  ('Sang Penjaga dan Misi yang Mustahil', 'Dave Eggers', 'Fiksi', '', 1, 1),
  ('Buku Saku Keperawatan Jiwa (Edisi 5)', 'Gail W. Stuart', 'Kesehatan', '', 1, 1),
  ('Make Time', 'Jake Knapp & John Zeratsky', 'Produktivitas', '', 1, 1),
  ('Jangan Membuat Masalah Kecil Jadi Masalah Besar', 'Richard Carlson', 'Pengembangan Diri', '', 1, 1),
  ('Ayah Edy Menjawab', 'Ayah Edy', 'Pendidikan', '', 1, 1),
  ('Rich Dad Poor Dad', 'Robert T. Kiyosaki', 'Keuangan', '', 1, 1),
  ('Obsesi Kronis', 'Eris Nufalina', 'Fiksi', '', 1, 1),
  ('Kelas Skenario: Wujudkan Ide Menjadi Naskah Film', 'Salman Aristo & Arief Ash Shiddiq', 'Film', '', 1, 1),
  ('Ragnarok', 'Lee Myung-jin', 'Komik', '', 1, 1),
  ('Legend of the Cursed Sword', 'Yeo Beop-ryong & Park Hui-jin', 'Komik', '', 1, 1),
  ('Minna no Nihongo II', '3A Corporation', 'Bahasa Jepang', '', 1, 1),
  ('Pelajaran Bahasa dan Sastra Indonesia SMK', 'Drs. Endang S.', 'Pelajaran', '', 1, 1),
  ('Siapa Sebenarnya Soeharto', 'Detak Files (Tim Redaksi)', 'Sejarah', '', 1, 1),
  ('Intisari Bahasa Inggris untuk SMA', 'Fathria Zaimah, S.Pd., Aziz Nurhuda, S.S., & Winarti, S.Pd.', 'Bahasa Inggris', '', 1, 1),
  ('Dark Psychology', 'Novita WD', 'Psikologi', '', 1, 1),
  ('Sebuah Seni untuk Bersikap Bodo Amat', 'Mark Manson', 'Pengembangan Diri', '', 1, 1),
  ('The Principles of Power', 'Dion Yulianto', 'Pengembangan Diri', '', 1, 1),
  ('Adi Dev: The First Man', 'Tidak tertera nama penulis di sampul depan', 'Komik', '', 1, 1),
  ('Miss Jinjing: Belanja Sampai Mati', 'Amelia Masniari', 'Gaya Hidup', '', 1, 1),
  ('Save My Earth', 'Saki Hiwatari', 'Komik', '', 1, 1),
  ('M&N', 'Tachibana Higuchi', 'Komik', '', 1, 1),
  ('Cerita Rakyat Asli Indonesia', 'Tidak tertera nama penulis spesifik pada sampul depan', 'Cerita Rakyat', '', 1, 1),
  ('Ghost!', 'Ichihara', 'Komik', '', 1, 1),
  ('Kasane (Book Thirteen)', 'Daruma Matsuura', 'Komik', '', 1, 1),
  ('Ensiklopedia Pengetahuan Umum: Permainan Tradisional', 'Monica Anggen', 'Referensi', '', 1, 1),
  ('Ragnarok 2', 'Lee Myung-jin', 'Komik', '', 1, 1),
  ('Ragnarok 5', 'Lee Myung-jin', 'Komik', '', 1, 1),
  ('Nakita: Kenali Gaya Pribadi Si Buah Hati', 'Tim Redaksi Nakita / Tabloid Nakita', 'Keluarga', '', 1, 1),
  ('Detektif Conan 39', 'Aoyama Gosho', 'Komik', '', 1, 1)
) as v(title, author, category, description, total_copies, available_copies)
where not exists (
  select 1
  from public.books b
  where lower(trim(b.title)) = lower(trim(v.title))
);

-- Periksa hasilnya:
select title, author, category, total_copies, available_copies
from public.books
where title in ('RPUL', 'How to Respect Myself', 'Seorang Pendaki', 'Masirnya Telur Asin', 'Pintar Intisari Kata Bahasa Indonesia', 'Dasar-Dasar Organisasi', 'From the Other World 6', 'Blikli Humor Paling Gokil', 'Fun & Easy Speaking English!', 'From Hero to Zero Survive', 'The Alpha Girl''s Guide', 'Berani Tidak Disukai', 'Sang Penjaga dan Misi yang Mustahil', 'Buku Saku Keperawatan Jiwa (Edisi 5)', 'Make Time', 'Jangan Membuat Masalah Kecil Jadi Masalah Besar', 'Ayah Edy Menjawab', 'Rich Dad Poor Dad', 'Obsesi Kronis', 'Kelas Skenario: Wujudkan Ide Menjadi Naskah Film', 'Ragnarok', 'Legend of the Cursed Sword', 'Minna no Nihongo II', 'Pelajaran Bahasa dan Sastra Indonesia SMK', 'Siapa Sebenarnya Soeharto', 'Intisari Bahasa Inggris untuk SMA', 'Dark Psychology', 'Sebuah Seni untuk Bersikap Bodo Amat', 'The Principles of Power', 'Adi Dev: The First Man', 'Miss Jinjing: Belanja Sampai Mati', 'Save My Earth', 'M&N', 'Cerita Rakyat Asli Indonesia', 'Ghost!', 'Kasane (Book Thirteen)', 'Ensiklopedia Pengetahuan Umum: Permainan Tradisional', 'Ragnarok 2', 'Ragnarok 5', 'Nakita: Kenali Gaya Pribadi Si Buah Hati', 'Detektif Conan 39')
order by title;
