const WebSocket = require("ws");
const server = new WebSocket.Server({port: 4000}, () => {
    console.log(`WS started `)
});

server.on("connection", webSocket => {
    webSocket.on("message", message => {
        console.log(`Server ${message.toString()}`);
        server.clients.forEach(client => {
            if (client.readyState === WebSocket.OPEN) {
                client.send(message);
            }
        })
    });
    webSocket.onclose = event => console.log(event.code, event.reason);
});
