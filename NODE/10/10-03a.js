const WebSocket = require("ws");

const ws = new WebSocket('ws://localhost:4000');
ws.onmessage = message => {
    console.log(message.data.toString());
};

let countMessages = 0;
setInterval(() => {
    ws.send(`10-01-client: ${countMessages++}`);
}, 3000);
