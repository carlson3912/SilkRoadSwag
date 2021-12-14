const SilkToken = artifacts.require("./SilkToken.sol");

contract("SilkToken", function(accounts){
    var tokenInstance;
    it('initializes the contract with the right values', function(){
        return SilkToken.deployed().then(function(instance){
            tokenInstance = instance;
            return tokenInstance.name();
    }).then(function(name){
        assert.equal(name, 'Silk Token', 'has the correct name');
        return tokenInstance.symbol();
    }).then(function(symbol){
        assert.equal(symbol, "SILK", 'has the right symbol')
        return tokenInstance.standard();
    }).then(function(standard){
        assert.equal(standard, "Silk Token v1.0", 'has the right standard');
    });
});

    it('allocates the initial supply upon deployment', function(){
        return SilkToken.deployed().then(function(instance){
            tokenInstance = instance;
            return tokenInstance.totalSupply();
        }).then(function(totalSupply){
            assert.equal(totalSupply.toString(), '10000', 'sets the total supply to 10,000');
            return tokenInstance.balanceOf(accounts[0]);
        }).then(function(adminBalance){
            assert.equal(adminBalance.toString(), '10000', 'sets the admin balance to 10,000');
        });
    });

    it('transfers token ownership', function(){
        return SilkToken.deployed().then(function(instance){
            tokenInstance = instance;
            return tokenInstance.transfer.call(accounts[1],99999999);
        }).then(assert.fail).catch(function(error){
            assert(error.message.indexOf('revert') >= 0, 'error message must contain revert');
            return tokenInstance.transfer.call(accounts[1], 250, {from: accounts[0]});
        }).then(function(success){
            assert.equal(success, true, 'transfer returns true')
            return tokenInstance.transfer(accounts[1], 250, {from: accounts[0]});
        }).then(function(receipt){
            assert.equal(receipt.logs.length,1,'triggers one event');
            assert.equal(receipt.logs[0].event, 'Transfer', "should be 'Transfer' event")
            assert.equal(receipt.logs[0].args._from, accounts[0], "logs the sender account")
            assert.equal(receipt.logs[0].args._to, accounts[1], "logs the receiver account")
            assert.equal(receipt.logs[0].args._value, 250, "logs the value account")

            return tokenInstance.balanceOf(accounts[1]);
        }).then(function(balance){
            assert.equal(balance.toString(),'250','adds amount to the receive account');
            return tokenInstance.balanceOf(accounts[0]);
        }).then(function(balance){
            assert.equal(balance.toString(),'9750','deducts amount from send account');
    });
})

    it('approves tokens for delegated transfer', function(){
        return SilkToken.deployed().then(function(instance){
            tokenInstance = instance;
            return tokenInstance.approve.call(accounts[1], 100);
        }).then(function(success){
            assert.equal(success, true, 'it returns true');
            return tokenInstance.approve(accounts[1], 100, {from: accounts[0]});
        }).then(function(receipt){
            assert.equal(receipt.logs.length,1,'triggers one event');
            assert.equal(receipt.logs[0].event, 'Approval', "should be 'Approval' event")
            assert.equal(receipt.logs[0].args._owner, accounts[0], "logs the sender account")
            assert.equal(receipt.logs[0].args._spender, accounts[1], "logs the receiver account")
            assert.equal(receipt.logs[0].args._value, 100, "logs the value of approval")
            return  tokenInstance.allowance(accounts[0], accounts[1]);  
        }).then(function(allowance){
            assert.equal(allowance.toString(), '100', 'stores the allowance for delegated transfer');
        });
    });

    it('handles delegated token transfers', function(){
        return SilkToken.deployed().then(function(instance){
            tokenInstance = instance;
            fromAccount = accounts[2]
            toAccount = accounts[3]
            spendingAccount = accounts[4]
            return tokenInstance.transfer(fromAccount, 50, {from: accounts[0]});
        }).then(function(receipt){
            return tokenInstance.approve(spendingAccount, 10, {from: fromAccount})
        }).then(function(receipt){
            return tokenInstance.transferFrom(fromAccount, toAccount, 999, {from: spendingAccount})
        }).then(assert.fail).catch(function(error){
            assert(error.message.indexOf('revert') >= 0, "cannot transfer amoount larger than sender's balance"); 
            return tokenInstance.transferFrom(fromAccount, toAccount, 20, {from:spendingAccount});
        }).then(assert.fail).catch(function(error){
            assert(error.message.indexOf('revert') >= 0, "cannot transfer amount larger than allowance");
            return tokenInstance.transferFrom.call(fromAccount, toAccount, 10, {from: spendingAccount});
        }).then(function(success){
            assert.equal(success, true);
            return tokenInstance.transferFrom(fromAccount, toAccount, 9, {from: spendingAccount});  
        }).then(function(receipt){
            assert.equal(receipt.logs.length,1,'triggers one event');
            assert.equal(receipt.logs[0].event, 'Transfer', "should be 'Transfer' event")
            assert.equal(receipt.logs[0].args._from, fromAccount, "logs the sender account")
            assert.equal(receipt.logs[0].args._to, toAccount, "logs the receiver account")
            assert.equal(receipt.logs[0].args._value, 9, "logs the value account")
            return tokenInstance.balanceOf(fromAccount);
        }).then(function(balance){
            assert.equal(balance.toString(), '41', 'deducts the amount from the sending account')
            return tokenInstance.balanceOf(toAccount);
        }).then(function(balance){
            assert.equal(balance.toString(), '9','adds the amount to the receiving account')
            return tokenInstance.allowance(fromAccount, spendingAccount);
        }).then(function(allowance){
            assert.equal(allowance, 1, 'deducts from the allowance')
        })
    });
})