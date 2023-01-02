//4. Разработайте приложение 11-01a, представляющее собой WS-клиент, демонстрирующий работоспособность сервера
const webSocket = require('ws');
const fs = require('fs');

const ws = new webSocket('ws://localhost:4000');
const webSocketStream = webSocket.createWebSocketStream(ws);
const file = fs.createReadStream('./clientToServer.txt');

file.pipe(webSocketStream);