const logger = require('../../logger');
const database = require('../../database');

module.exports = async (socket, client) => {
  if (client.id != null && client.id != undefined && client.id != '') {
    let id = database.escape(client.id);
    let user = await database.query('SELECT COUNT(*) AS total FROM users WHERE id=' + id);
    if (user[0].total > 0) {
      console.log('eliminazione'); //TODO: creare query per eliminazione account
      socket.write(JSON.stringify({ event: 'deleteAccount', status: 500, error: 'Funzione da implementare!'}));
    } else {
      socket.write(JSON.stringify({ event: 'deleteAccount', status: 400, error: 'Non esistono utenti associati all\'id fornito.' }));
    }
  } else {
    socket.write(JSON.stringify({ event: 'deleteAccount', status: 400, error: 'Dato non corretto.' }));
  }
}