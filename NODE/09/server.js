const http = require("http")
const url = require("url")
const parseString = require('xml2js').parseString;
const xmlbuilder = require('xmlbuilder');
const formidable = require('formidable');
const fs = require("fs");
const querystring = require('querystring');


function HTTP404(res) {
    res.statusCode = 404;
    res.end("Not found");
}

const server = http.createServer((req, res) => {
    switch (req.method) {
        case "GET":
            switch (url.parse(req.url).pathname) {
                case "/task1":
                    res.end("Task 1");
                    break;
                case "/task2":
                    res.end(url.parse(req.url, true).query.x + " " + url.parse(req.url, true).query.y);
                    break;
                case "/task8":
                    res.setHeader("Content-Type", "application/json");
                    res.end(JSON.stringify({name: "file.txt", data: "Hello world!"}));
                    break;

                default:
                    HTTP404(res);
            }
            break;
        case  "POST":
            switch (url.parse(req.url).pathname) {
                case "/task3":
                    let mydata = '';
                    req.on('data', (data) => {
                            mydata += data;
                        }
                    );
                    req.on('end', () => {
                        res.end(querystring.parse(mydata).x + " " + querystring.parse(mydata).y + " " + querystring.parse(mydata).s);

                    });

                    break;
                case "/task4":
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
                case "/task5":
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
                case "/task6":
                    let form = new formidable.IncomingForm();
                    form.parse(req, function (err, fields, files) {
                        console.log(files);
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
                    HTTP404(res);
            }
            break;
        default:
            HTTP404(res);
    }
}).listen(3000, () => {
    console.log("Server is running on port 3000");
});