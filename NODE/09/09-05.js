//15. Разработайте приложение (клиент) 09-05, предназначенное для отправки POST-запроса с данными в xml-формате и обработки ответа в xml-формате.
// 16. Используйте структуры данных в запросах и ответах из задания 11 лабораторной работы 8.
// 17. Для проверки разработайте соответствующий сервер.

const http = require("http");
const url = require("url");
const xml2js = require("xml2js");

const XML = `<request id = "28">
    <x value = "1"/>
    <x value = "2"/>
    <m value = "a"/>
    <m value = "b"/>
    <m value = "c"/>
</request>`
const settings = {
    host: "localhost",
    port: 3000,
    path: "/task5",
    method: "POST",
}

const request = http.request(settings, (res) => {
    let data = "";
    res.on("data", (chunk) => {
        data += chunk;
    });
    res.on("end", () => {

        console.log(data);
    });

}).end(XML);
