const net = require('net');

let sum = 0;

let server = net.createServer((socket) => {
    socket.on('data', (data) => {
        console.log(`Data: ${data.readInt32LE()}`);
        sum += data.readInt32LE();
    });
    let buf = Buffer.alloc(4);
    setInterval(() => {
        buf.writeInt32LE(sum,0);
        socket.write(buf);
    },5000);
    socket.on('close', () => {
        console.log('Client disconnected');
    });

    socket.on('error', (err) => {
        console.log(err);
    });

}).listen(1337, 'localhost');