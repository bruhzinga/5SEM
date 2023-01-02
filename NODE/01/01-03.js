/*
Разработайте серверное приложение 01-03, на  основе разработанных  в  задании  2,  котороев  ответе  сервера пересылает html-страницус содержимым запроса (метод, uri,... ).*/

const http = require('http');

const getHeaders = request => {
    let data = '';
    for (let key in request.headers) {
        data += `>${key}: ${request.headers[key]}<br>`;
    }

    return data;
};

http.createServer((request, response) => {

    let body = '';

    request.on('data', chunk => {
        body += chunk;
        console.log('data', body);
    });

    response.writeHead(200, {'Content-Type': 'text/html; charset=utf-08'});

    request.on('end', () => response.end(
            `<!DOCTYPE html> 
             <html lang="en">
             <head>
             <title>Lab1</title>
              </head>
              <body style="background: whitesmoke">
              
              <p>method: ${request.method}</p>
              <p>uri: ${request.url}</p>
              <p>version: ${request.httpVersion}</p>
              <p>HEADERS: ${getHeaders(request)}</p>
              <p>body: ${body}</p>
              </body>
              </html>`
        )
    )
}).listen(3000);

console.log('Server running at http://localhost:3000/');