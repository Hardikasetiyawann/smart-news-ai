module.exports = (sequelize, DataTypes) => {
  return sequelize.define(
    "Like",
    {
      user_id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        allowNull: false,
      },
      news_id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        allowNull: false,
      },
    },
    {
      tableName: "likes",
      timestamps: false,
    }
  );
};