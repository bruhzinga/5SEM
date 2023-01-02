function getJSON(url) {
    const option = {
        method: "GET",
        headers: {"Content-Type": "application/json"}
    };
    fetch(url, option)
        .then(data => data.text())
        .then(content => {
            document.querySelector('#data_json').textContent = content
        });
}

getJSON('my.json');

function getXML(url) {
    const option = {
        method: "GET",
        headers: {"Content-Type": "application/xml"}
    };
    fetch(url, option)
        .then(data => data.text())
        .then(content => {
            document.querySelector('#data_xml').textContent = content
        });
}

getXML('my.xml');