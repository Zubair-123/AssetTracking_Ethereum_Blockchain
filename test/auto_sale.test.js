const assert = require('assert');

const ganache = require('ganache-cli');
const Web3 = require('web3');
const {interface, bytcode} = require('../compile');

const web3 = new Web3(ganache.provider());

let accounts;

before