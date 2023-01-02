const URL = require("url");

const {WriteToJson} = require('./SqlService');
const {WriteError} = require('./SqlService');



exports.GetHandler =  (url, res,faculty,pulpit) =>
{
   let pathParts = url.split('/');
   const parsedUrl = URL.parse(url);


   switch (true) {
      case url === '/api/faculties' || url === '/api/faculties/':
         faculty.find().toArray().then(r => {
            WriteToJson(r, res)
         }).catch(err => {
            WriteError(err, res)
         });
         break;
      case (url === '/api/pulpits' || url === '/api/pulpits/'):
         pulpit.find().toArray().then(r => {
            WriteToJson(r, res)
         }).catch(err => {
            WriteError(err, res)
         });
         break;
      case pathParts[1] + '/' + pathParts[2] === 'api/faculties' && pathParts[3]!== undefined :
         faculty.find({faculty: pathParts[3]}).toArray().then(r => {
            WriteToJson(r, res)
         }).catch(err => {
            WriteError(err, res)
         });
         break;
      case pathParts[1] +'/' + pathParts[2] === 'api/pulpits' && pathParts[3]!== undefined:
         pulpit.find({pulpit: pathParts[3]}).toArray().then(r => {
            WriteToJson(r, res)
         }).catch(err => {
            WriteError(err, res)
         });
         break;
      case parsedUrl.pathname === "/api/pulpits" && parsedUrl.query !== null  :
         const query = parsedUrl.query.split('=');
         const pulpits = query[1].split(',');
            pulpit.find({pulpit: {$in: pulpits}}).toArray().then(r => {
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











