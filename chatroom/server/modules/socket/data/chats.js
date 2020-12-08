const logger = require('../../logger');
const database = require('../../database');

/**
 * Moduli utilizzati per la gestione delle chats
 */
module.exports = {
  get: async (socket, data) => {
    if (true) { //TODO: verificare se il client ha inviato un TOKEN valido
      let userId = database.escape(data.id);
      let chatsDb = await database.query("SELECT chats.isGroup, chats.groupDescription, chats.groupName, recipients.userId, recipients.chatId, recipients.name AS userName, recipients.surname AS userSurname, recipients.nickname AS userNickname, recipients.lastAccessDate AS userLastAccessDate, recipients.imageId AS userImageId FROM	users INNER JOIN userChatAssociations ON users.id = userChatAssociations.userId INNER JOIN chats ON userChatAssociations.chatId = chats.id INNER JOIN (SELECT userChatAssociations.userId, userChatAssociations.chatId, users.name, users.surname, users.nickname, users.lastAccessDate, users.imageId FROM userChatAssociations INNER JOIN (SELECT userChatAssociations.chatId FROM userChatAssociations WHERE userChatAssociations.userId = " + userId + ") chatConUno ON chatConUno.chatId = userChatAssociations.chatId INNER JOIN users ON userChatAssociations.userId = users.id WHERE userChatAssociations.userId != " + userId + ") recipients ON recipients.chatId = userChatAssociations.chatId WHERE users.id = " + userId);
      if (chatsDb.length > 0) {
        let chats = [];

        for (let i = 0; i < chatsDb.length; i++) {
          //TODO: fare una join per il todo sotto
          let message = await database.query("SELECT messages.id, messages.text, messages.date, messages.chatId, messages.userId FROM messages INNER JOIN chats ON messages.chatId = chats.id WHERE chats.id = " + chatsDb[i].chatId + " ORDER BY messages.date DESC LIMIT 1");
          if (chatsDb[i].isGroup == 1) { //chatroom
            if (!contains(chats, chatsDb[i].chatId)) {
              chats.push({
                id: chatsDb[i].chatId,
                isGroup: true,
                groupName: chatsDb[i].groupName,
                groupDescription: chatsDb[i].groupDescription,
                message: {
                  id: message[0].id,
                  date: message[0].date,
                  text: message[0].text,
                  userId: message[0].userId,
                  sender: { //TODO: i dati non sono corretti
                    name: chatsDb[i].userName,
                    surname: chatsDb[i].userSurname,
                    id: chatsDb[i].userId,
                    nickname: chatsDb[i].userNickname,
                    imageId: chatsDb[i].userImageId
                  }
                },
                users: await database.query("SELECT users.id, users.imageId, users.name, users.surname, users.nickname FROM users INNER JOIN userChatAssociations ON userChatAssociations.userId = users.id WHERE userChatAssociations.chatId=" + chatsDb[i].chatId + " AND users.id != " + userId),
              });
            }
          } else { //chat with 2 users
            chats.push({
              id: chatsDb[i].chatId,
              isGroup: false,
              groupName: null,
              groupDescription: null,
              message: {
                id: message[0].id,
                date: message[0].date,
                text: message[0].text,
                userId: message[0].userId,
                sender: { //TODO: i dati non sono corretti
                  name: chatsDb[i].userName,
                  surname: chatsDb[i].userSurname,
                  id: chatsDb[i].userId,
                  nickname: chatsDb[i].userNickname,
                  imageId: chatsDb[i].userImageId
                }
              },
              users: [{
                id: chatsDb[i].userId,
                imageId: chatsDb[i].userImageId,
                name: chatsDb[i].userName,
                surname: chatsDb[i].userSurname
              }],
            });
          }
        }

        chats.sort((x, y) => (new Date(x.message.date).getTime() > new Date(y.message.date).getTime()) ? -1 : 1);
        socket.write(JSON.stringify({
          status: 200,
          event: 'chats',
          data: chats
        }));

        socket.event = "chats";
        socket.token = data.token;
        require('../../../app')._CONNECTIONS.add(socket);

      } else {
        socket.write(JSON.stringify({ event: 'chats', status: 204, error: 'Non hai ancora nessuna chat! Inizia a scrivere a qualcuno!' }));
      }
    } else {
      socket.write(JSON.stringify({ event: 'chats', status: 401, error: 'Non sei autorizzato a visionare queste chat!' }));
    }
  }
}

/**
 * Funzione utilizzata per verificare se è già presente una chat con un determinato 
 * id
 * 
 * @param {Array} chats 
 * @param {int} chatId 
 */
function contains(chats, chatId) {
  for (let i = 0; i < chats.length; i++) {
    if (chats[i].id == chatId) {
      return true;
    }
  }

  return false;
}