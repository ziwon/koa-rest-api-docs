'use strict';

exports.getOne = async ctx => {
  ctx.body = {
    userId: ctx.params.id
  };
};

exports.postSignUp = async ctx => {
  const { username } = ctx.request.body;
  ctx.body = {
    userId: username
  };
};
