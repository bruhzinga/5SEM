const net = require('net');

const client = net.connect({port: 2000, host: '127.0.0.1'}, () => {
    console.log('Client connected');
    client.write('Hello, server! Love, Client.');

});

client.on('data', (data) => {
    console.log(data.toString());
    client.end();
});