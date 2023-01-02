//22. Разработайте приложение 11-05с, представляющее собой WS-клиент, демонстрирующий работоспособность сервера. Приложение вычисляет с помощью RPC-вызовов следующее выражение:
// sum(square(3), square(5,4), mul(3,5,7,9,11,13))
// +fib(7)
// *mul(2,4,6)
//
// Результаты вычислений отобразите в консоли приложения.

const rpcWS = require('rpc-websockets').Client;
const ws = new rpcWS('ws://localhost:4000/');

ws.on('open', () => {
    ws.login({login: 'admin', password: '123'}).then(async () => {
            let sum = await ws.call('sum', [await ws.call('square', [3]), await ws.call('square', [5, 4]), await ws.call('mul', [3, 5, 7, 9, 11, 13])]);
            let mul = await ws.call('mul', [2, 4, 6]);
            let fib = (await ws.call('fib', [7]))[6];
            console.log(sum + fib * mul);

        }
    ).catch(err => console.log(err));
});