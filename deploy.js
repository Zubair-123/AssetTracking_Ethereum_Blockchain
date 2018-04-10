//for wallet interface
const HDWalletProvider = require('truffle-hdwallet-provider');

const Web3 = require('web3');

// get bytecode and interface
const {interface, bytecode} = require('./compile');


// work with the API by Infura to Rinkeby network, and the Mnemonic
const provider = new HDWalletProvider(
    "answer jelly release mask glance horn emotion ticket pride page build cruel",
    'https://rinkeby.infura.io/jHZbiuFORTISdLGOrQhk'
);

const web3 = new Web3(provider);

let accounts
const deploy = async () => {
    accounts = await web3.eth.getAccounts();
    
    console.log('Attempting to deploy from accout:', accounts[0])

    const result = await new web3.eth.Contract(JSON.parse(interface))
    .deploy({ data: bytecode, arguments: ['Toyota Motors', 'Japan']})
    .send({gas:'3000000', from: accounts[0]})

    console.log(interface);
    console.log('Contract deployed to', result.options.address)
};
deploy()