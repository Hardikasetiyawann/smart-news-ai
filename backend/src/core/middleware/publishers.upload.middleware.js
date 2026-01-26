const multer = require('multer');
const path = require('path');

// Konfigurasi penyimpanan
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, 'public/uploads/publishers'); // Pastikan folder ini ada!
    },
    filename: (req, file, cb) => {
        // Nama file: timestamp-namaasli.jpg
        cb(null, Date.now() + '-' + file.originalname);
    }
});

// Filter file (Hanya gambar)
const fileFilter = (req, file, cb) => {
    if (file.mimetype.startsWith('image/')) {
        cb(null, true);
    } else {
        cb(new Error('Hanya file gambar yang diperbolehkan!'), false);
    }
};

const upload = multer({ 
    storage: storage,
    limits: { fileSize: 10 * 1024 * 1024 } // Maksimal 2MB
});

module.exports = upload;