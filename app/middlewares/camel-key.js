'use strict';

const debug = require('debug')('koa:cors');
const camelcase = require('camelcase-keys');

function isObject(obj) {
  if (obj !== null &&
      typeof obj === 'object' &&
      !Array.isArray(obj)) {
    return true;
  }

  return false;
}

module.exports = (options = {}) => {
  debug('Create a middleware');

  const { deep = true } = options;

  return async (ctx, next) => {
    if (isObject(ctx.request.body)) {
      ctx.request.body = camelcase(ctx.request.body, {
        deep,
      });
    }

    if (isObject(ctx.request.params)) {
      ctx.request.params = camelcase(ctx.request.params, {
        deep,
      });
    }

    if (isObject(ctx.request.query)) {
      ctx.request.query = camelcase(ctx.request.query, {
        deep,
      });
    }

    return next();
  };
};
