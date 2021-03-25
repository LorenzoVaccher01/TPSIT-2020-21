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


router.get('/memo', _checkAutentication, async (req, res, next) => {
  await logger.user('get/memo', req, res);
  let jsonMemo = [];
  let search = req.query.search;

  let memos = await database.query(`SELECT memos.*, memoAccountAssociations.isOwner, memoAccountAssociations.permission, categories.id AS categoryId, categories.name AS categoryName, categories.description AS categoryDescription, categories.creationDate AS categoryCreationDate, categories.lastModificationDate AS categoryLastModificationDate
                                    FROM memos
                                    INNER JOIN categories ON categories.id = memos.categoryId
                                    INNER JOIN memoAccountAssociations ON memoAccountAssociations.memoId = memos.id
                                    INNER JOIN accounts ON accounts.id = memoAccountAssociations.accountId
                                    WHERE accounts.email = "${req.session.user.email}" ${search != null || search != undefined ? ` AND (memos.title LIKE "%${search}%" OR memos.body LIKE "%${search}%")` : ""};`);

  for (let i = 0; i < memos.length; i++) {
    let memo = memos[i];
    let jsonTag = [];
    let jsonSharers = [];
    let tags = await database.query(`SELECT tags.*
                                  FROM tags
                                  INNER JOIN memoTagAssociations ON memoTagAssociations.tagId = tags.id
                                  INNER JOIN memos ON memos.id = memoTagAssociations.memoId
                                  WHERE memos.id = ${memo.id}`);
    
    let sharers = await database.query(`SELECT accounts.email
                                        FROM accounts
                                        INNER JOIN memoAccountAssociations ON memoAccountAssociations.accountId = accounts.id
                                        INNER JOIN memos ON memos.id = memoAccountAssociations.memoId
                                        WHERE memos.id = ${memo.id} AND NOT accounts.email = "${req.session.user.email}"`);

    tags.forEach(tag => {
      jsonTag.push({
        id: tag.id,
        name: tag.name,
        description: tag.description,
        creationDate: tag.creationDate,
        lastModificationDate: tag.lastModificationDate
      });
    });

    sharers.forEach(sharer => {
      jsonSharers.push(sharer.email);
    });

    jsonMemo.push({
      id: memo.id,
      isOwner: memo.isOwner == 1 ? true : false,
      permission: memo.permission,
      title: memo.title,
      color: memo.color,
      body: memo.body,
      creationDate: memo.creationDate,
      lastModifiedDate: memo.lastModifiedDate,
      category: {
        id: memo.categoryId,
        name: memo.categoryName,
        description: memo.categoryDescription,
        creationDate: memo.categoryCreationDate,
        lastModificationDate: memo.categoryLastModificationDate
      },
      tags: jsonTag,
      sharers: jsonSharers
    });
  }

  res.json({
    error: 200,
    data: jsonMemo
  });
});

router.get('/category', _checkAutentication, async (req, res, next) => {
  await logger.user('get/category', req, res);
  let jsonCategories = [];
  let categories = await database.query(`SELECT categories.*
                                        FROM categories
                                        WHERE id != 1 AND categories.accountId IN (SELECT id FROM accounts WHERE email = "${req.session.user.email}") ORDER BY categories.name ASC`);
  categories.forEach(category => {
    jsonCategories.push({
      id: category.id,
      name: category.name,
      description: category.description,
      creationDate: category.creationDate,
      lastModificationDate: category.lastModificationDate
    });
  });

  res.json({
    error: 200,
    data: jsonCategories
  });
});

router.get('/tag', _checkAutentication, async (req, res, next) => {
  await logger.user('get/tag', req, res);
  let jsonTags = [];
  let tags = await database.query(`SELECT tags.*
                                        FROM tags
                                        WHERE tags.accountId IN (SELECT id FROM accounts WHERE email = "${req.session.user.email}") ORDER BY tags.name ASC`);
  tags.forEach(tag => {
    jsonTags.push({
      id: tag.id,
      name: tag.name,
      description: tag.description,
      creationDate: tag.creationDate,
      lastModificationDate: tag.lastModificationDate
    });
  });

  res.json({
    error: 200,
    data: jsonTags
  });
});

module.exports = router;