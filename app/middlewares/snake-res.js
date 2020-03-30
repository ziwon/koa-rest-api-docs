const debug = require('debug')('koa:cors');
const { snakeCase } = require('snake-case');

function isObject(obj) {
  if (obj !== null &&
      typeof obj === 'object' &&
      !Array.isArray(obj)) {
    return true;
  }

  return false;
}

function toSnakeCase(json) {
  for (let key in json) {
    if (json[key] && typeof json[key] === 'object') {
      json[key] = toSnakeCase(json[key]);
    }
    const val = json[key];
    delete json[key];
    json[snakeCase(key)] = val;
  }

  return json;
}

module.exports = () => {
  debug('Create a middleware');
  return async (ctx, next) => {
    await next();
    if(isObject(ctx.body) || ctx.accepts('json')) {
      ctx.body = toSnakeCase(ctx.body);
    }
  };
};
