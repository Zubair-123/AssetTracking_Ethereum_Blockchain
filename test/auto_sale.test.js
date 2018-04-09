const assert = require('assert');

const ganache = require('ganache-cli');
const Web3 = require('web3');
const {interface, bytecode} = require('../compile');

const web3 = new Web3(ganache.provider());

let accounts;
let automobile_Sale;

beforeEach( async () => {
    
    accounts = await web3.eth.getAccounts();
        // then deploy the contract after getting the accounts
    automobile_Sale = await new web3.eth.Contract(JSON.parse(interface))
        .deploy({
            data: bytecode,
            arguments : ['Toyota','Japan']
        })
        .send({ 
            from: accounts[1], 
            gas: '3000000'
        });
});

describe('Testing Automobile Contract', () => {
    // it('getting the accounts', () => { 
    //     assert.ok(accounts[0])
    // });
    
    it('contract deployed at', () => {
        assert.ok(automobile_Sale.options.address);
    });
});