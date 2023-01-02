const http = require('http');
const mysql = require('mysql2');
const fs = require("fs");
const pool = mysql.createPool({
    host: 'localhost',
    user: 'root',
    database: 'LABA14',
    password: 'example',
    connectionLimit:"10",
});



const server = http.createServer((req, res) => {
    let method = req.method;
    try {
        switch (method) {
            case 'GET':
                getHandler(req, res);
                break;
            case 'POST':
                postHandler(req, res);
                break;
            case 'PUT':
                putHandler(req, res);
                break;
            case 'DELETE':
                deleteHandler(req, res);
                break;
            default:
                res.writeHead(404, {'Content-Type': 'text/plain'});
                res.end('404 Not Found');
        }
    }
    catch (e) {
        res.writeHead(500, {'Content-Type': 'text/plain'});
        res.end(e.message);
    }
}).listen(5000,() => {
    console.log('Server started on port 5000');
})

function GetSqlToJson(err, results ,fields, res) {
    if (err) {
        res.writeHead(500, {'Content-Type': 'application/json'});
        res.end(JSON.stringify(err));
    } else {
        res.writeHead(200, {'Content-Type': 'application/json'});
        res.end(JSON.stringify(results));
    }
}

function PostPutDeleteSqlToJson(err, results ,fields, res, json) {
    if (err) {
        res.writeHead(500, {'Content-Type': 'application/json'});
        res.end(JSON.stringify(err));
    } else {
        res.writeHead(200, {'Content-Type': 'application/json'});
        res.end(json);
    }
}

function getHandler(req, res) {
    let path = decodeURI(req.url);
    console.log(req.method+' '+path);

    if (path === "/")
    {
        res.end(fs.readFileSync('./index.html'));
        return;
    }

    if(RegExp('^/api/faculties/?$').test(path))
    {
        pool.query('SELECT * FROM FACULTY', (err, results, fields) => {
            GetSqlToJson(err, results, fields, res);
        });
    }
    else if(RegExp('^/api/pulpits/?$').test(path))
    {
        pool.query('SELECT * FROM PULPIT', (err, results, fields) => {
            GetSqlToJson(err, results, fields, res);
        });
    }

    else if (RegExp('^/api/subjects/?$').test(path))
    {
        pool.query('SELECT * FROM SUBJECT', (err, results, fields) => {
            GetSqlToJson(err, results, fields, res);
        });
    }
    else if (RegExp('^/api/auditoriumstypes/?$').test(path))
    {
        pool.query('SELECT * FROM AUDITORIUM_TYPE', (err, results, fields) => {
            GetSqlToJson(err, results, fields, res);
        });
    }
    else if (RegExp('^/api/auditoriums/?$').test(path))
    {
        pool.query('SELECT * FROM AUDITORIUM', (err, results, fields) => {
            GetSqlToJson(err, results, fields, res);
        });
    }
    //regex for /api/faculty/xyz/pulpits where xyz is string in russian
    else if(RegExp('^/api/faculty/[^/]*/pulpits/?$').test(path))
    {
        let faculty = path.split('/')[3];
        pool.execute('SELECT PULPIT FROM PULPIT WHERE FACULTY= ?', [faculty], (err, results, fields) => {
            GetSqlToJson(err, results, fields, res);
        });
    }

    else if(RegExp('^/api/auditoriumtypes/[^/]*/auditoriums/?$').test(path)) {
        let auditoriumtype = path.split('/')[3];
        pool.execute('SELECT AUDITORIUM FROM AUDITORIUM WHERE AUDITORIUM_TYPE= ?', [auditoriumtype], (err, results, fields) => {
            GetSqlToJson(err, results, fields, res);
        });
    }
    else
    {
        res.writeHead(404, {'Content-Type': 'text/plain'});
        res.end('404 Not Found');
    }

}

function postHandler(req, res) {
    let path = decodeURI(req.url);
    console.log(req.method+' '+path);
    //regex for api/pulpits
    if(RegExp('^/api/pulpits/?$').test(path))
    {
        let body = '';
        req.on('data', chunk => {
            body += chunk.toString();
        });
        req.on('end', () => {
            let data = JSON.parse(body);
            pool.execute('INSERT INTO PULPIT (PULPIT, FACULTY,PULPIT_NAME) VALUES (?, ?,?)', [data.PULPIT, data.FACULTY,data.PULPIT_NAME], (err, results, fields) => {
                PostPutDeleteSqlToJson(err, results, fields, res, body);
            });
        });
    }

    else if(RegExp('^/api/subjects/?$').test(path))
    {
        let body = '';
        req.on('data', chunk => {
            body += chunk.toString();
        });
        req.on('end', () => {
            let data = JSON.parse(body);
            pool.execute('INSERT INTO SUBJECT (SUBJECT, PULPIT,SUBJECT_NAME) VALUES (?, ?,?)', [data.SUBJECT, data.PULPIT,data.SUBJECT_NAME], (err, results, fields) => {
                PostPutDeleteSqlToJson(err, results, fields, res, body);
            });
        });
    }
    else if(RegExp('^/api/auditoriumstypes/?$').test(path))
    {
        let body = '';
        req.on('data', chunk => {
            body += chunk.toString();
        });
        req.on('end', () => {
            let data = JSON.parse(body);
            pool.execute('INSERT INTO AUDITORIUM_TYPE (AUDITORIUM_TYPE,AUDITORIUM_TYPENAME) VALUES (?,?)', [data.AUDITORIUM_TYPE,data.AUDITORIUM_TYPENAME], (err, results, fields) => {
                PostPutDeleteSqlToJson(err, results, fields, res, body);
            });
        });
    }
    else if(RegExp('^/api/auditoriums/?$').test(path))
    {
        let body = '';
        req.on('data', chunk => {
            body += chunk.toString();
        });
        req.on('end', () => {
            let data = JSON.parse(body);
            pool.execute('INSERT INTO AUDITORIUM (AUDITORIUM, AUDITORIUM_TYPE,AUDITORIUM_CAPACITY,AUDITORIUM_NAME) VALUES (?, ?,?,?)', [data.AUDITORIUM, data.AUDITORIUM_TYPE,data.AUDITORIUM_CAPACITY,data.AUDITORIUM_NAME], (err, results, fields) => {
                PostPutDeleteSqlToJson(err, results, fields, res, body);
            });
        });
    }
    else
    {
        res.writeHead(404, {'Content-Type': 'text/plain'});
        res.end('404 Not Found');
    }

}

function putHandler(req, res) {
    let path = decodeURI(req.url);
    console.log(req.method+' '+path);
    if(RegExp('^/api/pulpits/?$').test(path))
    {
        let body = '';
        req.on('data', chunk => {
            body += chunk.toString();
        });
        req.on('end', () => {
            let data = JSON.parse(body);
            pool.execute('UPDATE PULPIT SET PULPIT=?, FACULTY=?,PULPIT_NAME=? WHERE PULPIT=?', [data.PULPIT, data.FACULTY,data.PULPIT_NAME,data.PULPIT], (err, results, fields) => {
                PostPutDeleteSqlToJson(err, results, fields, res, body);

            });
        });
    }
    else if(RegExp('^/api/subjects/?$').test(path))
    {
        let body = '';
        req.on('data', chunk => {
            body += chunk.toString();
        });
        req.on('end', () => {
            let data = JSON.parse(body);
            pool.execute('UPDATE SUBJECT SET SUBJECT=?, PULPIT=?,SUBJECT_NAME=? WHERE SUBJECT=?', [data.SUBJECT, data.PULPIT,data.SUBJECT_NAME,data.SUBJECT], (err, results, fields) => {
                PostPutDeleteSqlToJson(err, results, fields, res, body);
            });
        });
    }
    else if(RegExp('^/api/auditoriumstypes/?$').test(path))
    {
        let body = '';
        req.on('data', chunk => {
            body += chunk.toString();
        });
        req.on('end', () => {
            let data = JSON.parse(body);
            pool.execute('UPDATE AUDITORIUM_TYPE SET AUDITORIUM_TYPE=?,AUDITORIUM_TYPENAME=? WHERE AUDITORIUM_TYPE=?', [data.AUDITORIUM_TYPE,data.AUDITORIUM_TYPENAME,data.AUDITORIUM_TYPE], (err, results, fields) => {
                PostPutDeleteSqlToJson(err, results, fields, res, body);
            });
        });
    }
    else if(RegExp('^/api/auditoriums/?$').test(path))
    {
        let body = '';
        req.on('data', chunk => {
            body += chunk.toString();
        });
        req.on('end', () => {
            let data = JSON.parse(body);
            pool.execute('UPDATE AUDITORIUM SET AUDITORIUM=?, AUDITORIUM_TYPE=?,AUDITORIUM_CAPACITY=?,AUDITORIUM_NAME=? WHERE AUDITORIUM=?', [data.AUDITORIUM, data.AUDITORIUM_TYPE,data.AUDITORIUM_CAPACITY,data.AUDITORIUM_NAME,data.AUDITORIUM], (err, results, fields) => {
                PostPutDeleteSqlToJson(err, results, fields, res, body);
            });
        });
    }
    else
    {
        res.writeHead(404, {'Content-Type': 'text/plain'});
        res.end('404 Not Found');
    }

}

function deleteHandler(req, res) {
    let path = decodeURI(req.url);
    console.log('DELETE ' + path);
    if (RegExp('^/api/faculties/[^/]*/?').test(path)) {
        let faculty = path.split('/')[3];
        pool.execute('Select * from PULPIT where FACULTY = ?', [faculty],(err, results, fields) => {
            let body = JSON.stringify(results);
            pool.execute('DELETE FROM FACULTY WHERE FACULTY=?', [faculty], (err, results, fields) => {
                PostPutDeleteSqlToJson(err, results, fields, res, body);
            });
        });


    }
    else if(RegExp('^/api/pulpits/[^/]*/?').test(path)){
        let pulpit = path.split('/')[3];
        pool.execute('Select * from PULPIT where PULPIT = ?', [pulpit],(err, results, fields) => {
            let body = JSON.stringify(results);
            pool.execute('DELETE FROM PULPIT WHERE PULPIT=?', [pulpit], (err, results, fields) => {
                PostPutDeleteSqlToJson(err, results, fields, res, body);
            });
        });
    }
    else if(RegExp('^/api/subjects/[^/]*').test(path)) {
        let subject = path.split('/')[3];
        pool.execute('Select * from SUBJECT where SUBJECT = ?', [subject], (err, results, fields) => {
            let body = JSON.stringify(results);
            pool.execute('DELETE FROM SUBJECT WHERE SUBJECT=?', [subject], (err, results, fields) => {
                PostPutDeleteSqlToJson(err, results, fields, res, body);
            });
        });

    }

    else if(RegExp('^/api/auditoriumstypes/[^/]*').test(path))
    {
        let auditoriumtype = path.split('/')[3];
        pool.execute('Select * from AUDITORIUM_TYPE where AUDITORIUM_TYPE = ?', [auditoriumtype],(err, results, fields) => {
            let body = JSON.stringify(results);
            pool.execute('DELETE FROM AUDITORIUM_TYPE WHERE AUDITORIUM_TYPE=?', [auditoriumtype], (err, results, fields) => {
                PostPutDeleteSqlToJson(err, results, fields, res, body);
            });
        });
    }
    else if(RegExp('^/api/auditoriums/[^/]*').test(path))
    {
        let auditorium = path.split('/')[3];
        pool.execute('Select * from AUDITORIUM where AUDITORIUM = ?', [auditorium],(err, results, fields) => {
            let body = JSON.stringify(results);
            pool.execute('DELETE FROM AUDITORIUM WHERE AUDITORIUM=?', [auditorium], (err, results, fields) => {
                PostPutDeleteSqlToJson(err, results, fields, res, body);
            });
        });
    }
}