//Token Contract
pragma solidity >=0.4.22 <0.9.0;
import './SwagSale.sol';

contract SilkToken{
    uint256 public totalSupply;
    string public name = "Silk Token";
    string public symbol = "SILK";
    string public standard = "Silk Token v1.0";
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    uint8 decimals = 18;
    address public daoAddress = 0xa608b4F7D4C95c54CFf0b54c8aFa41Dec838244c;
    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    event Burn(
        address _sender,
        uint256 _amount
    );


    function setDaoAddress(address _daoAddress) public{
        require (daoAddress == 0xa608b4F7D4C95c54CFf0b54c8aFa41Dec838244c);
        daoAddress = _daoAddress;
    }

    function transfer(address _to, uint256 _value) public returns (bool success){
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value); 
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success){
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    //figure out specifically how to code exchanges of Matic.

    function burnSilk(uint256 _value, address _sender) public returns(uint256 percentage){
        require(balanceOf[_sender] >= _value);
        percentage = totalSupply / _value;
        totalSupply -= _value;
        balanceOf[_sender] -= _value;
        emit Burn(msg.sender, _value);
        return percentage;
    }

    function castVote(uint256 value, SwagSale swagSale, address _from) public{
        require(msg.sender == daoAddress);
        require(balanceOf[_from] >= value);
        balanceOf[_from] -= value;
        balanceOf[address(swagSale)] += value;
    }
    //initial supply goes to the message sender, but I will promptly transfer 90% of silk to the DAO
    constructor(uint256 _totalSupply) {
        balanceOf[msg.sender] = _totalSupply;
        totalSupply = _totalSupply;
    }



    

   
}