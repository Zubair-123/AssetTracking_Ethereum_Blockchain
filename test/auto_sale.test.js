const assert = require('assert');

const ganache = require('ganache-cli');
const Web3 = require('web3');
const {interface, bytcode} = require('../compile');

const web3 = new Web3(ganache.provider());

let accounts;

beforeEach( async () => {
    
    accounts = await web3.eth.getAccounts();
    
});

describe('Testing Automobile Contract', () => {
    it('getting the accounts', () => { 
        console.log(accounts)
    });
    
    it('contract deployed at', () => {
        assert.ok(Automobile_Sale.options.address);
    });
});