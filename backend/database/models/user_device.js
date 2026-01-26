module.exports = (sequelize, DataTypes) => {
  const UserDevice = sequelize.define(
    'UserDevice',
    {
      user_id: DataTypes.INTEGER,
      fcm_token: DataTypes.STRING,
      platform: DataTypes.ENUM('android', 'ios', 'web'),
      is_active: {
        type: DataTypes.BOOLEAN,
        defaultValue: true,
      },
    },
    {
      tableName: 'user_devices',
      timestamps: true,
      createdAt: 'created_at',
      updatedAt: 'updated_at',
      deletedAt: 'deleted_at',
      paranoid: true,
    }
  );

  return UserDevice;
};
