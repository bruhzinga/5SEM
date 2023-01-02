const net = require('net');
const server = net.createServer((socket) => {
    console.log('Server created '+ socket.remoteAddress+':'+socket.remotePort);
    socket.on('data', (data) => {
        socket.write(`ECHO: ${data}`);
        console.log(`${data}`)
    });
    socket.on('close', () => {
        console.log('Server closed');
    });

    socket.on('close', () => {
        console.log('Client disconnected');
    });
}).listen(40000, '127.0.0.1');
