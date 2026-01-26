module.exports = (sequelize, DataTypes) => {
  const UserDevice = sequelize.define(
    'UserDevice',
    {
      user_id: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },
      fcm_token: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      platform: {
        type: DataTypes.ENUM('android', 'ios', 'web'),
        allowNull: false,
      },
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
