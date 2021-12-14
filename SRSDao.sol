pragma solidity >=0.4.22 <0.9.0;
import './SilkToken.sol';
import './SwagSale.sol';
import './TokenSale.sol';

contract SRSDao{
    SilkToken public tokenContract;
    address public signatureWallet;
    mapping(address => uint256) public balanceOf;
    TokenSale public founders_collection;
    TokenSale public door_closed_collection;
    
    event TransferSilk(
        address _to,
        uint256 _amount
    );

    event TransferMatic(
        address _to,
        uint256 _amount
    );

    event WithdrawlAmount(
        address _to,
        uint256 _value
    );

    
    //channge this to TokenSale
    //need to add Silk balance to the dao address and the TokenSale address
    constructor(SilkToken _tokenContract){
        tokenContract = _tokenContract;
        signatureWallet = msg.sender;
        founders_collection = new TokenSale(
            1000,
            25,
            0xa608b4F7D4C95c54CFf0b54c8aFa41Dec838244c,
            0,
            0xa608b4F7D4C95c54CFf0b54c8aFa41Dec838244c,
            15,
            5,
            'https://etherscan.io/address/0xfc877c9c792f2a4a58ba1474694611ce9a24d994#events' ); //design url
        //create founders collection
    }
    function createSale(
        uint256 _total_supply,
        uint256 _cost,
        address _designer, 
        uint256 _designer_amount,
        address _manufacturer,
        uint256 _manufacturer_amount,
        uint256 _marketer_amount,
        string memory _design_url
        ) public {
            new SwagSale(_total_supply, _cost, _designer, _designer_amount, _manufacturer, _manufacturer_amount, _marketer_amount, _design_url);
    }

    function transferSilk(address _to, uint256 _value) public {
         require(msg.sender == signatureWallet);
         tokenContract.transfer(_to, _value);
         emit TransferSilk(_to, _value);
     }

     function transferMatic(address _to, uint256 _value) public {
         require(msg.sender == signatureWallet);
         address payable _toPayable = payable(_to);
         _toPayable.transfer(_value);
         emit TransferMatic(_to, _value);
     }

     function burnSilk(uint256 _value) public {
        uint256 percentage = tokenContract.burnSilk(_value, msg.sender);
        uint256 withdrawl_amount = percentage * balance();
        msg.sender.transfer(withdrawl_amount);
        emit Withdrawl(msg.sender, withdrawl_amount)
     }
}