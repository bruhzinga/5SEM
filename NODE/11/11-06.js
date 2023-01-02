const readline = require('readline');
const rpcWSS = require('rpc-websockets').Server;
const config = {port: 4000, host: 'localhost', path: '/'};
let server = new rpcWSS(config);

server.event('A');
server.event('B');
server.event('C');

const rl = readline.createInterface(
    {
        input: process.stdin,
        output: process.stdout,
        terminal: false
    });

console.log('Enter events A, B or C');
rl.on('line', line => {
    server.emit(line);
});
