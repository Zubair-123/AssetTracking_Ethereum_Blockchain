//for path of the file
const path = require('path');
// for reading the solidity file
const fs = require('fs');

const solc = require('solc')
 //put the directory name and give the file name
const inboxPath = path.resolve(__dirname, 'contracts','Inbox.sol');

const source = fs.readFileSync(inboxPath, 'utf8'); // read solidity as UTF-8

module.exports = solc.compile(source, 1).contracts[':Inbox'];
