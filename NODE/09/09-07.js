const form_data = require('form-data');

const http = require("http");
const fs = require("fs");

const readStream = fs.createReadStream('MyFile.png');

const form = new form_data();
form.append('filetoupload', readStream);


const req = http.request(
    {
        host: 'localhost',
        port: '3000',
        path: '/task6',
        method: 'POST',
        headers: form.getHeaders(),
    },
    response => {
        console.log(response.statusCode); // 200
    }
);

form.pipe(req);