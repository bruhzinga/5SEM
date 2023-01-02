//10. Разработайте приложение (клиент) 09-04, предназначенное для отправки POST-запроса с данными в json-формате и обработки ответа в json-формате.
// 11. Используйте структуры данных в запросах и ответах из задания 10 лабораторной работы 8.
// 12. Для проверки разработайте соответствующий сервер.
// 13. Выведите на консоль: статус ответа, данные пересылаемые в теле ответа.

const http = require("http")
const url = require("url");

const obj = {
    __comment: "Запрос.Лабораторная работа 8/10",
    x: 1,
    y: 2,
    s: "Сообщение",
    m: ["a", "b", "c", "d"],
    o: {"surname": "Иванов", name: "Иван"}
};

const options = {
    host: "localhost",
    path: "/task4",
    port: 3000,
    method: "POST",
}

const req = http.request(options, res => {
    console.log('http.request: statusCode: ', res.statusCode);

    let data = '';
    res.on('data', (chunk) => {
        data += chunk;

    });
    res.on('end', () => {
        console.log('body:', JSON.parse(data));
    });
}).end(JSON.stringify(obj));