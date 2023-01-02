const dgram = require('dgram');
const client = dgram.createSocket('udp4');
const PORT = 2000;

client.on('message', (message, remoteInfo) => {
    console.log(message.toString());
});

for (let i = 0; i < 10; i++) {
client.send('THIS IS AN IMPORTANT MESSAGE\0', PORT, 'localhost', err => {
    if (err) {
        client.close();
    }
})}
