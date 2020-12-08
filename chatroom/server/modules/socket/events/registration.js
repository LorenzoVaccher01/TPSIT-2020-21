const bcrypt = require('bcrypt');

const logger = require('../../logger');
const database = require('../../database');

//TODO: scrivere nella console l'utente che ha effettuato la registrazione
/**
 * Funzione utilizzata per la registrazione di un utente.
 *
 * @param {*} socket socket del client
 * @param {*} data dati del client (username, password)
 */
module.exports = async (socket, data) => {
  if ((data.password != null && data.password != undefined && data.password != '') && (data.surname != null && data.surname != undefined && data.surname != '') && (data.nickname != null && data.nickname != undefined && data.nickname != '') && (data.password != null && data.password != undefined && data.password != '') && (data.imageId != null && data.imageId != undefined && data.imageId != '')) {
    let checkUser = await database.query('SELECT COUNT(*) AS total FROM users WHERE nickname=' + database.escape(data.nickname));
    if (checkUser[0].total == 0) {
      bcrypt.hash(data.password, 10, async (error, hash) => {
        if (error) {
          logger.error(error);
          socket.write(JSON.stringify({ event: 'registration', status: 500, error: 'Si è verificato un errore.' }));
        } else {
          let token = getToken();
          let result = await database.query('INSERT INTO users(name, surname, nickname, password, token, lastAccessDate, imageId) VALUES(' + database.escape(data.name.toLowerCase().trim()) + ', ' + database.escape(data.surname.toLowerCase().trim()) + ', ' + database.escape(data.nickname.trim()) + ', \'' + hash + '\', \'' + token + '\', CURRENT_TIMESTAMP(), ' + database.escape(data.imageId) + ')');
          
          socket.token = token;
          socket.event = "registration";
          require('../../../app')._CONNECTIONS.add(socket);
          
          socket.write(JSON.stringify({
            event: 'registration',
            status: 200,
            user: {
              id: result.insertId,
              name: data.name.toLowerCase(),
              surname: data.surname.toLowerCase(),
              nickname: data.nickname,
              token: token,
              imageId: data.imageId,
              registrationDate: new Date().getTime() //TODO: inviare TIMESTAMP giusto, questo non va bene; sono solo numeri!
            }
          }));
          logger.log('&aNew registration&r carried out by &a' + data.name.substring(0, 1).toUpperCase() + data.name.substring(1) + ' ' + data.surname.substring(0, 1).toUpperCase() + data.surname.substring(1) + '&r.');
        }
      });
    } else {
      socket.write(JSON.stringify({ event: 'registration', status: 500, error: 'Nickname già in uso.' }));
    }
  } else {
    socket.write(JSON.stringify({ event: 'registration', status: 400, error: 'Dati mancanti.' }));
  }
}

function getToken() { //TODO: verificare se esiste già un token uguale nel database
  let token = "";
  let charsBanned = [58, 59, 60, 61, 62, 63, 64, 91, 92, 93, 94, 95, 96];

  let getRandomInt = (min, max) => {
    return Math.floor(Math.random() * (Math.floor(max) - Math.ceil(min) + 1) + Math.ceil(min));
  }

  do {
    let rand = getRandomInt(48, 122)
    if (!(charsBanned.includes(rand)))
      token += String.fromCharCode(rand);
  } while (token.length != 70);

  return token;
};