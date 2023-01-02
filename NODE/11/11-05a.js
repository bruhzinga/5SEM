//19. Разработайте приложение 11-05a, представляющее собой WS-клиент, демонстрирующий работоспособность сервера. Приложение осуществляет следующие RPC-вызовы:
// square(3), square(5,4),
// sum(2), sum(2,4,6,8,10),
// mul(3), mul(3,5,7,9,11,13),
// fib(1), fib(2), fib(7),
// fact(0), fact(5), fact(10)

const rpcWS = require('rpc-websockets').Client;
const ws = new rpcWS('ws://localhost:4000/');


ws.on('open', () => {
    ws.login({login: 'admin', password: '1234'}).then(() => {
        ws.call('square', [3]).then(result => console.log(result));
        ws.call('square', [5, 4]).then(result => console.log(result));
        ws.call('sum', [2]).then(result => console.log(result));
        ws.call('sum', [2, 4, 6, 8, 10]).then(result => console.log(result));
        ws.call('mul', [3]).then(result => console.log(result));
        ws.call('mul', [3, 5, 7, 9, 11, 13]).then(result => console.log(result));
        ws.call('fib', [1]).then(result => console.log(result));
        ws.call('fib', [2]).then(result => console.log(result));
        ws.call('fib', [7]).then(result => console.log(result));
        ws.call('fact', [0]).then(result => console.log(result));
        ws.call('fact', [5]).then(result => console.log(result));
        ws.call('fact', [10]).then(result => console.log(result));
    }).catch(err => console.log(err));
});