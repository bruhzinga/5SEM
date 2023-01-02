const webSocket = require('ws');
const fs = require('fs');

const ws = new webSocket('ws://localhost:4000/');
const webSocketStream = webSocket.createWebSocketStream(ws);

const file = fs.createWriteStream(`./serverToClient.txt`);
webSocketStream.pipe(file);