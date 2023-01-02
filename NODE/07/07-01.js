let http = require('http');
let fs = require('fs');
let ur = require('url');
const {m07} = require("./m07-01");
let st = m07('static');

function getHandler(req, res) {
    st.checkFile(req.url)
        .then((value) => {

            value ? st.sendFile(req, res) : st.HTTP404(res, req);
        });
}

const server = http.createServer((req, res) => {
    switch (req.method) {
        case 'GET':
            getHandler(req, res);
            break;

        default:
            st.HTTP405(res, req);
    }
}).listen(3000, () => console.log(`Start server at http://localhost:3000`));
