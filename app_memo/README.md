# APP Memo
Progetto che verte sulla realizzazione di una infrastruttura Client-Server che permetta la gestione (attraverso le operazioni CRUD) di alcuni memo con le relative categorie e i relativi tags. Come richiesto dalla consegna dell'esercizio sono state realizzare diverse features sia grafiche che tecniche, come per esempio il salvataggio di tutti in un server MySQL con una password criptata associata, la possibilità di modificare i colori di ogni songolo memo e così via.


Grazie all'utilizzo di un `server VPS` con sistema operativo `Ubuntu 20.04`, è stato possibile far connettere più Clients senza l'utilizzo della rete locale. L'indirizzo ip del server è il seguente: `144.91.88.65:25501`.

## Struttura del progetto
Di seguito è illustrata, attraverso un diagramma ad albero, la struttura del progetto. 

```php
+-- client          //Client in Flutter
|
+-- server          //Server in NodeJs
|
+-- database.sql    //Database
```
## Database
Per il salvataggio di tutti i memo, di tutte le categorie, di tutti i tags e di tutti gli utenti è stato utilizzato un database relazionale (MySQL) strutturato nel seguente modo:
<div align="center">
  <img src="./database.png" alt="Struttura del database" width="800px">
</div>

TODO: scrivere di bcrypt, della tabella visitors e della tabella per bloccare gli utenti

## Server
### UML
<div align="center">
  <img src="./server-uml.png" alt="Struttura classi" width="700px">
</div>

### Console
Per una miglior gestione del progetto e per il debug è stato realizzato un sistema di LOG che permette di salvare tutti gli eventi invocati mediante il modulo personalizzato `logger`. Tutte le azioni degli utenti, errori e avvisi, quindi, vengono salvati nella cartella LOG del progetto.
Qui di seguito è riportata l'immagini visiva della chat del server.
<div align="center">
  <img src="./server-console.png" alt="Console server">
</div>

### Struttura del server
``` php
+-- log/                  //Cartella che contiene tutti i LOG del server
|
+-- routes/              //Moduli del progetto
|     +-- api/
|     |     +-- delete.js     //Dati da inviare tramite socket
|     |     |
|     |     +-- get.js        //Eventi ricevuti tramite socket
|     |     |
|     |     +-- post.js        //Modulo che gestisce l'autenticazione dei clients
|     |     |
|     |     +-- put.js
|     |     |
|     |     +-- update.js
|     |     
|     +-- get.js      //Modulo per la gestione del database
|     |
|     \-- post.js       //Modulo per la gestione della console del server
|
+-- app.js                //File principale del progetto
|
+-- package.json          //File per le importazioni e i settings principali del progetto
|
\-- settings.json         //Impostazioni del database, del server ecc.

```

## Client