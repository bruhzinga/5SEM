const net  = require('net');

let client = new net.Socket();
let buf = Buffer.alloc(4);
let timerId = null;

client.connect(2000, 'localhost', () => {
    console.log('Connected');
    let k =0;
    timerId = setInterval(() => {
        client.write((buf.writeInt32LE(k++,0),buf));
    }, 1000);
});
client.on('data', (data) => {
    console.log(`Received: ${data.readInt32LE()}`);
});

setTimeout(() => {
    client.destroy();
    clearInterval(timerId);
},20000);