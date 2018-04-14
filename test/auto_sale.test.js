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
            from: accounts[0],
            gas: '3000000'
        });
    await automobile_Sale.methods.createAsset(11,'Red', 'Diesel', 'Japan','25-05-1996').send({
            from: accounts[0],
            gas: '3000000'
    });
    await automobile_Sale.methods.createAsset(12,'Blue', 'Petrol', 'Japan','26-05-1996').send({
            from: accounts[0],
            gas: '3000000'
    });
    await automobile_Sale.methods.createAsset(21,'Pink', 'Diesel', 'Japan','25-05-1996').send({
            from: accounts[0],
            gas: '3000000'
    });
    await automobile_Sale.methods.createAsset(22,'White', 'Petrol', 'Japan','26-05-1996').send({
            from: accounts[0],
            gas: '3000000'
    });
 
});

describe('Testing Automobile Contract', () => {
    it('getting the accounts', () => { 
        assert.ok(accounts[0])
    });
    
    it('contract deployed at', () => {
        assert.ok(automobile_Sale.options.address);
    });
    
    it('new assets created', async () =>{

    })
    it('create and get all cars manufactured by manufacturer', async () => {        

        const cars = await automobile_Sale.methods.getListOfAssetsOwnedByManufacturer().call()
        console.log(cars);
        // assert.ok(cars);
    });

    it('get specific cars manufactured by manufacturer', async () => {
        
        await automobile_Sale.methods.getSpecificCar(11).call({
            from: accounts[0],
        }).then( console.log)
        assert.ok('got it');
    });
    it('get current owner of the cars', async () => {
        
        await automobile_Sale.methods.getCurrentOwnerOfAsset(11).call({
            from: accounts[0],
        }).then( console.log )
        
    });

    it('Transfer ownership of the car', async () => {

        await automobile_Sale.methods.transferToOwner(accounts[0],accounts[1].toString(),"Ibad",11,"Karachi").send({
            from: accounts[0],
            gas: "3000000",
            value: web3.utils.toWei('1','ether')
        }).then(console.log);
            
        // await automobile_Sale.methods.transferToOwner(accounts[1],accounts[2].toString(),"Shahzaib",11,"Karachi").send({
        //     from: accounts[1],
        //     gas: "3000000",
        //     value: web3.utils.toWei('1','ether')
        // }).then(console.log);


        await automobile_Sale.methods.getCurrentOwnerOfAsset(11).call({
                from: accounts[0]
            }).then( console.log)

        // await automobile_Sale.methods.getPreviousOwnerOfAsset(11).call({
        //         from: accounts[0],
        //     }).then( console.log)
    });
    
    it('get current owner of car', async () => {
        await automobile_Sale.methods.getCurrentOwnerOfAsset(11).call({
            from: accounts[0],
            gas: "3000000"
        }).then( console.log)
    });

    it('get manufacturer details of car', async () => {
        await automobile_Sale.methods.getManufacturerName().call({
            from: accounts[0],
            // gas: "3000000"
        }).then( console.log)
    });
    // it('get previous owner of the cars', async () => {
    //     await automobile_Sale.methods.getPreviousOwnerOfAsset(11).call({
    //         from: accounts[0],
    //         // gas: "3000000"
    //     }).then( console.log)
        
    // assert.ok('got it');
    // })

});