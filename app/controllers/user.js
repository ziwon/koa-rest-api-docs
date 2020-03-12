exports.getOne = async ctx => {
  ctx.body = {
    userId: ctx.params.id
  };
};

exports.postSignUp = async ctx => {
  ctx.body = {
    userId: ctx.body.username
  };
};
