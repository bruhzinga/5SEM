//7. Разработайте приложение (клиент) 09-03, предназначенное для отправки POST-запроса с параметрами x, y, s.
// 8. Выведите на консоль: статус ответа, данные пересылаемые в теле ответа.
// 9. Для проверки разработайте соответствующий сервер.
const http = require("http")
const url = require("url");
const querystring = require("querystring");

const obj = {x: 1, y: 2, s: "Сообщение"};
const params = querystring.encode(obj);
const settings = {
    host: "localhost",
    path: "/task3",
    port: 3000,
    method: "POST"
}

http.request(settings, res => {
    console.log('http.request: statusCode: ', res.statusCode);

    let data = '';
    res.on('data', (chunk) => {
        data += chunk;

    });
    res.on('end', () => {
        console.log('body:', data);
    });
}).end(params);