const AdminLog = require('./admin_log.model');
const Admin = require('../admin/admin.models');

exports.getLogs = async (req, res) => {
    try {
        const logs = await AdminLog.findAll({
            order: [['created_at', 'DESC']],
            include: [
                { 
                    model: Admin, 
                    attributes: ['username', 'full_name'] 
                }
            ]
        });

        res.json({
            success: true,
            message: "Data log aktivitas berhasil dimuat",
            data: logs
        });
    } catch (error) {
        res.status(500).json({ success: false, message: error.message });
    }
};