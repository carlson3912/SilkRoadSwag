const SilkToken = artifacts.require("./SilkToken.sol");  
const SRSDao = artifacts.require("./SRSDao.sol");

contract('SRSDao', function(accounts){
    var daoInstance;
    var tokenInstance;
    var daoAddress;
    var admin = accounts[0];
    var buyer = accounts[8];

//I think that the issue with this test is that there is no token instance that can transfer the silk
    it('initializes the contract with the correct values', function(){
        return SilkToken.deployed().then(function(instance){
            tokenInstance = instance; 
            return SRSDao.deployed()
        }).then(function(instance){
             daoInstance = instance;
             daoAddress = daoInstance.address
             return daoInstance.address
         }).then(function(address){
             assert.notEqual(address, 0x0, 'has contract address' );
             return tokenInstance.symbol()
         }).then(function(symbol){
            assert.equal(symbol, 'SILK', 'has SilkToken instance with right symbol' );
         });
     });
//basically to fix this I need to ensure that the smart contract has enough value
//how did I give SRSDao a silk Balance
     it('facilitates Silk transfer', function(){
        tokenInstance.transfer(daoInstance.address, 12, {from: admin})
        return daoInstance.transferSilk(buyer, 5, {from: admin})
        .then(function(receipt){
        assert.equal(receipt.logs.length, 1, 'triggers one event');
        assert.equal(receipt.logs[0].event, 'TransferSilk', "should be 'TransferSilk' event");
        assert.equal(receipt.logs[0].args._to, buyer, "logs the account that received the tokens");
        assert.equal(receipt.logs[0].args._amount, 5, "logs the numbers of tokens sent");
        return daoInstance.transferSilk(buyer, 5, {from: buyer})
    }).then(assert.fail).catch(function(error){
        assert(error.message.indexOf('revert') >= 0, 'only the signature wallet can transfer silk');
        return tokenInstance.balanceOf(buyer)
    }).then(function(balance){
        assert.equal(balance.toString(), '5', "account receives proper amount");
        return tokenInstance.balanceOf(daoInstance.address)
    }).then(function(balance){
        assert.equal(balance.toString(), '7', "dao loses proper amount");
    });
});
    it('facilitates Matic transfer', function(){
        ///get ether value into DAO smaart contract
        //can ganache send eth to accounts no on the list?
        buyer.transfer(10,{from: admin})
        return daoInstance.transferMatic(10).then(function(receipt){
        assert.equal(receipt.logs.length, 1, 'triggers one event');
        assert.equal(receipt.logs[0].event, 'TransferMatic', "should be 'TransferMatic' event");
        assert.equal(receipt.logs[0].args._to, buyer, "logs the account that received the tokens");
        assert.equal(receipt.logs[0].args._amount, 5, "logs the numbers of tokens sent");
    });
});
});
