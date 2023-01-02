const http = require('http');
const db = require('./BD');
const fs = require('fs');
const url = require("url");


const server = http.createServer().listen(3000, () => console.log('Start server at http://localhost:3000'));

server.on('request', (req, res) => {

    console.log(req.url);
    const pathname = url.parse(req.url).pathname;
    switch (pathname) {
        case '/api/db':
            console.log(req.method);
            db.emit(req.method, req, res);
            break;
        case '/':
            fs.readFile("04.html", (err, data) => {
                if (err) {
                    console.log(err.message);
                    return;
                }
                res.end(data);
            });
            break;
        default:
            res.statusCode = 404;
            res.end("404 Not found");
            break;
    }
});


db.on('GET', (req, res) => {
    db.Select().then(data => res.end(JSON.stringify(data))).catch(() => res.end('Error'));
});
db.on('POST', (req, res) => {
    req.on('data', data => {
        const user = JSON.parse(data);
        db.Insert(user).then(() => res.end(JSON.stringify(user))).catch(() => res.end('Error'));
    })
});
db.on('PUT', (req, res) => {
    req.on('data', data => {
        const user = JSON.parse(data);
        db.Update(user)
            .then(() => res.end(JSON.stringify(user)))
            .catch(() => {
                res.end('Error')
            });
    })
});
db.on('DELETE', (req, res) => {
    const id = +url.parse(req.url, true).query.id;

    db.Delete(id)
        .then(deletedUser => res.end(JSON.stringify(deletedUser)))
        .catch(() => {
            res.end('Error')
        });
});




