const http = require('http');
const fs = require('fs');
const WebSocket = require("ws");
const server = new WebSocket.Server({port: 4000}, () => {
    console.log(`WebSocket-server started http://localhost:4000`)
});


server.on("connection", ws => {
    let countMessages = 0;
    let countMessagesFromClient;

    ws.on("message", message => {
        console.log(message.toString());
        countMessagesFromClient = message.toString().split(' ')[1];
    });

    ws.onclose = event => console.log(event.code, event.reason);

    setInterval(() => {
        ws.send(`10-01-server: ${countMessagesFromClient}->${countMessages++}`);
    }, 5000);

});

http.createServer((req, res) => {
    switch (req.url) {
        case '/start':
            fs.createReadStream('./index.html').pipe(res);
            break;
        default:
            res.writeHead(400, {'Content-Type': 'text/html; charset=utf-8'});
    }
}).listen(3000, () => {
    console.log(`HTTP-Server started http://localhost:3000`);
});