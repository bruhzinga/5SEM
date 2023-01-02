const http = require('http');
const fs = require('fs');


const factorial = (n) => n <= 1 ? n : n * factorial(n - 1);

http.createServer( (request, response) => {
    //get url from request
    let {url} = request;
    //get parameters from request

    let params = url.split('?')[1];
    console.log(url);
    if (!params ) {
        if (url === '/html') {
            response.writeHead(200, {'Content-Type': 'text/html'});
            response.end(fs.readFileSync('03-03.html'));
            return;

        }
        response.writeHead(404, {'Content-Type': 'text/html'});
        response.end('<h1>404 Not Found</h1>\n');
        return;
    }


    //get value from parameter
    let paramValue = params.split('=')[1];

    response.writeHead(200, {'Content-Type': 'text/json'});

    response.end(JSON.stringify({k: paramValue, fact:(!isNaN(paramValue)? factorial(paramValue): "NaN")}));


}).listen(5000);
console.log('Server running at http://localhost:5000/');