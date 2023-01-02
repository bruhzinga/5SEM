exports.WriteToJson = (r, res) => {
    res.writeHead(200, {'Content-Type': 'application/json'});
    res.end(JSON.stringify(r));
}

exports.WriteError = (err, res) => {
    res.writeHead(500, {'Content-Type': 'application/json'});
    res.end(JSON.stringify(err));
}