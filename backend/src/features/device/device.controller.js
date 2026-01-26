const service = require('./device.service');

exports.storeToken = async (req, res) => {
  try {
    const userId = req.auth?.id;
    const { fcm_token, platform } = req.body;

    if (!userId) {
      return res.status(401).json({ message: 'Unauthorized' });
    }

    if (!fcm_token || !platform) {
      return res.status(400).json({
        message: 'fcm_token and platform are required',
      });
    }

    await service.saveToken(userId, fcm_token, platform);

    res.json({ success: true, message: 'FCM token saved' });
  } catch (err) {
    console.error('[STORE DEVICE TOKEN ERROR]', err);
    res.status(500).json({ message: 'Failed to save FCM token' });
  }
};

exports.removeToken = async (req, res) => {
  try {
    const userId = req.auth?.id;
    const { fcm_token } = req.body;

    if (!userId) {
      return res.status(401).json({ message: 'Unauthorized' });
    }

    if (!fcm_token) {
      return res.status(400).json({
        message: 'fcm_token is required',
      });
    }

    await service.deactivateToken(userId, fcm_token);

    res.json({ success: true, message: 'FCM token deactivated' });
  } catch (err) {
    console.error('[REMOVE DEVICE TOKEN ERROR]', err);
    res.status(500).json({ message: 'Failed to deactivate token' });
  }
};
