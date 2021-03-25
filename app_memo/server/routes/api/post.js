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

router.post('/category', _checkAutentication, async (req, res, next) => {
  await logger.user('post/category', req, res);
  let categoryName = database.escape(req.query.name);
  let categoryDescription = database.escape(req.query.description);

  let query = await database.query(`INSERT INTO categories(\`name\`, description, accountId) VALUES(${categoryName}, ${categoryDescription}, (SELECT id FROM accounts WHERE email="${req.session.user.email}"))`);
  res.json({
    error: 200, data: {
      id: query.insertId,
      name: categoryName,
      description: categoryDescription,
      creationDate: Date.now(),
      lastModificationDate: null
    }
  });
});

router.post('/tag', _checkAutentication, async (req, res, next) => {
  await logger.user('post/tag', req, res);
  let tagName = database.escape(req.query.name);
  let tagDescription = database.escape(req.query.description);

  let query = await database.query(`INSERT INTO tags(\`name\`, description, accountId) VALUES(${tagName}, ${tagDescription}, (SELECT id FROM accounts WHERE email="${req.session.user.email}"))`);
  res.json({
    error: 200, data: {
      id: query.insertId,
      name: tagName,
      description: tagDescription,
      creationDate: Date.now(),
      lastModificationDate: null
    }
  });
});

router.post('/memo', /*_checkAutentication,*/ async (req, res, next) => {
  await logger.user('post/memo', req, res);

  let title = database.escape(req.query.title);
  let body = database.escape(req.query.body);
  let tags = (req.query.tags).replace(']').replace('[').split(',');
  let category = database.escape(req.query.category);
  let accounts = req.query.accounts.split(']').join('').split('[').join('').split(' ').join('').split(',');
  let color = database.escape("#" + req.query.color);

  console.log(accounts);

  if (tags.length == 1 && tags[0] == '') {
    tags = [];
  }

  /*
    INSERT INTO memos(title, body, categoryId, color) VALUES("", "", 1, "#F1F1F1F1");
    INSERT INTO memoTagAssociations(memoId, tagId) VALUES();
    INSERT INTO memoAccountAssociations(memoId, accountId, isOwner, permission) VALUES();
  */
  try {
    let memoQuery = await database.query(`INSERT INTO memos(title, body, categoryId, color) VALUES(${title}, ${body}, ${category}, ${color})`);
    let accountQuery = await database.query(`INSERT INTO memoAccountAssociations(memoId, accountId, isOwner, permission) VALUES(${memoQuery.insertId}, (SELECT id FROM accounts WHERE email="${req.session.user.email}"), 1, 2);`);
    
    for (let i = 0; i < tags.length; i++) {
      await database.query(`INSERT INTO memoTagAssociations(memoId, tagId) VALUES(${memoQuery.insertId}, ${tags[i]});`);
    }

    for (let i = 0; i < accounts.length; i++) {
      let userStatus = await database.query(`SELECT COUNT(*) AS total FROM accounts WHERE email="${accounts[i]}"`);
      if (userStatus[0].total != 0) {
        await database.query(`INSERT INTO memoAccountAssociations(memoId, accountId) VALUES(${memoQuery.insertId}, (SELECT id FROM accounts WHERE email="${accounts[i]}"));`);
        require('../../modules/email').send({
          subject: 'New Memo!',
          to: [{
            email: accounts[i]
          }],
          data: {
            html: `<p>${req.session.user.name} ${req.session.user.surname} shared a new memo with you! ("${title}")</p>`
          }
        });
      }
    }

    res.json({ error: 200, message: null });
  } catch (e) {
    logger.error(e, 'website');
    res.json({ error: 500, message: 'Internal server error' });
  }
});


module.exports = router;