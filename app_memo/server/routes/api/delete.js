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

router.delete('/deleteCategory', _checkAutentication, async (req, res, next) => {
  await logger.user('delete/deleteCategory', req, res);
  let categoryId = database.escape(req.query.id);
  try {
    let updateQuery = await database.query(`UPDATE memos
                                    INNER JOIN memoAccountAssociations ON memoAccountAssociations.memoId = memos.id
                                    INNER JOIN accounts ON accounts.id = memoAccountAssociations.accountId
                                    SET memos.categoryId = 1
                                    WHERE memos.categoryId = ${categoryId} AND accounts.email = "${req.session.user.email}" AND memoAccountAssociations.isOwner = 1;`);
    let deleteQuery = await database.query(`DELETE FROM categories WHERE categories.id = ${categoryId} AND categories.accountId IN (SELECT id FROM accounts WHERE email = "${req.session.user.email}");`);
    res.json({
      error: 200,
      message: null
    });
  } catch (err) {
    logger.error(err);
    res.json({
      error: 500,
      message: "Internal server error"
    });
  }
});

router.delete('/deleteTag', _checkAutentication, async (req, res, next) => {
  await logger.user('delete/deleteTag', req, res);
  let tagId = database.escape(req.query.id);
  try {
    let updateQuery = await database.query(`DELETE FROM memoTagAssociations WHERE tagId = ${tagId} AND memoId IN (
	                                          SELECT memos.id
	                                          FROM memos
	                                          INNER JOIN memoAccountAssociations ON memoAccountAssociations.memoId = memos.id
	                                          INNER JOIN accounts ON accounts.id = memoAccountAssociations.accountId
	                                          WHERE accounts.email = "${req.session.user.email}"
                                            )`);
    let deleteQuery = await database.query(`DELETE FROM tags WHERE tags.id = ${tagId} AND tags.accountId IN (SELECT id FROM accounts WHERE email = "${req.session.user.email}");`);
    res.json({
      error: 200,
      message: null
    });
  } catch (err) {
    logger.error(err);
    res.json({
      error: 500,
      message: "Internal server error"
    });
  }
});

router.delete('/deleteMemo', _checkAutentication, async (req, res) => {
  await logger.user('delete/deleteMemo', req, res);
  let memoId = database.escape(req.query.id);

  try {
    let isOwner = await database.query(`SELECT isOwner FROM memoAccountAssociations WHERE memoId = ${memoId} AND accountId = (SELECT id FROM accounts WHERE email = "${req.session.user.email}")`);
    if (isOwner[0].isOwner == 1) {
      let deleteMemo = await database.query(`DELETE memo FROM memos memo
                                          INNER JOIN memoAccountAssociations ON memoAccountAssociations.memoId = memo.id
                                          INNER JOIN accounts ON accounts.id = memoAccountAssociations.accountId
                                          WHERE accounts.email = "${req.session.user.email}" AND memoAccountAssociations.isOwner = 1 AND memo.id = ${memoId};`);

      let deleteMemoTagAssociation = await database.query(`DELETE FROM memoTagAssociations WHERE memoId IN (
	                                                      SELECT memos.id
	                                                      FROM memos
                                                        INNER JOIN memoAccountAssociations ON memoAccountAssociations.memoId = memos.id
                                                        INNER JOIN accounts ON accounts.id = memoAccountAssociations.accountId
                                                        WHERE accounts.email = "${req.session.user.email}" AND memoAccountAssociations.accountId=(SELECT id FROM accounts WHERE email = "${req.session.user.email}") AND memos.id = ${memoId}
                                                      );`);
    } else {
      let deleteAss = await database.query(`DELETE FROM memoAccountAssociations
                                            WHERE accountId = (SELECT id FROM accounts WHERE email="${req.session.user.email}") AND memoId = ${memoId}`);
    }

    //let deleteMemoAccountAsssociations = await database.query(`DELETE FROM memoAccountAssociations WHERE memoId = ${memoId} AND accountId = (SELECT id FROM accounts WHERE email="${req.session.user.email}");`);

    res.json({
      error: 200,
      message: null
    });
  } catch (err) {
    logger.error(err);
    res.json({
      error: 500,
      message: "Internal server error"
    });
  }
});

module.exports = router;