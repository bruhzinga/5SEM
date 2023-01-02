const net = require('net');
let ConnectionMap = new Map();
const server = net.createServer((socket) => {
    socket.id = socket.remoteAddress+socket.remotePort;
    ConnectionMap.set(socket.id, 0);
    socket.on('data', (data) => {
        console.log(`Data: ${data.readInt32LE()}`);
        let currentSum = ConnectionMap.get(socket.id);
        currentSum += data.readInt32LE();
        ConnectionMap.set(socket.id, currentSum);
    });
    let buf = Buffer.alloc(4);
    setInterval(() => {
        buf.writeInt32LE(ConnectionMap.get(socket.id),0);
        socket.write(buf);
    },5000);

}).listen(2000, 'localhost');
