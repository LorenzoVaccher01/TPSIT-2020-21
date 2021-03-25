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

router.put('/category', _checkAutentication, async (req, res, next) => {
  await logger.user('put/category', req, res);
  let categoryId = database.escape(req.query.id);
  let categoryName = database.escape(req.query.name);
  let categoryDescription = database.escape(req.query.description);

  try {
    let queryResult = await database.query(`UPDATE categories SET \`name\`=${categoryName}, description=${categoryDescription} WHERE id = ${categoryId} AND accountId IN (SELECT id FROM accounts WHERE email="${req.session.user.email}");`);
    res.json({ error: 200 });
  } catch (error) {
    logger.error(error);
    res.json({ error: 500, message: 'Internal server error' });
  }

});

router.put('/tag', _checkAutentication, async (req, res, next) => {
  await logger.user('put/tag', req, res);
  let tagId = database.escape(req.query.id);
  let tagName = database.escape(req.query.name);
  let tagDescription = database.escape(req.query.description);

  let queryResult = await database.query(`UPDATE tags SET \`name\`=${tagName}, description=${tagDescription} WHERE id = ${tagId} AND accountId IN (SELECT id FROM accounts WHERE email="${req.session.user.email}");`);
  res.json({ error: 200 });
});

router.put('/memo', _checkAutentication, async (req, res, next) => {
  await logger.user('post/memo', req, res);

  let memoId = database.escape(req.query.id);
  let title = database.escape(req.query.title);
  let body = database.escape(req.query.body);
  let categoryId = database.escape(req.query.categoryId);
  let tags = req.query.tags.toString().split(']').join('').split('[').join('').split(',');
  let accounts = req.query.accounts.split(']').join('').split('[').join('').split(' ').join('').split(',');
  let color = database.escape('#' + req.query.color);

  if (tags.length == 1 && tags[0] == '') {
    tags = [];
  }

  if (accounts.length == 1 && (accounts[0] == '' || accounts[0] == "''")) {
    accounts = [];
  }

  try {
    let memoQuery = await database.query(`UPDATE memos SET title = ${title}, body=${body}, color=${color}, categoryId=${categoryId} WHERE id = ${memoId}`);
    let deleteMemoTagAssociation = await database.query(`DELETE FROM memoTagAssociations WHERE memoId IN (
	                                                      SELECT memos.id
	                                                      FROM memos
                                                        INNER JOIN memoAccountAssociations ON memoAccountAssociations.memoId = memos.id
                                                        INNER JOIN accounts ON accounts.id = memoAccountAssociations.accountId
                                                        WHERE accounts.email = "${req.session.user.email}" AND memos.id = ${memoId}
                                                      );`);
    for (let i = 0; i < tags.length; i++) {
      await database.query(`INSERT INTO memoTagAssociations(memoId, tagId) VALUES(${memoId}, ${tags[i]});`);
    }

    let dbAccounts = await database.query(`SELECT accounts.email
                                          FROM accounts
                                          INNER JOIN memoAccountAssociations ON memoAccountAssociations.accountId = accounts.id
                                          INNER JOIN memos ON memos.id = memoAccountAssociations.memoId
                                          WHERE memos.id = ${memoId} AND NOT accounts.email = "${req.session.user.email}"`);
    let accs = [];
    let noUsers = [];
    let accountToSend = [];

    dbAccounts.forEach(el => accs.push(el.email));

    //console.log(accounts, accs);
    if (accounts != 0) {
      for (let i = 0; i < accounts.length; i++) {
        if (!accs.includes(accounts[i])) {
          let userStatus = await database.query(`SELECT COUNT(*) AS total FROM accounts WHERE email="${accounts[i]}"`);
          if (userStatus[0].total != 0 && accounts[i] != req.session.user.email) {
            console.log('ADD NEW USER: ' + accounts[i]);
            accountToSend.push(accounts[i]);
            await database.query(`INSERT INTO memoAccountAssociations(memoId, accountId) VALUES(${memoId}, (SELECT id FROM accounts WHERE email="${accounts[i]}"));`);
            require('../../modules/email').send({
              subject: 'New Memo!',
              to: [{
                email: accounts[i]
              }],
              data: {
                html: `<p>${req.session.user.name} ${req.session.user.surname} shared a new memo with you! ("${title}")</p>`
              }
            });
          } else {
            console.log('NO USER FOUND OR SAME USER: ' + accounts[i]);
            noUsers.push(accounts[i]);
          }
        } else {
          for (let j = 0; j < accs.length; j++) {
            if (!accounts.includes(accs[j])) {
              console.log('REMOVE:' + accs[j]);
              await database.query(`DELETE FROM memoAccountAssociations
                              WHERE memoId = ${memoId} AND accountId = (SELECT id FROM accounts WHERE email="${accs[j]}")`);
            } else {
              if (!accountToSend.includes(accounts[i]))
                accountToSend.push(accounts[i]);
              console.log('NO ACTION FOR: ' + accs[i]);
            }
          }
        }
      }
    } else {
      for (var i = 0; i < accs.length; i++) {
        console.log('REMOVE:' + accs[i]);
        await database.query(`DELETE FROM memoAccountAssociations
                              WHERE memoId = ${memoId} AND accountId = (SELECT id FROM accounts WHERE email="${accs[i]}")`);
      }
    }

    if (noUsers.length > 0)
      res.json({ error: 404, accounts: accountToSend, message: `Some entered users were not found in the database (${noUsers.join(',')})` });
    else
      res.json({ error: 200, message: null, accounts: accountToSend });
  } catch (err) {
    logger.error(err);
    res.json({ error: 500, message: 'Internal server error' });
  }
});

module.exports = router;