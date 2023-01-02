const rpcWS = require('rpc-websockets').Server;
const server = new rpcWS({port: 4000, host: 'localhost'});
server.setAuth((l) => l.login === 'admin' && l.password === '123');
server.register('square', params => {
    switch (params.length) {
        case 0:
            throw new Error('No params');
        case 1:
            return params[0] * params[0];
        case 2:
            return params[0] * params[1];
        default:
            throw new Error('Too many params');
    }

}).public();

server.register('sum', params => {
    return params.reduce((sum, nextItem) => sum + nextItem, 0);
}).public();

server.register('mul', params => {
    return params.reduce((mul, nextItem) => mul * nextItem, 1);
}).public();

server.register('fib', params => {
    switch (params.length) {
        case 0:
            throw new Error('No params');
        case 1:
            if (isNaN(params[0]) || params[0] <= 0) throw new Error('Incorrect param');
            let num = +params[0];
            if (num === 1) return [0];
            let fib = [0, 1];
            for (let i = 2; i < num; i++) {
                fib[i] = fib[i - 1] + fib[i - 2];
            }
            return fib;
        default:
            throw new Error('Too many params');

    }
}).protected();

function factorial(num) {
    if (num === 0) return 1;
    return num * factorial(num - 1);
}

server.register('fact', params => {
        if (params.length !== 1) throw new Error('Incorrect num of  params');
        if (isNaN(params[0]) || params[0] < 0) throw new Error('Incorrect param');
        let num = +params[0];
        if (num === 0) return 1;
        return factorial(num);
    }
).protected();