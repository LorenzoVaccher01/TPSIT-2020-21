const logger = require('../../logger');
const database = require('../../database');

module.exports = async (socket, data) => {
  if (true) { //TODO: verificare se il client ha inviato un TOKEN valido
    let dataToSand = [];
    let userId = database.escape(data.id);
    //TODO: inviare insieme all'utente l'id della chat, se esiste
    let users = await database.query('SELECT id, name, surname, nickname, imageId FROM users WHERE id !=' + userId + ' ORDER BY name ASC');
    for (let i = 0; i < users.length; i++) {
      let chatId = await database.query("SELECT chats.id FROM chats INNER JOIN userChatAssociations ON userChatAssociations.chatId = chats.id INNER JOIN( SELECT userChatAssociations.chatId FROM userChatAssociations WHERE userChatAssociations.userId = " + userId + " )utenteDue ON utenteDue.chatId = userChatAssociations.chatId WHERE userChatAssociations.userId = " + users[i].id + " AND chats.isGroup != 1");
      dataToSand.push({
        id: users[i].id,
        name: users[i].name,
        surname: users[i].surname,
        nickname: users[i].nickname,
        imageId: users[i].imageId,
        chatId: (chatId[0] == undefined ? null : chatId[0].id),
      });
    }
    socket.token = data.token;
    socket.event = "contacts";
    require('../../../app')._CONNECTIONS.add(socket);
    socket.write(JSON.stringify({
      event: 'contacts',
      status: 200,
      data: dataToSand
    }));
  } else {
    socket.write(JSON.stringify({ event: 'contacts', status: 401, error: 'Non sei autorizzato a visionare queste chat!' }));
  }
}