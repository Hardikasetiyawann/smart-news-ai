const sequelize = require('../../core/config/db');
const { NotificationSettings } = sequelize.models;

exports.getSettings = async (req, res) => {
  try {
    const userId = req.auth.id;

    let settings = await NotificationSettings.findOne({
      where: { user_id: userId },
    });

    if (!settings) {
      settings = await NotificationSettings.create({
        user_id: userId,
        news: true,
        silent: false,
      });
    }

    res.json({
      success: true,
      data: settings,
    });
  } catch (err) {
    console.error('[GET SETTINGS ERROR]', err);
    res.status(500).json({
      success: false,
      message: 'Failed to get notification settings',
    });
  }
};



exports.updateSettings = async (req, res) => {
  const userId = req.auth.id;
  const { news, like, silent } = req.body;

  const settings = await NotificationSettings.findOne({
    where: { user_id: userId },
  });

  if (!settings) {
    return res.status(404).json({ message: 'Settings not found' });
  }

  await settings.update({ news, like, silent });
  res.json(settings);
};

