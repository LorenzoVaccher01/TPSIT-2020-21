const logger = require('../../logger');
const database = require('../../database');

/**
 * 
 */
module.exports = {
  get: async (socket, client, chatId) => {
    if (true) { //TODO: verificare se il client ha inviato un TOKEN valido
      if (chatId == null) { //New chat
        socket.write(JSON.stringify({
          event: "chat",
          status: 200,
          data: []
        }));

        socket.event = "chat";
        socket.token = client.token;
        require('../../../app')._CONNECTIONS.add(socket);
      } else {
        //TODO: inviare i messaggi anche per i gruppi
        let messages = await database.query('SELECT messages.id, messages.text, messages.date, users.id AS userId, users.name, users.surname, users.nickname, users.imageId FROM messages INNER JOIN users ON users.id = messages.userId WHERE chatId=' + chatId + ' ORDER BY date DESC');
        let data = [];

        for (let i = 0; i < messages.length; i++) {
          data.push({
            id: messages[i].id,
            date: messages[i].date,
            text: messages[i].text,
            userId: messages[i].userId,
            sender: {
              name: messages[i].name,
              surname: messages[i].surname,
              id: messages[i].userId,
              nickname: messages[i].nickname,
              imageId: messages[i].imageId
            }
          });
        }

        socket.write(JSON.stringify({
          event: "chat",
          status: 200,
          data: data
        })); //TODO: da fare

        socket.event = "chat";
        socket.token = client.token;
        require('../../../app')._CONNECTIONS.add(socket);
      }
    } else {
      socket.write(JSON.stringify({ event: 'chat', status: 401, error: 'Non sei autorizzato a visionare queste chat!' }));
    }
  }
}