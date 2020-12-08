/**
 * Author: Lorenzo Vaccher
 */
const net = require('net');

const server = net.createServer();

const settings = require('./settings.json');
const database = require('./modules/database');
const logger = require('./modules/logger');

logger.clearConsole();
logger.log('&5<=============== &cChatRoom Server &5===============>');

if (settings.debug)
  logger.warn("The application was started in debug mode!");

/******* SOCKET *******/
/**
 * Variabile utilizzata per salvare tutti i sockets dei 
 * client.
 */
const _CONNECTIONS = new Set();

/**
 * 
 * @param {*} token Token dell'utente, utilizzato per identificare un singolo utente
 * @param {*} eventTarget Nei socket è salvato anche il target (event) a cui il client
 *                        punta, nella variabile "_CONNECTIONS" è possibile salvare più
 *                        sockets dello stesso utente ma con socket differenti.
 */
_CONNECTIONS.getSockets = (token, eventTarget) => {
  let sockets = [];

  _CONNECTIONS.forEach((socket) => {
    if (socket.token == token && socket.event == eventTarget) {
      sockets.push(socket);
    }
  });

  return sockets;
};

server.listen(settings.serverPort, () => {
  logger.log('Server started on port: &a' + settings.serverPort + '&r.');
});
/**
 * Evento invocato quando il server viene chiudo.
 */
server.on('close', () => {
  logger.log('Server closed.');
});

/**
 * Evento invocato quando vi è un errore nel server.
 */
server.on('error', (error) => {
  logger.error(error);
});

server.on('connection', async (socket) => {
  if (socket.token != undefined && socket.token != null) {
    let userdb = await database.query('SELECT name, surname, nickname FROM users WHERE token=' + database.escape(socket.token));
    logger.log('User &a' + userdb[0].name + ' ' + userdb[0].surname + ' &r(&a@' + userdb[0].nickname + ' &r) connected to the socket');
  } else
    logger.log('New user connected (&a' + (socket.remoteAddress).split(':')[3] + '&r)!');

  // Impostazione codifica in UTF-8
  socket.setEncoding('utf8');

  socket.on('data', async (data) => {
    data = JSON.parse(data);

    // Switch utilizzato per la suddivisione di eventi in diversi file,
    // tali eventi spesso mantengono una connessione costante con il client
    // poichè quest'ultimo necessita di aggiornamenti costanti (nuovi messaggi
    // da parte di altri utenti ecc ecc).
    switch (data.event) {
      case 'end':
        _CONNECTIONS.delete(socket);
        break;
      case 'login': require('./modules/socket/events/login')(socket, data.data); break;
      case 'registration': require('./modules/socket/events/registration')(socket, data.data); break;
      case 'chats': require('./modules/socket/data/chats').get(socket, data.client); break;
      case 'chat': require('./modules/socket/data/chat').get(socket, data.client, data.chatId, data.peerId); break;
      case 'contacts': require('./modules/socket/data/contacts')(socket, data.client); break;
      case 'deleteAccount': require('./modules/socket/events/deleteAccount')(socket, data.client); break;
      case 'updateAvatar': require('./modules/socket/events/updateAvatar')(socket, data.client, data.data.imageId); break;
      case 'message':
        let client = data.client;
        let message = data.data.message;
        let chatId = data.chatId;
        let peers = data.peers;
        if (true) { //verifficare token
          if (message != null && message != undefined && peers != null && peers != undefined && peers != '') {
            if (chatId != null) { //chat esistente
              //TODO: verificare se esiste peerId e userId
              let result = await database.query('INSERT INTO messages(text, userId, chatId) VALUES(' + database.escape(message) + ', ' + database.escape(client.id) + ', ' + database.escape(chatId) + ')');
              for (let i = 0; i < peers.length; i++) {
                let user = await database.query("SELECT token FROM users WHERE id=" + database.escape(peers[i].id));
                let image = await database.query("SELECT imageId FROM users WHERE id=" + client.id);
                let date = (await database.query("SELECT date FROM messages WHERE id=" + database.escape(result.insertId)))[0].date;
                _CONNECTIONS.getSockets(user[0].token, "chat").forEach(sock => {
                  try {
                    sock.write(JSON.stringify({
                      event: "message",
                      status: 200,
                      data: {
                        message: message,
                        id: result.insertId,
                        date: date,
                        chatId: chatId,
                        client: {
                          name: client.name,
                          surname: client.surname,
                          nickname: client.nickname,
                          id: client.id,
                          imageId: image[0].imageId
                        }
                      }
                    }));
                  } catch (error) { }
                });

                _CONNECTIONS.getSockets(user[0].token, "chats").forEach(sock => {
                  try {
                    sock.write(JSON.stringify({
                      event: "message",
                      status: 200,
                      data: {
                        id: result.insertId,
                        message: message,
                        date: date,
                        chatId: chatId,
                        client: {
                          name: client.name,
                          surname: client.surname,
                          nickname: client.nickname,
                          id: client.id,
                          imageId: client.imageId
                        }
                      }
                    }));
                  } catch (error) { }
                });
              }
              logger.log('The user &a' + client.name + ' ' + client.surname + ' &r(&a@' + client.nickname + '&r)' + ' sent a message to Pippo pluto (&a' + message + '&r) in the &achat &rwith &aid:' + chatId);
            } else { //nuova chat
              //creo nuova chat
              let chat = await database.query("INSERT INTO chats(isGroup, groupDescription, groupName) VALUES (0, null, null)");
              let ucs = await database.query("INSERT INTO userChatAssociations(userId, chatId) VALUES(" + database.escape(client.id) + ", " + database.escape(chat.insertId) + ")");
              let ucsPeer = await database.query("INSERT INTO userChatAssociations(userId, chatId) VALUES(" + database.escape(peers[0].id) + ", " + database.escape(chat.insertId) + ")");
              let messagedb = await database.query("INSERT INTO messages(text, chatId, userId) VALUES(" + database.escape(message) + ", " + database.escape(chat.insertId) + ", " + database.escape(client.id) + ")");
              logger.log("New chat created! (&aID: " + chat.insertId + "&r)");
            }
          }
        } else {
          socket.write(JSON.stringify({ event: 'message', status: 401, error: 'Non sei autorizzato a visionare queste chat!' }));
        }
        break;
    }
  });

  socket.on('end', async () => {
    if (socket.token != undefined && socket.token != null) {
      let userdb = await database.query('SELECT name, surname, nickname FROM users WHERE token=' + database.escape(socket.token));
      logger.log('User &a' + userdb[0].name + ' ' + userdb[0].surname + ' &r(&a@' + userdb[0].nickname + '&r) disconnected from the socket');
    } else
      logger.log('User disconnected (&a' + (socket.remoteAddress).split(':')[3] + '&r)!');

  });

  socket.on('error', (error) => {
    logger.error(error);
  });
});

module.exports._CONNECTIONS = _CONNECTIONS;