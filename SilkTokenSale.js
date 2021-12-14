const SilkToken = artifacts.require("./SilkToken.sol");  
const SilkTokenSale = artifacts.require("./SilkTokenSale.sol");

contract('SilkTokenSale', function(accounts){
    var tokenInstance;
    var tokenSaleInstance;
    var admin = accounts[0];
    var buyer = accounts[1];
    var tokenPrice = 10000;
    var tokensAvailable = 9000;
    var numberOfTokens;

    it('initializes the contract with the correct values', function(){
        return SilkTokenSale.deployed().then(function(instance){
            tokenSaleInstance = instance;
            return tokenSaleInstance.address
        }).then(function(address){
            assert.notEqual(address, 0x0, 'has contract address' );
            return tokenSaleInstance.tokenContract();
        }).then(function(address){
            assert.notEqual(address,0x0, 'has token contract address' );
            return tokenSaleInstance.tokenPrice();
        }).then(function(price){
            assert.equal(price, tokenPrice, 'token price is correct');
          });
    });

    it('facilitates token buying', function(){
        return SilkToken.deployed().then(function(instance){
            tokenInstance = instance; 
            return SilkTokenSale.deployed();
        }).then(function(instance){
            tokenSaleInstance = instance;
            return tokenInstance.transfer(tokenSaleInstance.address, tokensAvailable, {from: admin});
        }).then(function(receipt){   
            numberOfTokens = 10;
            return tokenSaleInstance.buyTokens(numberOfTokens, {from: buyer, value: numberOfTokens * tokenPrice }) 
        }).then(function(receipt){
            assert.equal(receipt.logs.length, 1, 'triggers one event');
            assert.equal(receipt.logs[0].event, 'Sell', "should be 'Sell' event");
            assert.equal(receipt.logs[0].args._buyer, buyer, "logs the account that purchased the tokens");
            assert.equal(receipt.logs[0].args._amount, numberOfTokens, "logs the numbers of tokens purchased");
            return tokenSaleInstance.tokensSold();
        }).then(function(amount){
            assert.equal(amount.toString(), numberOfTokens.toString(), 'increments the number of tokens sold');
            return tokenInstance.balanceOf(buyer);
        }).then(function(balance){  
            assert.equal(balance.toString(),numberOfTokens.toString());
            return tokenInstance.balanceOf(tokenSaleInstance.address);
        }).then(function(balance){
            assert.equal(balance.toString(),(tokensAvailable-numberOfTokens).toString());
            //Blocks orders different from the ether value (overpay and underpay)
            return tokenSaleInstance.buyTokens(numberOfTokens, {from: buyer, value: 1});
        }).then(assert.fail).catch(function(error){
            assert(error.message.indexOf('revert') >= 0, 'msg.value must equal number of tokens in wei');
            return tokenSaleInstance.buyTokens(90000, {from: buyer, value: numberOfTokens * tokenPrice});
        }).then(assert.fail).catch(function(error){
            assert(error.message.indexOf('revert') >= 0, 'cannot purchase more tokens than available');
        });
    });

    it('ends token sale', function(){
        return SilkToken.deployed().then(function(instance){
            tokenInstance = instance; 
            return SilkTokenSale.deployed();
        }).then(function(instance){
            tokenSaleInstance = instance;
            //Can't end sale if not admin
            return tokenSaleInstance.endSale({from: admin});
        }).then(function(receipt){
            return tokenInstance.balanceOf(admin);
        }).then(function(balance){
            assert.equal(balance.toString(),'9990', "admin is given remaining funds in sale");
        });
        });
    });
