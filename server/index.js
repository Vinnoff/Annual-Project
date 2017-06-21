const express = require('express');
const api = express();

require('./settings')(api);
console.log('>> Settings initialized');
require('./models')(api);
console.log('>> Models initialized');
require('./middlewares')(api);
console.log('>> Middleware initialized');
require('./actions')(api);
console.log('>> Actions initialized');
require('./routes')(api);
console.log('>> Routes initialized');

console.log(`Server started and listening on port ${api.settings.port}`)
console.log(`Good Job`)
api.listen(api.settings.port);
