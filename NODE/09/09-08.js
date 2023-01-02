//24. Разработайте приложение (клиент) 09-08, предназначенное для отправки GET-запроса и получения ответа с вложенным файлом.
// 25. Для проверки разработайте соответствующий сервер.

const http = require('http');
const fs = require('fs');

let options =
    {
        host: 'localhost',
        path: '/task8',
        port: 3000,
        method: 'GET'

    }

const req = http.request(options, (res) => {
    let data = '';
    res.on('data', (chunk) => {
        data += chunk;
    });
    res.on('end', () => {
        const parsedData = JSON.parse(data);
        fs.writeFile(parsedData.name, parsedData.data, (err) => {
            if (err) {
                console.log(err);
            }
        });
    });
}).end();