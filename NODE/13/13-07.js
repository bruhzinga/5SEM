const net = require('net');


const handler = socket => {
    socket.on('data', data => {
        console.log(`message from client: "${data.readInt32LE()}"`);
        socket.write(`ECHO: ${data.readInt32LE()}`);
    });
};

net.createServer(handler).listen(40000, () => { console.log(`TCP-server listening on port 40000...`) });
net.createServer(handler).listen(50000, () => { console.log(`TCP-server listening on port 50000...`) });
