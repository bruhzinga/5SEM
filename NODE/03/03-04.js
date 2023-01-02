const http = require('http');
const fs = require('fs');
let fact = (k) => {
    if(isNaN(k)) return "NaN";
    return (k === 0 ? 1 : fact(k - 1) * k);
};

function factorialTick(k, callback)
{
    this.fk = k;
    this.ffact = fact;
    this.cb = callback;
    this.calc = ()=> process.nextTick(()=>{this.cb(null, this.ffact(this.fk))})
}



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


    /*process.nextTick(() => {
        response.writeHead(200, {'Content-Type': 'application/json; charset=utf-8'});
        response.end(JSON.stringify({k: paramValue, fact:(!isNaN(paramValue)? factorial(paramValue): "NaN")}));
    });*/

    let f = new factorialTick(paramValue,(err,result)=>{response.end(JSON.stringify({ k:paramValue , fact : result}));});
    f.calc();


}).listen(5000);
console.log('Server running at http://localhost:5000/');