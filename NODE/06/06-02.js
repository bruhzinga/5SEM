const mail = require('nodemailer');
const http = require('http');
const fs = require('fs');
const url = require('url');

SendMail = (from, password, to, message) => {
    const transport = mail.createTransport({
        service: 'Yandex',
        auth: {
            user: from,
            pass: password
        }
    });

    const option = {
        from: from,
        to: to,
        subject: '06-02',
        text: message
    };

    transport.sendMail(option, (err, info) => {
        if (err) {
            console.log(err);
        } else {
            console.log(info);
        }
    });

}

const server = http.createServer((req, res) => {
    const pathname = url.parse(req.url).pathname;
    switch (pathname) {
        case '/':
            switch (req.method) {
                case 'GET':
                    fs.readFile('index.html', (err, data) => {
                        res.end(data);
                    });
                    break;
                case 'POST':
                    let body;
                    req.on('data', (data) => {
                        body = JSON.parse(data);
                    });
                    req.on('end', () => {
                        console.log(body);
                        SendMail(body.from, body.password, body.to, body.message);
                    });
            }
            break;

        default:
            res.statusCode = 404;
            res.end("404 Not found");
    }

}).listen(3000, () => console.log('Start server at http://localhost:3000'));
