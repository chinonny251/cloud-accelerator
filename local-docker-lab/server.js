const http = require('http');
const os = require('os');

const server = http.createServer((req, res) => {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({
        status: "SUCCESS",
        message: "Hello Chinonny! Your custom container application is fully functional.",
        hostname: os.hostname(),
        platform: os.platform(),
        timestamp: new Date().toISOString()
    }, null, 2));
});

const PORT = 80;
server.listen(PORT, () => {
    console.log(`Application server running securely on internal port ${PORT}`);
});
