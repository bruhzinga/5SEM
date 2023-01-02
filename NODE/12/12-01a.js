const rpcWS = require('rpc-websockets').Client;

const clientRPC = new rpcWS('ws://localhost:4000/');
clientRPC.on('open', () => {
    clientRPC.subscribe('change');
    clientRPC.on('change', () => {
        console.log('Change JSON file');
    });
});

