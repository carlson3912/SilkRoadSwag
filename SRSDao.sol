pragma solidity >=0.4.22 <0.9.0;
import './SilkToken.sol';
import './SwagSale.sol';
import './TokenSale.sol';

contract SRSDao{
    SilkToken public tokenContract;
    address public signatureWallet = 0x09e51cBaFDC539A9949971f9934AF665D686200d;
    mapping(address => uint256) public balanceOf;
    TokenSale public founders_collection;
    TokenSale public door_closed_collection;
    bool public hasComp;
    uint256 public timeForComp;
    SwagSale public winningSubmission;
    uint256 public winningSubmissionBalance;

    event TransferSilk(
        address _to,
        uint256 _amount
    );

    event TransferMatic(
        address _to,
        uint256 _amount
    );

    event Withdrawl(
        address _to,
        uint256 _value
    );

    event CompeitionIsOver(
        address winningSubmission
    );

    
    //channge this to TokenSale
    //need to add Silk balance to the dao address and the TokenSale address
    constructor(SilkToken _tokenContract){
        tokenContract = _tokenContract;
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
            new SwagSale(tokenContract,this,_total_supply, _cost, _designer, _designer_amount, _manufacturer, _manufacturer_amount, _marketer_amount, _design_url);
    }

     function transferMatic(address _to, uint256 _value) public {
         require(msg.sender == signatureWallet);
         address payable _toPayable = payable(_to);
         _toPayable.transfer(_value);
         emit TransferMatic(_to, _value);
     }

     function burnSilk(uint256 _value) public {
        uint256 percentage = tokenContract.burnSilk(_value, msg.sender);
        uint256 withdrawl_amount = percentage * address(this).balance;
        payable(msg.sender).transfer(withdrawl_amount);
        emit Withdrawl(msg.sender, withdrawl_amount);
     }

     function createCompetition(SwagSale _swagSale) public{
         require(hasComp == false);
         hasComp = true;
         timeForComp = block.timestamp + 7 days;
         winningSubmission = _swagSale;
         winningSubmissionBalance = 0;

     }

     function endCompetition() public{
         require(hasComp == true);
         require(block.timestamp >= timeForComp);
         hasComp = false;
         winningSubmission.putUpForSale();
         emit CompeitionIsOver(address(winningSubmission));
     }

     function castVote(SwagSale _swagSale, uint256 _value) public{
         tokenContract.castVote(_value, _swagSale, msg.sender);
         uint256 saleBalance = tokenContract.balanceOf(address(_swagSale));
         if (saleBalance > winningSubmissionBalance){
             winningSubmission = _swagSale;
             winningSubmissionBalance = saleBalance;
         }
         _swagSale.updateBalanceOf(msg.sender, _value);
     }
}
//they have to be able to withdraw so you need to keep track of the amount that each person donated