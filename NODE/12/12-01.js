const http = require('http');
const fs = require('fs');
const path = require('path');
const rpcWS = require('rpc-websockets').Server;
const config = {port: 4000, host: 'localhost', path: '/'};
const chokidar = require('chokidar');
const {StudentError} = require('./StudentError');
//------------------------RPC------------------------
const serverRPC = new rpcWS(config);
serverRPC.event('change');
//---------------------------------------------------

let  watcher = chokidar.watch('./Backup', {ignored: /^\./, persistent: true});
let content = fs.readFileSync("./StudentList.json", "utf8");
let students = JSON.parse(content);

//------------------------HTTP------------------------
const server = http.createServer( (req, res) => {

    server.errorHandler = function (err) {
            if (err instanceof StudentError) {
                res.writeHead(404, {'Content-Type': 'text/json'});
                res.end(JSON.stringify({  id:err.error,  message: err.message}));
            }
            else {
                res.writeHead(500, {'Content-Type': 'text/json'});
                res.end("Unknown error");
            }

    };
try {
    let path = new URL(req.url, 'http://localhost:3000').pathname;
    let firstPath = path.split('/')[1];
    console.log(firstPath);
    if (!isNaN(+firstPath) && firstPath !== '' && (req.method === "GET" || req.method === "DELETE")) {
        {
            let num = +firstPath;
            let students = JSON.parse(content);
            let student;
            switch (req.method) {
                case 'GET':
                    student = students.find(item => item.id === num);
                    if (student) {
                        res.writeHead(200, {'Content-Type': 'text/json'});
                        res.end(JSON.stringify(student));
                    } else {
                        throw new StudentError(`Student with id ${num} not found`, 1);
                    }
                    break;
                case 'DELETE':
                    res.writeHead(200, {'Content-Type': 'text/json'});
                    student = students.find(item => item.id === num);
                    if (student) {
                        students = students.filter(item => item.id !== num);
                        content = JSON.stringify(students);
                        fs.promises.writeFile("./StudentList.json", content, "utf8").catch(err => {
                            throw new StudentError(err.message, 3);
                        });
                        res.end(JSON.stringify(student));
                    } else {
                        throw new StudentError(`Student with id ${num} not found`, 1);
                    }
                    break;
            }
        }
    } else if (firstPath === '' && (req.method === 'GET' || req.method === "POST" || req.method === "PUT")) {
        switch (req.method) {
            case 'GET':
                res.writeHead(200, {'Content-Type': 'text/json'});
                res.end(content);
                break;
            case 'POST':
                res.writeHead(200, {'Content-Type': 'text/json'});
                let body = '';
                req.on('data', chunk => {
                    body += chunk;
                });
                req.on('end', () => {
                    let student = JSON.parse(body);
                    let studentId = students.find(item => item.id === student.id);
                    if (studentId) {
                        throw new StudentError("Already Exists", 2);
                    } else {
                        students.push(student);
                        content = JSON.stringify(students);
                        /* fs.writeFileSync("./StudentList.json", content, "utf8");*/
                        fs.promises.writeFile("./StudentList.json", content, "utf8").catch(err => {
                            throw new StudentError(err.message, 3);
                        });
                        res.end(JSON.stringify(student));
                    }
                });
                break;
            case 'PUT':
                res.writeHead(200, {'Content-Type': 'text/json'});
                let body1 = '';
                req.on('data', chunk => {
                    body1 += chunk;
                });
                req.on('end', () => {
                    let student = JSON.parse(body1);
                    let studentId = students.find(item => item.id === student.id);
                    if (studentId) {
                        students = students.map(item => {
                            if (item.id === student.id) {
                                return student;
                            } else {
                                return item;
                            }
                        });
                        content = JSON.stringify(students);
                        fs.promises.writeFile("./StudentList.json", content, "utf8").catch(err => {
                            throw new StudentError(err.message, 3);
                        });
                        res.end(JSON.stringify(student));
                    } else {
                        throw new StudentError(`Student with id ${student.id} not found`, 1)
                    }
                });
                break;
        }
    } else if (firstPath === 'backup' && req.method === "DELETE") {
        let secondPart = path.split('/')[2] ? path.split('/')[2] : null;
        let reg = new RegExp('^[0-9]{4}-[0-9]{2}-[0-9]{2}$');
        if (secondPart && reg.test(secondPart)) {
            if (req.method === 'DELETE') {
                let date = secondPart.split('-');
                let files = fs.readdirSync('./backup');
                let filesToDelete = files.map(item => item.split('_')[0]);
                filesToDelete.forEach(item => {
                    let [year, month, day, hours, minute, second] = item.split('-');
                    let date1 = new Date(+year, month - 1, +day, +hours, +minute, +second);
                    let date2 = new Date(+date[0], date[2] - 1, +date[1]);
                    if (date1.getTime() < date2.getTime()) {
                        // fs.unlinkSync(`./Backup/${item}_StudentList.json`);
                        fs.unlink(`./Backup/${item}_StudentList.json`, (err) => {
                            if (err) {
                                throw new StudentError("Error while deleting file", 4);
                            }
                        });
                    }
                })
                res.writeHead(200, {'Content-Type': 'text/json'});
                res.end(JSON.stringify({message: "Backup files deleted"}));
            }
        } else {
            throw new StudentError("Invalid date", 5);
        }

    } else if (firstPath === 'backup' && (req.method === "GET" || req.method === "POST")) {
        switch (req.method) {
            case 'GET':
                let files = fs.readdirSync('./backup');
                res.writeHead(200, {'Content-Type': 'text/json'});
                res.end(JSON.stringify(files));
                break;

            case 'POST':
                setTimeout(() => {
                    //the date format us YYYYMMDDHHSS
                    let time = new Date();
                    let year = time.getFullYear();
                    let month = time.getMonth() + 1;
                    let day = time.getDate();
                    let hours = time.getHours();
                    let minutes = time.getMinutes();
                    let seconds = time.getSeconds();
                    let date = `${year}-${month}-${day}-${hours}-${minutes}-${seconds}`;
                    fs.copyFile("./StudentList.json", `./backup/${date}_StudentList.json`, (err) => {
                        if (err) {
                            console.log(err);
                        }
                    });
                }, 2000);

                res.end("Backup is in progress");
                break;
        }
    } else {
        res.writeHead(404, {'Content-Type': 'text/html'});
        res.end('<h1>404 Not Found</h1>');
    }
}
catch (e)
{
    server.errorHandler(e);
}
    process.setMaxListeners(0);
}).listen(3000, () => {
    console.log('Server is running on port 3000');
});
process.on('uncaughtException', (err) => {
   server.errorHandler(err);
});



watcher.on('change', () => {
    serverRPC.emit('change');
});





