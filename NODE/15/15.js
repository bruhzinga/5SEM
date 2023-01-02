const { MongoClient } = require('mongodb');
const {ServerApiVersion} = require('mongodb');
const http = require('http');
const URL = require('url');

const {GetHandler} = require('./handlers/get');
const {PostHandler} = require('./handlers/post');
const {PutHandler} = require('./handlers/put');
const {DeleteHandler} = require('./handlers/delete');


const uri = "mongodb+srv://root:example@cluster0.ggpsrcw.mongodb.net/?retryWrites=true&w=majority";
const client = new MongoClient(uri, { useNewUrlParser: true, useUnifiedTopology: true, serverApi: ServerApiVersion.v1 });



const dbName = 'BSTU';
const facultyCollectionName = 'faculty';
const pulpitCollectionName = 'pulpit';


client.connect().then(r => {
    console.log('Connected successfully to server')
}).catch(err => {
    console.log(err)
});
const db = client.db(dbName);
const faculty = db.collection(facultyCollectionName);
const pulpit = db.collection(pulpitCollectionName);

http.createServer((req, res) => {
    let url = decodeURI(req.url);
    let method = req.method;
    console.log(req.method + ' ' + url);
    switch (method)
    {
        case 'GET':
            GetHandler(url, res,faculty,pulpit);
            break;
        case 'POST':
            PostHandler(url, req, res,faculty,pulpit,client);
            break;
        case 'PUT':
            PutHandler(url,req, res,faculty,pulpit);
            break;
        case 'DELETE':
            DeleteHandler(url, res,faculty,pulpit);
            break;
        default:
            res.writeHead(404, {'Content-Type': 'text/plain'});
            res.end('Not found');
    }

}).listen(3000, () => {
    console.log('Server started on port 3000');
});

