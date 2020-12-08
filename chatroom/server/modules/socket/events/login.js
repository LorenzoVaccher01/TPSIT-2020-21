const bcrypt = require('bcrypt');

const logger = require('../../logger');
const database = require('../../database');

//TODO: scrivere nella console l'utente che ha effettuato il login
/**
 * Funzione utilizzata per verificare la validità dei dati dati dal client
 * per effettuare il login.
 * 
 * @param {*} socket socket del client
 * @param {*} data dati del client (username, password)
 */
module.exports = async (socket, data) => {
  if ((data.nickname != null && data.nickname != undefined && data.nickname != '') && (data.password != null && data.password != undefined && data.password != '')) {
    let userdb = await database.query('SELECT * FROM users WHERE nickname=' + database.escape(data.nickname));
    if (userdb.length > 0) {
      bcrypt.compare(data.password, userdb[0].password).then((result) => {
        if (result) {
          
          socket.token = userdb[0].token;
          socket.event = "login";
          require('../../../app')._CONNECTIONS.add(socket);

          socket.write(JSON.stringify({
            event: 'login',
            status: 200, 
            user: {
              id: userdb[0].id,
              imageId: userdb[0].imageId,
              name: userdb[0].name,
              surname: userdb[0].surname,
              nickname: userdb[0].nickname,
              token: userdb[0].token,
              registrationDate: userdb[0].registrationDate
            }
          }));
          database.asyncQuery('UPDATE users SET lastAccessDate=CURRENT_TIMESTAMP() WHERE id=' + userdb[0].id);
          logger.log('User &a' + userdb[0].name + ' ' + userdb[0].surname + ' &r(&aid: ' + userdb[0].id + '&r) &rhas &alogged in&r.');
        } else {
          socket.write(JSON.stringify({ event: 'login', status: 401, error: 'Password errata!' }));
        }
      });
    } else {
      socket.write(JSON.stringify({ event: 'login', status: 401, error: 'Utente inesistente!' }));
    }
  } else {
    socket.write(JSON.stringify({ event: 'login', status: 400, error: 'Nome utente o password mancanti.' }));
  }
}