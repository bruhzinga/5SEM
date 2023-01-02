const http = require('http');
const fs = require('fs');
const WebSocket = require("ws");

const ws = new WebSocket('ws://localhost:4000');
ws.onmessage = message => {
    console.log(message.data);

};

let countMessages = 0;
const handler = setInterval(() => {
    ws.send(`10-01-client: ${countMessages++}`);
}, 3000);
setTimeout(() => {
    clearInterval(handler);
    ws.close(1000, 'WS closed by client');
}, 25000);
