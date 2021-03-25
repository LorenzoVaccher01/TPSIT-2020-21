const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');

const settings = require('../settings.json');
const database = require('../modules/database');
const logger = require('../modules/logger');

/**
 * Function used to provide an access point for logging in.
 */
router.post('/login', async function (req, res, next) {
  await logger.user('post/login', req, res);
  let email = database.escape(req.body.email);
  let password = req.body.password;
  let userIp = req.ip.split(':')[req.ip.split(':').length - 1];

  if (!(email == null || email == undefined || email == 'NULL' || email == "'") && !(password == null || password == undefined || password == 'null' || password == 'NULL' || password == "'")) {
    if (settings.settings.login.enabled) {
      if (await _canDo(userIp, 'login')) {
        if ((await database.query('SELECT COUNT(*) AS total FROM accounts WHERE email=' + email))[0].total > 0) { 
          let userData = await database.query('SELECT * FROM accounts WHERE email=' + email);  
          bcrypt.compare(password, userData[0].password, (error, result) => {
              if (error)
                logger.error(error, 'website');
              else {
                if (result) {
                  req.session.user = {
                    id: userData[0].id,
                    logged: true,
                    name: userData[0].name,
                    surname: userData[0].surname,
                    email: userData[0].email,
                    registrationDate: userData[0].registrationDate
                  };

                  database.asyncQuery("DELETE FROM attempts WHERE service=\"login\" AND visitorId = (SELECT id FROM visitors WHERE lastIp=\"" + userIp + "\")");
                  res.json({ error: 200, userData: {
                    id: userData[0].id,
                    name: userData[0].name,
                    surname: userData[0].surname,
                    email: userData[0].email,
                  }});

                  logger.log("&a" + userData[0].name.charAt(0).toUpperCase() + userData[0].name.slice(1) + ' ' + userData[0].surname.charAt(0).toUpperCase() + userData[0].surname.slice(1) + "&r has logged in", "website");
                } else {
                  _addAttempt(userIp, 'login');
                  logger.warn("Visitor with &aIPV4&r: &a" + userIp + "&r tried to login to &a" + userData[0].name.charAt(0).toUpperCase() + userData[0].name.slice(1) + ' ' + userData[0].surname.charAt(0).toUpperCase() + userData[0].surname.slice(1) + "&r's account without success.", "website");
                  res.json({ error: 405, message: 'The data provided are not correct, try again.' });
                }
              }
            });
        } else {
          _addAttempt(userIp, 'login');
          logger.warn("Visitor with &aIPV4&r: &a" + userIp + "&r tried to login without success.", "website");
          res.json({ error: 405, message: 'The data provided are not correct, try again.' });
        }
      } else {
        res.json({ error: 405, message: 'You tried too many times to log-in. Try again later!' });
      }
    } else {
      res.json({ error: 405, message: 'Currently the login is disabled, if you think there is an error contact an administrator!' });
    }
  } else {
    _addAttempt(userIp, 'login');
    logger.warn("Visitor with &aIPV4&r: &a" + userIp + "&r tried to login without success.", "website");
    res.json({ error: 405, message: 'To log-in you must fill all the fields!' });
  }
});

/**
 * Function used to provide an access point for registration.
 */
router.post('/register', async (req, res, next) => {
  await logger.user('post/register', req, res);
  let name = database.escape(req.body.name);
  let surname = database.escape(req.body.surname);
  let email = database.escape(req.body.email);
  let password = req.body.password;
  let userIp = req.ip.split(':')[req.ip.split(':').length - 1];

  let isLogged = () => {
    if (req.session.user) {
      if (req.session.user.logged) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  if (!isLogged()) {
    if (!(email == null || email == undefined || email == 'NULL' || email == "'") && !(password == null || password == undefined || password == 'null' || password == 'NULL' || password == "'") && !(name == null || name == undefined || name == 'null' || name == 'NULL' || name == "'") && !(surname == null || surname == undefined || surname == 'null' || surname == 'NULL' || surname == "'")) {
      if (settings.settings.register.enabled) {
        if (await _canDo(userIp, 'register')) {
          if ((await database.query('SELECT COUNT(*) AS total FROM accounts WHERE email=' + email))[0].total == 0) {
            bcrypt.hash(password, 12, async (error, hash) => {
              if (error) {
                logger.error(error, 'website');
                res.json({ error: 500, message: 'Internal server error!' });
              }
              else {
                let newAccount = await database.query(`INSERT INTO accounts (name, surname, email, password) VALUES (${name.toLowerCase()}, ${surname.toLowerCase()}, ${email}, \"${hash}\")`);
                req.session.user = {
                  id: newAccount.insertId,
                  logged: true,
                  name: name.toLowerCase().split("'").join(""),
                  surname: surname.toLowerCase().split("'").join(""),
                  email: email.split("'").join(""),
                  registrationDate: new Date()
                };

                res.json({ error: 200, userData: {
                  id: newAccount.insertId,
                  name: name.toLowerCase().split("'").join(""),
                  surname: surname.toLowerCase().split("'").join(""),
                  email: email.split("'").join(""),
                }});
              }
            });
          } else {
            _addAttempt(userIp, 'register');
            res.json({ error: 405, message: 'There is already an account associated with this email. Please log in or register with another email.' });
          }
        } else {
          res.json({ error: 405, message: 'You tried too many times to register. Try again later!' });
        }
      } else {
        res.json({ error: 405, message: 'The registration is currently disabled, if you think there is an error contact an administrator!' });
      }
    } else {
      _addAttempt(userIp, 'register');
      logger.warn("Visitor with &aIPV4&r: &a" + userIp + "&r tried to register without success.", "website");
      res.json({ error: 405, message: 'To register you must fill all the fields!' });
    }
  } else {
    res.json({ error: 405, message: 'You are already logged in as a user!'});
  }
});

router.post('/logout', async (req, res, next) => {
  await logger.user('post/logout', req, res);
  req.session.destroy((error) => {
    if (error) {
      logger.error(error);
      res.json({ error: 500, message: 'Internal server Error.' });
    } else 
      res.json({error: 200});
  });
});

/** //TODO: traduzione
 * Funzione che verifica se un utente può accedere al server.
 * Per stabilire ciò vvengono analizzati i tentativi di accesso da parte dell'utente.
 * 
 * @param {String} ip indirizzo IPV4 del client
 * @param {String} operation operazione da eseguire
 */
async function _canDo(ip, operation) {
  //Seleziona il visitatore
  let visitor = await database.query("SELECT id FROM visitors WHERE lastIp=" + database.escape(ip));
  let blockedVisitors = await database.query("SELECT COUNT(*) as total FROM blockedVisitors WHERE service=\"" + operation + "\" AND visitorId=" + visitor[0].id);
  //TODO: tradurre
  //Se startLoginDisabledDate non è NULL vuol dire che l'utente non è ancora statto bloccato e quindi eseguo il codice sottostante,
  //se è NULL significa che l'utente è già stato bloccato e di conseguenza verifico se il tempo di attesa è trascorso o meno. 
  if (blockedVisitors[0].total == 0) {
    //TODO: tradurre
    //Seleziona i tentativi di login in base al tempo prefissto dalla pagina settings  
    let userAttempts = await database.query("SELECT * FROM attempts WHERE service=\"" + operation + "\" AND visitorId =" + visitor[0].id + " AND (`date` >= (NOW() - INTERVAL " + settings.settings[operation].attempts_time + " MINUTE));");
    if (userAttempts.length >= settings.settings[operation].attempts) {
      database.asyncQuery("INSERT INTO blockedVisitors(service, visitorId) VALUES (\"" + operation + "\", " + visitor[0].id + ")");
      database.asyncQuery("DELETE FROM attempts WHERE service=\"" + operation + "\" AND visitorId=" + visitor[0].id);
      return false;
    } else {
      return true;
    }
  } else {
    //Verifica se la data è minore rispetto al tempo inserito nel database //TODO: tradurre
    //Se è outdate allora inserisco null e ritorno true, altrimenti lascio così e ritorno false //TODO: tradurre
    let startLoginDisabledDateResult = await database.query("SELECT (CASE WHEN (`date` >= (NOW() - INTERVAL " + settings.settings[operation].attempts_time_blocked + " MINUTE)) THEN 1  ELSE 0 END) AS result FROM blockedVisitors WHERE service=\"" + operation + "\" AND visitorId =" + visitor[0].id);
    if (startLoginDisabledDateResult[0].result == '0') {
      database.asyncQuery("DELETE FROM blockedVisitors WHERE service=\"" + operation + "\" AND visitorId =" + visitor[0].id);
      return true;
    } else {
      return false;
    }
  }
}


/**
 * Funzione utilizzata per aggiungere un nuovo tentativo di login da parte 
 * di un utente al database.
 * 
 * @param {String} ip indirizzo IPV4 del client
 */
async function _addAttempt(ip, service) {
  let visitor = await database.query("SELECT id FROM visitors WHERE lastIp=" + database.escape(ip));
  await database.query("INSERT INTO attempts(service, visitorId) VALUES(\"" + service + "\", " + visitor[0].id + ")");
}


module.exports = router;