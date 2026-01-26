module.exports = (sequelize, DataTypes) => {
  const Notification = sequelize.define(
    'Notification',
    {
      user_id: DataTypes.INTEGER,
      news_id: DataTypes.INTEGER,
      type: DataTypes.ENUM('broadcast', 'interaction'),
      title: DataTypes.STRING,
      body: DataTypes.TEXT,
      is_read: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
    },
    {
      tableName: 'notifications',
      timestamps: true,
      createdAt: 'created_at',
      updatedAt: 'updated_at',
      deletedAt: 'deleted_at',
      paranoid: true,
    }
  );

  return Notification;
};
