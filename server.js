const express = require('express');
const app = express();
const path = require('path');
const port = 4200; 

var public = path.join(__dirname, '/dist/css-themes-example');

app.get('/', function(req, res) {
    res.sendFile(path.join(public, 'index.html'));
});

app.use('/', express.static(public));

app.listen(port, () => console.log(`Example app listening on port ${port}!`));