//15. Разработайте приложение 11-04a, представляющее собой WS-клиент, демонстрирующий работоспособность сервера. Приложение принимает параметр командной строки, значение которого используется в качестве значения x, в сообщении для сервера.
// 16. Продемонстрируйте взаимодействие сервера с несколькими клиентами (клиенты должны иметь разные значения параметра).

const webSocket = require('ws');
const fs = require('fs');
let name = process.argv[2];

let WsClient = new webSocket('ws://localhost:4000');

WsClient.on('open', () => {
    let toSend = {
        client: name,
        timestamp: Date.now()
    }
    WsClient.send(JSON.stringify(toSend));
});
WsClient.on('message', data => {
    console.log(JSON.parse(data));
});
