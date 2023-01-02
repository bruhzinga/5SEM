const http = require("http");
const fs = require("fs");

const index = fs.readFileSync("./index.html");
const pic = fs.readFileSync("./pic.png");
const xmlhttprequest = fs.readFileSync("./xmlhttprequest.html");
const fetch = fs.readFileSync("./fetch.html");
const jquery = fs.readFileSync("./jquery.html");

const server = http.createServer((req, res) => {
res.writeHead(200);
switch (req.url) {
    case "/html":
        res.end(index);
        break;
    case "/png":
        res.end(pic);
        break;
    case "/api/name":
        res.writeHead(200, {'Content-Type': 'text/plain'});
        res.end("ZVARYKIN DZMITRY ALEXANDROVICH");
        break;
    case "/xmlhttprequest":
        res.end(xmlhttprequest);
        break;
    case "/fetch":
       res.end(fetch);
       break;
    case "/jquery":
        res.end(jquery);
        break;
    default:
        res.writeHead(404);
        res.end();



}
}).listen(3000);

console.log("Server has been started on port 3000...");