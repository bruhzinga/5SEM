const webSocket = require('ws');

const ws = new webSocket('ws://localhost:4000/');


ws.on('ping', (data) => {
    console.log(data.toString());
});
ws.on('message', (data) => {
    console.log(data.toString());
});
