const rpcWSS = require('rpc-websockets').Client;

const ws = new rpcWSS('ws://localhost:4000/');
ws.on('open', () => {
    ws.subscribe('C');
    ws.on('C', () => {
        console.log('event C')
    });
});