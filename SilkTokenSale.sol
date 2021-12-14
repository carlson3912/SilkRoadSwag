pragma solidity >=0.4.22 <0.9.0;
import './SilkToken.sol';

contract SilkTokenSale{
    address payable admin; //untested payable attribute. admin represents myself, Jack
    SilkToken public tokenContract;
    uint256 public tokenPrice;
    uint256 public tokensSold;
    address payable daoContract; //untested all
    uint256 public adminPercent;
    

    event Sell(
        address _buyer,
        uint256 _amount
    );

    constructor(SilkToken _tokenContract, uint256 _tokenPrice){//, address _daoContract, uint256 _adminPercent){ //change admin fracrtion
        // require(0 <= _adminPercent); //untested
        // require(_adminPercent <= 100); // untested
        // adminPercent= _adminPercent;

        admin= payable(msg.sender);
        tokenContract = _tokenContract;
        tokenPrice = _tokenPrice;
        //daoContract = payable(_daoContract);
        
    }
    function multiply(uint x, uint y) internal pure returns (uint z){
        require(y  == 0 || (z = x * y) / y ==x);
    }


    function buyTokens(uint256 _numberOfTokens) public payable{
        require(msg.value == multiply(_numberOfTokens, tokenPrice)); //checks paying right price
        require(tokenContract.balanceOf(address(this))  >= _numberOfTokens); //checks enough tokens for sale
        require (tokenContract.transfer(msg.sender, _numberOfTokens)); //checks that the transfer goes through
        tokensSold += _numberOfTokens;
        emit Sell(msg.sender, _numberOfTokens);
    }

    function endSale() public {
        require(msg.sender == daoContract); //end sale can only be called by the dao
        require(tokenContract.transfer(daoContract, tokenContract.balanceOf(address(this)))); //gives back unsold Silk to admin
        //create a contract representing the DAO, that holds its money. A portion of the money should be sent there.
        admin.transfer(multiply(address(this).balance/100,adminPercent)); //untested sends 10 percent of sale value to daoContract
        selfdestruct(daoContract); //untested
  }    
}