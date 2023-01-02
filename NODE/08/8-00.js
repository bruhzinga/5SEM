const http = require("http");
const fs = require("fs");
const URL = require("url");
const parseString = require('xml2js').parseString;
const xmlbuilder = require('xmlbuilder');
let formidable = require('formidable');
const {m07} = require("../07/m07-01");
const {json} = require("formidable/src/plugins");
const st = m07("static");
const server = http.createServer((req, res) => {
    let parsedURL = (URL.parse(req.url).pathname.split("/"));
    let query = URL.parse(req.url, true).query;
    switch (req.method) {
        case 'GET':
            switch (parsedURL[1]) {
                case 'connection':
                    if (query.set) {
                        if (isNaN(+query.set)) {
                            res.end("Error");
                            break;
                        } else {
                            server.keepAliveTimeout = +query.set;

                        }
                    }
                    res.end(server.keepAliveTimeout.toString());
                    break;
                case 'headers':
                    req.on('data', data => {

                    })
                    req.on('end', () => {
                        res.setHeader('Content-Type', 'application/json; charset=utf-8');
                        res.setHeader('Custom-Header', 'Custom-Value');
                        res.statusCode = 200;
                        res.end(JSON.stringify(req.headers) + "\n" + JSON.stringify(res.getHeaders()));

                    });
                    break;
                case 'parameter':
                    let url = URL.parse(req.url).pathname.split("/");
                    console.log(url);
                    if (query.x && query.y) {
                        if (isNaN(+query.x) || isNaN(+query.y)) {
                            res.end("Error");
                            break;
                        } else {
                            let result = '<h2>Math Operations</h2>';
                            result += `Sum: ${+query.x + +query.y}<br>`;
                            result += `Difference: ${+query.x - +query.y}<br>`;
                            result += `Multiplication: ${+query.x * +query.y}<br>`;
                            result += `Division: ${+query.x / +query.y}<br>`;
                            res.end(result);
                        }
                    } else if ((url[2]) && url[3]) {
                        if (isNaN(+url[2]) || isNaN(+url[3])) {

                            res.end(req.url.toString());
                            break;
                        } else {
                            let result = '<h2>Math Operations</h2>';
                            result += `Sum: ${+url[2] + +url[3]}<br>`;
                            result += `Difference: ${+url[2] - +url[3]}<br>`;
                            result += `Multiplication: ${+url[2] * +url[3]}<br>`;
                            result += `Division: ${+url[2] / +url[3]}<br>`;
                            res.end(result);

                        }


                    }


                    break;
                case "close":
                    res.end("Server closes in 10 seconds");
                    setTimeout(() => {
                        server.close();
                        process.exit(0);
                    }, 10000);
                    break;
                case "socket":
                    //16. При получении этого запроса, в окно браузера выведите ip- адрес, порт клиента и ip-адрес и порт сервера
                    res.end(`Client IP: ${req.socket.remoteAddress} Client port: ${req.socket.remotePort} Server IP: ${req.socket.localAddress} Server port: ${req.socket.localPort}`);
                    break;
                case "req-data":
                    req.on('data', (data) => {
                        console.log('PART');
                        res.write(data)
                    });
                    req.on('end', () => {
                        res.end()
                    });
                    break;
                case "resp-status":
                    //array with all valid status codes
                    let statusCodes = [101, 102, 103, 200, 201, 202, 203, 204, 205, 206, 207, 208, 226, 300, 301, 302, 303, 304, 305, 306, 307, 308, 400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 416, 417, 418, 421, 422, 423, 424, 425, 426, 428, 429, 431, 451, 500, 501, 502, 503, 504, 505, 506, 507, 508, 510, 511];
                    //При получении этого запроса, сформируйте ответ, имеющий статус, заданный значением с  и пояснение к статусу, заданное значением  m.
                    if (query.n && query.m && statusCodes.includes(+query.n)) {

                        res.writeHead(+query.n, query.m);
                        res.end();
                        break;
                    }
                    res.end("Error");
                    break;
                case "formparameter":
                    fs.createReadStream('./static/index.html').pipe(res);
                    break;
                case "files":
                    let filename = parsedURL[2];
                    if (filename) {
                        st.checkFile(filename)
                            .then((value) => {
                                value ? st.sendFile(req, res, 1) : st.HTTP404(res, req);
                            });
                        break;
                    }

                    const dir = './static';
                    let n;
                    //count how many files in the static folder
                    fs.readdir(dir, (err, files) => {
                        n = files.length;
                        res.setHeader("X-static-files-count", n);
                        res.end();
                    });

                    break;
                case "upload":
                    fs.createReadStream('./static/upload.html').pipe(res);
                    break;

                default: {
                    res.statusCode = 404;
                    res.end("404 Not found");
                }

            }
            break;
        case 'POST':
            switch (parsedURL[1]) {
                case "formparameter":
                    let body = '';
                    req.on('data', (data) => {
                            body += data;

                        }
                    );
                    req.on('end', () => {
                        res.writeHead(200, {'Content-Type': 'text/html; charset=utf-8'});
                        let result = '<h2>Form Parameters</h2>';
                        let params = body.split('&');
                        params.forEach((param) => {
                            let [key, value] = param.split('=');
                            result += `${key} = ${value}<br>`;
                        });
                        res.end(result);
                    });
                    break;
                case "JSON":
                    let json = '';
                    req.on('data', (data) => {
                            json += data;
                        }
                    );
                    req.on('end', () => {
                        res.writeHead(200, {'Content-Type': 'application/json; charset=utf-8'});
                        const parsedJSON = JSON.parse(json);
                        const result = {
                            __comment: parsedJSON.__comment,
                            x_plus_y: +parsedJSON.x + +parsedJSON.y,
                            Concatination_s_o: `${parsedJSON.s}: ${parsedJSON.o.surname}, ${parsedJSON.o.name}`,
                            Lenght_m: parsedJSON.m.length
                        }
                        res.end(JSON.stringify(result));

                    });
                    break;
                case 'XML': {
                    let xml = '';
                    res.writeHead(200, {'Content-Type': 'text/xml'});
                    req.on('data', (data) => {
                        xml += data;
                    });
                    req.on('end', () => {
                        let data = '';
                        parseString(xml, {trim: true}, (err, result) => {
                            if (err) {
                                console.log(err);
                            } else {
                                let xSum = 0;
                                result.request.x.forEach((p) => {
                                    xSum += parseInt(p.$.value);
                                });
                                let mSum = '';
                                result.request.m.forEach((p) => {
                                    mSum += p.$.value;
                                });
                                let xmlObj = xmlbuilder.create('response').att('id', result.request.$.id)
                                    .ele('sum').att('element', 'x').att('result', xSum).up()
                                    .ele('concat').att('element', 'm').att('result', mSum)
                                    .end({pretty: true});
                                let responseXml = xmlObj.toString();
                                res.end(responseXml);
                            }
                        });

                    });
                    break;
                }
                case "upload":
                    let form = new formidable.IncomingForm();
                    form.parse(req, function (err, fields, files) {
                        let oldpath = files.filetoupload.filepath;
                        let newpath = './static/' + files.filetoupload.originalFilename;
                        fs.copyFile(oldpath, newpath, function (err) {
                            if (err) throw err;
                            res.write('File uploaded and moved!');
                            res.end();
                        });


                    });

                    break;


                default:
                    res.statusCode = 404;
                    res.end("404 Not found");
            }


    }

}).listen(3000, () => console.log(`Start server at http://localhost:3000`));
server.on("connection", () => {
    console.log("Conn")
});