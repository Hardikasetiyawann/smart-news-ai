'use strict';
const bcrypt = require('bcryptjs');

/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up (queryInterface, Sequelize) {
    // Masukkan ke Database
    await queryInterface.bulkInsert('news', [{
      id: 1,
      admin_id: 1,
      category_id: 1,
      publisher_id: 1, // Simpan yang sudah di-hash
      title: 'Polda Jabar Dalami Tersangka Lain dalam Kasus Dugaan Ujaran Kebencian Resbob',
      content: 'BANDUNG, KOMPAS.TV - Kapolda Jawa Barat, Irjen Rudi Setiawan, menegaskan akan mendalami keterlibatan pihak lain dalam kasus dugaan ujaran kebencian yang menjerat YouTuber Adimas Firdaus atau Resbob. Penyelidikan difokuskan pada pihak-pihak yang turut menyebarkan konten bermuatan negatif tersebut. "Untuk tersangka lainnya, kita akan dalami kembali siapa yang bisa dijerat hukum, mungkin ada yang melakukan repost atau tindakan serupa," ujar Rudi dalam konferensi pers di Mapolda Jabar, Rabu (17/12/2025). Rudi menyatakan bahwa penyidik telah resmi menetapkan Resbob sebagai tersangka. Berdasarkan pemeriksaan, motif tersangka melakukan ujaran kebencian adalah untuk mengejar keuntungan finansial melalui sistem saweran saat melakukan tayangan langsung (live streaming). "Tersangka menyadari kontennya akan viral. Dengan jumlah penonton yang banyak, ia berharap mendapatkan sawer yang besar dan meraup keuntungan pribadi," jelas Kapolda Jabar. Kasus ini dipicu oleh tayangan pada 10 Desember 2025 yang dinilai mencederai perasaan masyarakat, khususnya etnis Sunda. Polisi menyebut konten tersebut mengandung unsur permusuhan terhadap etnis tertentu di Indonesia. Penangkapan Resbob dilakukan setelah polisi melakukan pengejaran lintas provinsi. Tersangka diketahui berpindah-pindah lokasi dari Surabaya ke Semarang, hingga akhirnya diringkus di Ungaran, Jawa Tengah, dua hari yang lalu. Saat ini, tersangka telah ditahan di Mapolda Jabar untuk proses penyidikan lebih lanjut',
      image_url: 'http://localhost:3000/uploads/news/1766325387590-92596194.jpg',
      link_news: 'https://www.kompas.tv/regional/637996/polda-jabar-dalami-tersangka-lain-dalam-kasus-dugaan-ujaran-kebencian-resbob',
      status: 'published',
      count_view: 1500,
      published_at: null,
      created_at: new Date(),
      updated_at: new Date()
    },
    {
      id: 2,
      admin_id: 1,
      category_id: 1,
      publisher_id: 1, // Simpan yang sudah di-hash
      title: 'draft Polda Jabar Dalami Tersangka Lain dalam Kasus Dugaan Ujaran Kebencian Resbob',
      content: 'draft BANDUNG, KOMPAS.TV - Kapolda Jawa Barat, Irjen Rudi Setiawan, menegaskan akan mendalami keterlibatan pihak lain dalam kasus dugaan ujaran kebencian yang menjerat YouTuber Adimas Firdaus atau Resbob. Penyelidikan difokuskan pada pihak-pihak yang turut menyebarkan konten bermuatan negatif tersebut. "Untuk tersangka lainnya, kita akan dalami kembali siapa yang bisa dijerat hukum, mungkin ada yang melakukan repost atau tindakan serupa," ujar Rudi dalam konferensi pers di Mapolda Jabar, Rabu (17/12/2025). Rudi menyatakan bahwa penyidik telah resmi menetapkan Resbob sebagai tersangka. Berdasarkan pemeriksaan, motif tersangka melakukan ujaran kebencian adalah untuk mengejar keuntungan finansial melalui sistem saweran saat melakukan tayangan langsung (live streaming). "Tersangka menyadari kontennya akan viral. Dengan jumlah penonton yang banyak, ia berharap mendapatkan sawer yang besar dan meraup keuntungan pribadi," jelas Kapolda Jabar. Kasus ini dipicu oleh tayangan pada 10 Desember 2025 yang dinilai mencederai perasaan masyarakat, khususnya etnis Sunda. Polisi menyebut konten tersebut mengandung unsur permusuhan terhadap etnis tertentu di Indonesia. Penangkapan Resbob dilakukan setelah polisi melakukan pengejaran lintas provinsi. Tersangka diketahui berpindah-pindah lokasi dari Surabaya ke Semarang, hingga akhirnya diringkus di Ungaran, Jawa Tengah, dua hari yang lalu. Saat ini, tersangka telah ditahan di Mapolda Jabar untuk proses penyidikan lebih lanjut',
      image_url: 'http://localhost:3000/uploads/news/1766325387590-92596194.jpg',
      link_news: 'https://www.kompas.tv/regional/637996/polda-jabar-dalami-tersangka-lain-dalam-kasus-dugaan-ujaran-kebencian-resbob',
      status: 'draft',
      count_view: 0,
      published_at: null,
      created_at: new Date(),
      updated_at: new Date()
    }
  ], {});
  },

  async down (queryInterface, Sequelize) {
    await queryInterface.bulkDelete('news', null, {});
  }
};