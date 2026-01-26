module.exports = (sequelize, DataTypes) => {
  const NotificationSettings = sequelize.define(
    'NotificationSettings',
    {
      user_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
        unique: true,
      },
      news: {
        type: DataTypes.BOOLEAN,
        defaultValue: true,
      },
      silent: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
    },
    {
      tableName: 'notification_settings',
      timestamps: true,
      createdAt: 'created_at',
      updatedAt: 'updated_at',
    }
  );

  return NotificationSettings;
};
