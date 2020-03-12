const miscRouter = require('./misc');
const specRouter = require('./spec');

const routes = [
  miscRouter.middleware(),
  specRouter.middleware(),
];

module.exports = routes;
