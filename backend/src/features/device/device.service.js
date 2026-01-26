const sequelize = require('../../core/config/db');
const { UserDevice } = sequelize.models;
const { Op } = require('sequelize');

exports.saveToken = async (userId, fcmToken, platform) => {
  const transaction = await sequelize.transaction();

  try {
    // 🔒 Matikan token ini jika dipakai user lain
    await UserDevice.update(
      { is_active: false },
      {
        where: {
          fcm_token: fcmToken,
          user_id: { [Op.ne]: userId },
        },
        transaction,
      }
    );

    // 🔁 Upsert token user
    const [device, created] = await UserDevice.findOrCreate({
      where: { user_id: userId, fcm_token: fcmToken },
      defaults: {
        platform,
        is_active: true,
      },
      transaction,
    });

    if (!created) {
      await device.update(
        { platform, is_active: true },
        { transaction }
      );
    }

    await transaction.commit();
    return device;
  } catch (err) {
    await transaction.rollback();
    throw err;
  }
};

exports.deactivateToken = async (userId, fcmToken) => {
  await UserDevice.update(
    { is_active: false },
    { where: { user_id: userId, fcm_token: fcmToken } }
  );
};
