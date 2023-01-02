const http = require("http")
const settings = {
    host: "localhost",
    path: "/task1",
    port: 3000,
    method: "GET" //
}
// Выведите на консоль: статус ответа, сообщение к статусу ответа, IP-адрес удаленного сервера, порт удаленного сервера, данные пересылаемые в теле ответа.
http.request(settings, res => {
    console.log('http.request: statusCode: ', res.statusCode);
    console.log('http.request: statusMessage: ', res.statusMessage);
    console.log('http.request: socket.remoteAddress: ', res.socket.remoteAddress);
    console.log('http.request: socket.remotePort: ', res.socket.remotePort);

    let data = '';
    res.on('data', (chunk) => {
        data += chunk;
    });
    res.on('end', () => {
        console.log('body:', data);
    });
}).end();