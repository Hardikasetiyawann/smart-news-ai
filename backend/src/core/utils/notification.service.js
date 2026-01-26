const sequelize = require('../config/db');
const { UserDevice, Notification, NotificationSettings } = sequelize.models;
const admin = require('../config/firebase');


function stringifyData(data = {}) {
  const result = {};
  for (const key in data) result[key] = String(data[key]);
  return result;
}

async function handleInvalidTokens(response, tokens, transaction) {
  const invalidTokens = [];

  response.responses.forEach((res, idx) => {
    if (!res.success) {
      const code = res.error?.code;
      if (
        code === 'messaging/registration-token-not-registered' ||
        code === 'messaging/invalid-registration-token'
      ) {
        invalidTokens.push(tokens[idx]);
      }
    }
  });

  if (invalidTokens.length) {
    await UserDevice.update(
      { is_active: false },
      { where: { fcm_token: invalidTokens }, transaction }
    );
  }
}

/**
 * 🔔 Broadcast notification (news published)
 */
async function sendBroadcastNotification({ title, body, data = {} }) {
  const devices = await UserDevice.findAll({
    where: { is_active: true },
  });

  if (!devices.length) return;

  const transaction = await sequelize.transaction();

  try {
    for (const device of devices) {

      const settings =
        (await NotificationSettings.findOne({
          where: { user_id: device.user_id },
        })) ?? { news: true, silent: false };


      await Notification.create(
        {
          user_id: device.user_id,
          news_id: data.news_id ?? null,
          type: 'broadcast',
          title,
          body,
        },
        { transaction }
      );

      if (settings?.silent) continue;

      if (settings && !settings.news) continue;

      await admin.messaging().send({
        token: device.fcm_token,
        notification: { title, body },
        data: stringifyData(data),
      });
    }

    await transaction.commit();
  } catch (err) {
    await transaction.rollback();
    console.error('[Broadcast Notification Error]', err);
  }
}


/**
 * 👤 User-specific notification (like, comment, reply)
 */
async function sendUserNotification(userId, payload) {
  const devices = await UserDevice.findAll({
    where: { user_id: userId, is_active: true },
  });

  if (!devices.length) return;

  const transaction = await sequelize.transaction();

  try {
    const settings = await NotificationSettings.findOne({
      where: { user_id: userId },
    });

    await Notification.bulkCreate(
      devices.map(() => ({
        user_id: userId,
        news_id: payload.data?.news_id ?? null,
        type: 'interaction',
        title: payload.title,
        body: payload.body,
      })),
      { transaction }
    );

    if (settings?.silent) {
      await transaction.commit();
      return;
    }

    const tokens = devices.map(d => d.fcm_token);

    const response = await admin.messaging().sendEachForMulticast({
      tokens,
      notification: {
        title: payload.title,
        body: payload.body,
      },
      data: stringifyData(payload.data || {}),
    });

    await handleInvalidTokens(response, tokens, transaction);
    await transaction.commit();
  } catch (err) {
    await transaction.rollback();
    console.error('[User Notification Error]', err);
  }
}


module.exports = {
  sendBroadcastNotification,
  sendUserNotification,
};
