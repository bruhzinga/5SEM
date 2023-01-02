//21. Разработайте приложение 11-05b, представляющее собой WS-клиент, демонстрирующий работоспособность сервера. Приложение осуществляет параллельные (async/parallel) RPC-вызовы из п.20. Результаты вычислений отобразите в консоли приложения.

const rpcWS = require('rpc-websockets').Client;
const ws = new rpcWS('ws://localhost:4000/');
const async = require('async');

ws.on('open', () => {
    ws.login({login: 'admin', password:'123'}).then(() => {
        async.parallel([
            callback => ws.call('square', [3]).then(result => callback(null, result)).catch(err => callback(err)),
            callback => ws.call('square', [5, 4]).then(result => callback(null, result)).catch(err => callback(err)),
            callback => ws.call('sum', [2]).then(result => callback(null, result)).catch(err => callback(err)),
            callback => ws.call('sum', [2, 4, 6, 8, 10]).then(result => callback(null, result)).catch(err => callback(err)),
            callback => ws.call('mul', [3]).then(result => callback(null, result)).catch(err => callback(err)),
            callback => ws.call('mul', [3, 5, 7, 9, 11, 13]).then(result => callback(null, result)).catch(err => callback(err)),
            callback => ws.call('fib', [1]).then(result => callback(null, result)).catch(err => callback(err)),
            callback => ws.call('fib', [2]).then(result => callback(null, result)).catch(err => callback(err)),
            callback => ws.call('fib', [7,1]).then(result => callback(null, result)).catch(err => callback(err)),
            callback => ws.call('fact', [1]).then(result => callback(null, result)).catch(err => callback(err)),
            callback => ws.call('fact', [5]).then(result => callback(null, result)).catch(err => callback(err)),
            callback => ws.call('fact', [10]).then(result => callback(null, result)).catch(err => callback(err))
        ]).then(result => console.log(result)).catch(err => console.log(err))
    }).catch(err => console.log(err));
});