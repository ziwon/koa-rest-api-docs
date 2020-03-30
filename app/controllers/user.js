'use strict';

exports.getOne = async ctx => {
  ctx.log.debug(ctx.request.params);

  ctx.state.user = {
    userId: ctx.params.id
  };
  ctx.body = {
    userId: ctx.params.id
  };
};

exports.postSignUp = async ctx => {
  ctx.log.debug(ctx.request.body);

  const { username } = ctx.request.body;
  ctx.body = {
    userId: username
  };
};
