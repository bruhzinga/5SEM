const webSocket = require('ws');
const fs = require('fs');
const port = 4000;

const serverWS = new webSocket.Server({port}, () => {
    console.log(`WS started on port ${port}...`)
});

serverWS.on('connection', ws => {
    const file = fs.createReadStream('./download/serverToClient.txt');
    const webSocketStream = webSocket.createWebSocketStream(ws);
    file.pipe(webSocketStream);
});