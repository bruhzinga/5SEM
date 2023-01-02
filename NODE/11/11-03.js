const webSocket = require('ws');
const fs = require('fs');
const port = 4000;

const server = new webSocket.Server({port}, () => {
    console.log(`WS started on port ${port}...`)
});
let n = 0;

server.on('connection', (ws) => {
    ws.on("pong", data => {
        console.log( data.toString())
    });
});
setInterval(() => {
    server.clients.forEach(client => {
        client.send(`11-03-server: ${++n}`);
    });
}, 15 * 1000);
setInterval(() => {
    server.clients.forEach(client => {
        client.ping('ping');
    });
    console.log(`server: ${server.clients.size} connected clients`)
}, 5 * 1000);