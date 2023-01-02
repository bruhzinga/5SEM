const URL = require("url");

const {WriteToJson} = require('./SqlService');
const {WriteError} = require('./SqlService');

exports.DeleteHandler = (url, res,faculty,pulpit) => {
    let pathParts = url.split('/');
    const parsedUrl = URL.parse(url);

    switch (true) {
        case pathParts[1] + '/' + pathParts[2] === 'api/faculties' && pathParts[3] !== undefined :
            faculty.findOneAndDelete({faculty: pathParts[3]}).then(r => {
                WriteToJson(r, res)
            }).catch(err => {
                WriteError(err, res)
            });
            break;
        case pathParts[1] + '/' + pathParts[2] === 'api/pulpits' && pathParts[3]!== undefined:
            pulpit.findOneAndDelete({pulpit: pathParts[3]}).then(r => {
                WriteToJson(r, res)
            }).catch(err => {
                WriteError(err, res)
            });
            break;
        default :
            res.writeHead(404, {'Content-Type': 'text/plain'});
            res.end('Not found');
    }
}
