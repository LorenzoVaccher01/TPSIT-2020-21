const logger = require('../../logger');
const database = require('../../database');

/**
 * 
 * @param {*} socket 
 * @param {*} client 
 * @param {*} imageId 
 */
module.exports = async (socket, client, imageId) => {
  if ((client.id != null && client.id != undefined && client.id != '')) {
    let id = database.escape(client.id);
    let user = await database.query('SELECT COUNT(*) AS total FROM users WHERE id=' + id);
    if (user[0].total > 0) {
      database.query('UPDATE users SET imageId=' + database.escape(imageId) + ' WHERE id=' + database.escape(client.id));
      socket.write(JSON.stringify({ event: 'updateAvatar', status: 200}));
    } else {
      socket.write(JSON.stringify({ event: 'updateAvatar', status: 400, error: 'Non esistono utenti associati all\'id fornito.' }));
    }
  } else {
    socket.write(JSON.stringify({ event: 'updateAvatar', status: 400, error: 'Dato non corretto.' }));
  }
}