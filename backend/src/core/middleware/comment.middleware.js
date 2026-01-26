const logCommentRequest = (req, res, next) => {
  console.log(
    `${new Date().toISOString()} - COMMENT - ${req.method} ${req.originalUrl}`
  );
  next();
};

module.exports = logCommentRequest;
