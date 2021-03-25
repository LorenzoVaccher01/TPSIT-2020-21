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
      res.json({ error: 401, message: 'You must log in before doing this operation.' });
  else
    res.json({ error: 401, message: 'You must log in before doing this operation.' });
}

/*
router.put('/category', _checkAutentication, async (req, res, next) => {
  await logger.user('update/category', req, res);
  let categoryId = database.escape(req.query.id);
  let categoryName = database.escape(req.query.name);
  let categoryDescription = database.escape(req.query.description);

  let queryResult = await database.query(`UPDATE categories SET \`name\`=${categoryName}, description=${categoryDescription} WHERE id = ${categoryId} AND accountId IN (SELECT id FROM accounts WHERE email="${req.session.user.email}");`);
  console.log(queryResult);
});

router.put('/tag', _checkAutentication, async (req, res, next) => {
  await logger.user('update/tag', req, res);
  let tagId = database.escape(req.query.id);
  let tagName = database.escape(req.query.name);
  let tagDescription = database.escape(req.query.description);

  let queryResult = await database.query(`UPDATE tags SET \`name\`=${tagName}, description=${tagDescription} WHERE id = ${tagId} AND accountId IN (SELECT id FROM accounts WHERE email="${req.session.user.email}");`);
});

router.update('/memo', _checkAutentication, async (req, res, next) => {
  await logger.user('post/memo', req, res);
  //TODO
});
*/


module.exports = router;