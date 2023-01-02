const http = require('http');
const db = require('./BD');
const fs = require('fs');
const url = require("url");

class statistic {
    constructor() {
        this.statsEnabled = false;
        this.startDate = '';
        this.finishDate = '-';
        this.requestsCount = 0;
        this.commitsCount = 0;
    }

    reset() {
        this.statsEnabled = false;
        this.startDate = '';
        this.finishDate = '-';
        this.requestsCount = 0;
        this.commitsCount = 0;
    }

}

statistics = new statistic();


const server = http.createServer().listen(3000, () => console.log('Start server at http://localhost:3000'));

server.on('request', (req, res) => {
    if (statistics.statsEnabled) statistics.requestsCount++;
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
        case '/api/ss':
            res.writeHead(200, {'Content-Type': 'application/json; charset=utf-8'});
            res.end(JSON.stringify(statistics));
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
db.on('COMMIT', () => {
        db.Commit();
        if (statistics.statsEnabled) {
            statistics.commitsCount++;
        }

        console.log('COMMITTED');
    }
);

let sd_timer = null;
let sc_timer = null;
let ss_timer = null;
let num = 0;

process.stdin.setEncoding('utf-8');
process.stdin.on('readable', () => {

    let input = null;
    while ((input = process.stdin.read()) !== null) {
        let chunkedInput = input.trim().split(' ');
        switch (chunkedInput[0]) {
            default:
                console.log('Unknown command');
                break;
            case 'sd':
                if (sd_timer != null && chunkedInput.length === 1) {
                    console.log('shut down server timer was cleared');
                    clearInterval(sd_timer);
                    sd_timer = null;
                }
                num = +chunkedInput[1];
                if (chunkedInput.length > 1 && !isNaN(num)) {
                    console.log(`server will be shut down in ${num} seconds`);
                    sd_timer = setTimeout(() => {
                        server.close();
                        console.log('Server was shut down');
                        process.stdin.unref();

                    }, num * 1000);
                } else if (chunkedInput.length > 1 && isNaN(num)) {
                    console.log('sd command must be followed by a number');
                }
                break;
            case "sc":
                if (chunkedInput.length === 1) {
                    clearInterval(sc_timer);
                    sc_timer = null;
                    console.log("commit timer was cleared");
                    break;
                }
                num = +chunkedInput[1];
                if (!isNaN(num)) {
                    console.log(`commit will be executed every ${num} seconds`);
                    sc_timer = setInterval(() => {
                        db.emit('COMMIT');
                    }, num * 1000);
                }
                sc_timer.unref();
                break;
            case "ss":
                num = +chunkedInput[1];
                if (chunkedInput.length === 1) {

                    clearTimeout(ss_timer);
                    statistics.statsEnabled = false;
                    statistics.finishDate = new Date().toLocaleString();
                    console.log("statistics stopped");

                    break;
                }
                if (!isNaN(num)) {
                    statistics.reset();
                    statistics.statsEnabled = true;
                    statistics.startDate = new Date().toLocaleString();
                    console.log(`statistics will be collected for ${num} seconds`);
                    ss_timer = setTimeout(() => {
                        statistics.finishDate = new Date().toLocaleString();
                        statistics.statsEnabled = false;
                        console.log("statistics stopped");
                    }, num * 1000);
                    ss_timer.unref();


                }


        }
    }
});




