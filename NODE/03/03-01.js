const http = require("http");
let state = 'norm';

http.createServer((request, response) => {

    response.writeHead(200, {'Content-Type': 'text/html'});

    response.end(`<h1>${state}<h1>`);

}).listen(5000, () => console.log('Start server at http://localhost:5000'));
process.stdin.setEncoding('utf-8');
process.stdin.on('readable', () => {

    let input = null;
    const states = ['norm', 'test', 'idle', 'exit', 'stop'];

    while ((input = process.stdin.read()) !== null) {
        let trimmedInput = input.trim();

        if (states.includes(trimmedInput)) {

            console.log(`${state} -> ${trimmedInput}`);
            if (trimmedInput === 'exit') {
                process.exit(0);
            } else {
                state = trimmedInput;
            }

        } else {
            console.log(`Undefined state: ${trimmedInput}`);
        }

    }
});