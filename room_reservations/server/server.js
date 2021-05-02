const setTZ = require('set-tz');
const express = require('express');
const app = express();
const fs = require('fs');
const http = require('http');
const https = require('https');
const session = require('express-session');
const mySQLStore = require('express-mysql-session')(session);
const useragent = require('express-useragent');
const cookieParser = require('cookie-parser');
const admin = require('firebase-admin');

const settings = require('./settings.json');
const database = require('./modules/database');
const logger = require('./modules/logger');

setTZ('UTC');

const httpServer = http.createServer(app);
const httpsServer = https.createServer({
  key: fs.readFileSync(settings.website.https.certificate.key, 'utf-8'),
  cert: fs.readFileSync(settings.website.https.certificate.cert, 'utf-8'),
  ca: fs.readFileSync(settings.website.https.certificate.ca, 'utf-8')
}, app);

/*************** FIREBASE ***************/
admin.initializeApp({
  credential: admin.credential.cert(require('./credentials.json')),
});

/*************** SESSION STORAGE ***************/
let sessionStore = new mySQLStore({
  host: settings.database.host,
  user: settings.database.user,
  port: settings.database.port,
  password: settings.database.password,
  database: settings.database.database,
  insecureAuth: settings.database.insecureAuth
});

/*************** EXPRESS SETTINGS ***************/
app.use(useragent.express());
app.use(express.json());
app.use(cookieParser());
app.disable('x-powered-by');
app.set('trust proxy', 1);
app.use('/public', express.static('public'));
app.use(express.urlencoded({ extended: true }));
app.use(session({
  secret: 'app-memo20215ICLORENZOVACCHER_@1',
  name: 'user-session',
  saveUninitialized: false,
  store: sessionStore,
  unset: 'destroy',
  resave: true,
  cookie: {
    path: '/',
    secure: true,
    httpOnly: false,
    expires: new Date(Date.now() + 60 * 60 * 1000 * 24 * 14),
    maxAge: 60 * 60 * 1000 * 24 * 14
  }
}));

/*************** ROUTES ***************/
//app.use('/', require('./routes/get'));
app.use('/', require('./routes/post'));
app.use('/api', require('./routes/api/get'));
app.use('/api', require('./routes/api/post'));
app.use('/api', require('./routes/api/delete'));
app.use('/api', require('./routes/api/put'));

/*************** ERROR MANAGER ***************/
app.use((req, res, next) => {
  res.json({error: 404, message: 'Page not found!'});
});

/*************** HTTP SERVER ***************/
httpServer.listen(settings.website.http.port, () => {
  logger.log('&aServer &eHTTP &astarted on port &e' + settings.website.http.port, 'website');
});

/*************** HTTPS SERVER ***************/
httpsServer.listen(settings.website.https.port, () => {
  logger.log('&aServer &eHTTPS &astarted on port &e' + settings.website.https.port, 'website');
});