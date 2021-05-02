const express = require('express');
const router = express.Router();
const admin = require('firebase-admin');

const settings = require('../settings.json');
const database = require('../modules/database');
const logger = require('../modules/logger');

/**
 * Funzione utilizzata per verificare se l'utente ha
 * l'autorizzazione ad accedere nella sezione admin.
 *
 * @param {*} req
 * @param {*} res
 * @param {*} next
 */
function _checkAutentication(req, res, next) {
  if (!(req.session.user == '' || req.session.user == undefined))
    if (req.session.user.logged)
      next();
    else
      res.json({ status: 401, message: 'You must log in before doing this operation.' });
  else
    res.json({ status: 401, message: 'You must log in before doing this operation.' });
}

router.post('/login', async (req, res, next) => {
  await logger.user('post/login', req, res);
  let token = req.body.token;
  let fcmToken = req.body.fcmToken;

  admin.auth().verifyIdToken(token).then(async (decodedToken) => {
    if (fcmToken == undefined || fcmToken == '')
      throw ("You must specify FCM Token!");


    let total = await database.query("SELECT COUNT(*) AS total FROM teachers WHERE email=" + database.escape(decodedToken.email));
    
    if (total[0].total == 0) {
      await database.query("INSERT INTO teachers(name, email, uid, fcmToken) VALUES(" + database.escape(decodedToken.name) + ", " + database.escape(decodedToken.email) + ", \"" + decodedToken.uid + "\", \"" + fcmToken + "\")");
    } else {
      await database.query(`UPDATE teachers SET fcmToken = "${fcmToken}" WHERE email = "${decodedToken.email}"`);
    }

    let isAdmin = (await database.query("SELECT isAdmin FROM teachers WHERE email=" + database.escape(decodedToken.email)))[0].isAdmin == 0 ? false : true;

    req.session.user = {
      uid: decodedToken.uid,
      fcmToken: fcmToken,
      logged: true,
      isAdmin: isAdmin,
      name: decodedToken.name,
      email: decodedToken.email,
      profileImage: decodedToken.picture,
      loginDate: new Date()
    };

    res.json({ status: 200, isAdmin: isAdmin });
  }).catch((error) => {
    console.log(error);
    res.json({ status: 500, message: error });
  });
});

router.post('/logout', async (req, res, next) => {
  await logger.user('post/logout', req, res);
  req.session.destroy((error) => {
    if (error) {
      logger.error(error);
      res.json({ status: 500, message: 'Internal server Error.' });
    } else
      res.json({ status: 200 });
  });
});

module.exports = router;
