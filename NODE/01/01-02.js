/*Разработайте серверное приложение 01-02, возвращающее ответ с разметкой <h1>HelloWorld</h1>.*/

const http = require('http');

http.createServer( (request, response) => {
    response.writeHead(200, {'Content-Type': 'text/html'});
    response.end('<h1> Hello World</h1>\n');
}).listen(3000);




console.log('Server running at http://localhost:3000/');


