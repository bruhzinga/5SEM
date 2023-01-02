//4. Разработайте приложение (клиент) 09-02, предназначенное для отправки GET-запроса с числовыми параметрами x и y.
// 5. Выведите на консоль: статус ответа, данные пересылаемые в теле ответа.
const http = require("http")
let params = {x: 10, y: 20};
const settings = {
    host: "localhost",
    path: "/task2" + `?x=${params.x}&y=${params.y}`,
    port: 3000,
    method: "GET"
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
}).end();