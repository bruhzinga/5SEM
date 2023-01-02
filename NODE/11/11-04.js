//12. Разработайте приложение 11-04, представляющее собой WebSocket(WS)-север, прослушивающий порт 4000.
// 13. Сервер принимает сообщение вида:
//
// {client:x, timestamp:t}, где x-имя клиента, а t–штамп времени.
//
// Сообщение передается клиентом в json-формате.

const webSocket = require('ws');
const fs = require('fs');
const port = 4000;

const server = new webSocket.Server({port}, () => {
    console.log(`WS started on port ${port}...`)
});
let n = 0;
server.on('connection', (ws) => {
    ws.on('message', data => {
        let parsed = JSON.parse(data);
        console.log(`client: ${parsed.client}, timestamp: ${parsed.timestamp}`);
        let toSend =
            {
                server: n++,
                client: parsed.client,
                timestamp: Date.now()
            }
        ws.send(JSON.stringify(toSend));
    });
});