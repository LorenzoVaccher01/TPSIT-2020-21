const express = require('express');
const router = express.Router();

const settings = require('../../settings.json');
const database = require('../../modules/database');
const logger = require('../../modules/logger');

/** //TODO: tradurre
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


//router.get('/', (req, res, next) => async {});

module.exports = router;
