const rpcWS = require('rpc-websockets').Server;
const config = {port: 4000, host: 'localhost', path: '/'};

let server = new rpcWS(config);

server.register('A', () => {
    console.log('notify A');
});
server.register('B', () => {
    console.log('notify B')
});
server.register('C', () => {
    console.log('notify C')
});

