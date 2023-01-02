const URL = require("url");

const {WriteToJson} = require('./SqlService');
const {WriteError} = require('./SqlService');

exports.PutHandler = (url, req, res,faculty,pulpit) => {


    let pathParts = url.split('/');
    const parsedUrl = URL.parse(url);
    let body = '';
    switch (true) {
        case url === '/api/faculties' || url === '/api/faculties/':

            req.on('data', chunk => {
                body += chunk.toString();
            });
            req.on('end', () => {
                let facultyToInsert = JSON.parse(body);

                faculty.findOneAndUpdate({faculty: facultyToInsert.faculty}, {$set: facultyToInsert}).then(r => {
                    WriteToJson(r.value, res)

                }).catch(err => {
                    WriteError(err, res);
                });
            });
            break;
        case url === '/api/pulpits' || url === '/api/pulpits/':
            req.on('data', chunk => {
                body += chunk.toString();
            });
            req.on('end', () => {
                let pulpitToInsert = JSON.parse(body);
                pulpit.findOneAndUpdate({
                    pulpit: pulpitToInsert.pulpit,
                }, {$set: pulpitToInsert},).then(r => {
                    WriteToJson(r.value, res)

                }).catch(err => {
                    WriteError(err, res);
                });
            });
            break;

        default:
            res.writeHead(404, {'Content-Type': 'text/plain'});
            res.end('Not found');

    }
}