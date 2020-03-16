'use strict';

const { SwaggerAPI } = require('koa-joi-router-docs');
const misc = require('../routes/misc');
const user = require('../routes/user');

const generator = new SwaggerAPI();
generator.addJoiRouter(misc);
generator.addJoiRouter(user);

const spec = generator.generateSpec({
  info: {
    title: 'Example API',
    description: 'API for creating and editing examples.',
    version: 'v1.1'
  },
  basePath: '/',
  tags: [{
    name: 'user',
    description: `A User represents a person who can login
      and take actions subject to their granted permissions.`
  }, {
    name: 'misc',
    description: 'A miscellaneous set of APIs which describes API info, status, and etc.'
  }],
}, {
  defaultResponses: {
    200: {
      description: 'OK'
    },
    500: {
      description: 'ERROR'
    }
  }
});

exports.spec = ctx => {
  ctx.type = 'json';
  ctx.body = JSON.stringify(spec, null, '  ');
};

exports.redoc = ctx => {
  ctx.body = `
  <!DOCTYPE html>
  <html>
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Example API</title>
  </head>
  <body>
    <redoc spec-url='/spec' lazy-rendering></redoc>
    <script src="https://rebilly.github.io/ReDoc/releases/latest/redoc.min.js"></script>
  </body>
  </html>
  `;
};

exports.swagger = ctx => {
  ctx.body = `
  <!DOCTYPE html>
  <html>
  <head>
    <meta charset="UTF-8">
    <link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/swagger-ui/3.24.2/swagger-ui.css" >
    <style>
      .topbar {
        display: none;
      }
    </style>
  </head>

  <body>
    <div id="swagger-ui"></div>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/axios/0.19.2/axios.js"> </script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/swagger-ui/3.24.2/swagger-ui-bundle.js"> </script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/swagger-ui/3.24.2/swagger-ui-standalone-preset.js"> </script>

    <script>
      window.onload = async function() {
        const res = await axios.get("/spec");
        console.log(res['data']);

        const ui = SwaggerUIBundle({
          spec: res['data'],
          dom_id: '#swagger-ui',
          deepLinking: true,
          presets: [
            SwaggerUIBundle.presets.apis,
            SwaggerUIStandalonePreset
          ],
          plugins: [
            SwaggerUIBundle.plugins.DownloadUrl
          ],
          layout: "StandaloneLayout"
        })
        window.ui = ui
      }
  </script>
  </body>
  </html>
  `;
};
