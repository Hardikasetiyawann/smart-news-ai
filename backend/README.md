MIGRATION

npm i : Untuk Menginstall semua depedensi/ library yang terdaftar pada package-lock.json

npx sequelize-cli db:create : Membuat Database

npx sequelize-cli migration:generate --name create-users  : Untuk Membuat Table Migration

Setelah Itu cek file Migration dan lihat file yang di generate, Kemudian Ubah file tersebut

npx sequelize-cli db:migrate : Untuk Menambahkan table ke database setelah Migration

SEEDER 

npx sequelize-cli seed:generate --name demo-admin : untuk membuat File seedernya

npx sequelize-cli db:seed:all  : Berfungsi untuk mengimport Seeder ke dalam tabel