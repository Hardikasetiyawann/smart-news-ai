// UBAH PATH IMPORT INI:
const AdminLog = require('../../features/admin_logs/admin_log.model'); 

exports.recordLog = async (adminId, action, details) => {
    try {
        await AdminLog.create({
            admin_id: adminId,
            action: action,
            details: details
        });
        console.log(`[AUDIT] Admin ${adminId} -> ${action}: ${details}`);
    } catch (error) {
        console.error("[AUDIT ERROR] Gagal mencatat log:", error.message);
    }
};