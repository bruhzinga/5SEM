const readline = require('readline');
const rpcWS = require('rpc-websockets').Client;

let ws = new rpcWS('ws://localhost:4000/');

const rl = readline.createInterface(
    {
        input: process.stdin,
        output: process.stdout,
        terminal: false
    });
console.log('Enter events A, B or C');

ws.on('open', () => {
    rl.on('line', line => {
        ws.notify(line).then(() => {});
    });
});