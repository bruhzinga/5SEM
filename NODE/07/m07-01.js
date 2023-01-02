let fs = require('fs');
let http = require('http');
let ur = require('url');
const URL = require("url");


class m07 {
    constructor(Directory) {
        this.Directory = Directory;
    }

    HTTP404(res, req) {
        res.writeHead(404, {'Content-Type': 'text/plain; charset=utf-08'});
        res.end(`error":"${req.method}: ${req.url}, HTTP status 404`);
    }

    HTTP405(res, req) {
        res.writeHead(405, {'Content-Type': 'text/plain; charset=utf-08'});
        res.end(`error":"${req.method}: ${req.url}, HTTP status 405`);
    }


    async checkFile(url) {

        let file = `./${this.Directory}/${url}`;
        //check async
        return await fs.promises.access(file, fs.constants.F_OK).then(() => {
            return true;
        }).catch(() => {
            return false;
        })


    }

    sendFile(req, res, mode = 0) {
        let url = req.url;
        let file;
        if (mode === 0) {
            file = fs.createReadStream(`./${this.Directory}/.${url}`);
        } else {
            file = fs.createReadStream(`./${this.Directory}/${URL.parse(req.url).pathname.split('/')[2]}`, {encoding: 'utf8'});
        }
        let ext = ur.parse(url).pathname.split('.').pop();

        console.log(ext);
        let mime = {
            'html': 'text/html',
            'css': 'text/css',
            'js': 'application/javascript',
            'png': 'image/png',
            'json': 'application/json',
            'docx': 'application/msword',
            'xml': 'application/xml',
            'mp4': 'video/mp4'
        };

        if (mime[ext]) {
            res.writeHead(200, {'Content-Type': mime[ext]});
            file.pipe(res);
        } else {
            this.HTTP404(res, req);
        }
    }


}

exports.m07 = (Directory) => new m07(Directory);