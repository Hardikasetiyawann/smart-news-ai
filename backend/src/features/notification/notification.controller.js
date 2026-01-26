const sequelize = require('../../core/config/db');
const { Notification } = sequelize.models;

/**
 * GET /api/notifications
 */
exports.getNotifications = async (req, res) => {
  try {
    const userId = req.auth?.id;
    if (!userId) {
      return res.status(401).json({ success: false, message: 'Unauthorized' });
    }

    const limit = Number(req.query.limit) || 20;
    const offset = Number(req.query.offset) || 0;

    const data = await Notification.findAll({
      where: { user_id: userId },
      order: [['created_at', 'DESC']],
      limit,
      offset,
    });

    res.json({ success: true, data });
  } catch (err) {
    console.error('[GET NOTIFICATIONS ERROR]', err);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch notifications',
    });
  }
};

/**
 * PATCH /api/notifications/:id/read
 */
exports.markAsRead = async (req, res) => {
  try {
    const userId = req.auth?.id;
    const id = req.params.id;

    const [updated] = await Notification.update(
      { is_read: true },
      { where: { id, user_id: userId } }
    );

    if (!updated) {
      return res.status(404).json({
        success: false,
        message: 'Notification not found',
      });
    }

    res.json({ success: true, message: 'Notification marked as read' });
  } catch (err) {
    console.error('[MARK READ ERROR]', err);
    res.status(500).json({
      success: false,
      message: 'Failed to mark notification as read',
    });
  }
};

/**
 * DELETE /api/notifications/:id
 */
exports.deleteNotification = async (req, res) => {
  try {
    const userId = req.auth?.id;
    const id = req.params.id;

    const deleted = await Notification.destroy({
      where: { id, user_id: userId },
    });

    if (!deleted) {
      return res.status(404).json({
        success: false,
        message: 'Notification not found',
      });
    }

    res.json({ success: true, message: 'Notification deleted' });
  } catch (err) {
    console.error('[DELETE ERROR]', err);
    res.status(500).json({
      success: false,
      message: 'Failed to delete notification',
    });
  }
};
