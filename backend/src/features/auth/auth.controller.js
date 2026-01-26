const Admin = require('../admin/admin.models');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
require('dotenv').config();

exports.loginAdmin = async (req, res) => {
    try {
        const { username, password } = req.body;

        // 1. Cari Admin berdasarkan Username
        const admin = await Admin.findOne({ where: { username } });
        
        if (!admin) {
            return res.status(404).json({ 
                success: false, 
                message: "Username tidak ditemukan!" 
            });
        }

        // 2. Cek Password (Bandingkan input user dengan Hash di DB)
        const isMatch = bcrypt.compareSync(password, admin.password_hash);
        
        if (!isMatch) {
            return res.status(400).json({ 
                success: false, 
                message: "Password salah!" 
            });
        }

        // 3. Generate Token JWT
        const token = jwt.sign(
            { id: admin.id, role: 'admin' }, // Payload data
            process.env.JWT_SECRET,          // Kunci rahasia dari .env
            { expiresIn: '1d' }              // Token berlaku 1 hari
        );

        // 4. Update Last Login (Opsional tapi bagus)
        await admin.update({ last_login: new Date() });

        // 5. (BONUS) Catat ke Admin Logs
        //Pastikan Anda sudah membuat model AdminLog sebelumnya
        // await AdminLog.create({
        //     admin_id: admin.id,
        //     action: 'LOGIN',
        //     details: 'Admin berhasil login',
        //     created_at: new Date()
        // });

        // 6. Kirim Response Sukses
        res.json({
            success: true,
            message: "Login Berhasil!",
            token: token, // <-- INI YANG PENTING
            data: {
                id: admin.id,
                username: admin.username,
                full_name: admin.full_name
            }
        });

    } catch (error) {
        console.error(error);
        res.status(500).json({ success: false, message: error.message });
    }
};