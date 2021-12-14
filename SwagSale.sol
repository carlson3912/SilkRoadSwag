pragma solidity >=0.4.22 <0.9.0;
contract SwagSale{
    uint256 public total_supply;
    uint256 public cost;
    address payable public designer; 
    uint256 public designer_amount;
    address payable public manufacturer;
    uint256 manufacturer_amount;
    address payable public daoAddress;
    uint256 public marketer_amount;
    string public design_url;

    constructor(
        uint256 _total_supply,
        uint256 _cost,
        address _designer, 
        uint256 _designer_amount,
        address _manufacturer,
        uint256 _manufacturer_amount,
        uint256 _marketer_amount,
        string memory _design_url
        )
    
    {
    daoAddress = payable(msg.sender);
    total_supply = _total_supply;
    cost = _cost;
    designer = payable(_designer);
    designer_amount =_designer_amount;
    manufacturer = payable(_manufacturer);
    manufacturer_amount = _manufacturer_amount;
    design_url = _design_url; 
    marketer_amount = _marketer_amount;
    }
//encrypted address information
    event Sale(
        uint256 item_id,
        string delivery_instructions
    );
//encrypted address information
    function buyItem(uint256 item_id, address payable marketer, string memory delivery_instructions ) public payable{
        require (msg.value == cost);
        require (total_supply > 0);
        total_supply -= 1;
        manufacturer.transfer(manufacturer_amount);
        designer.transfer(designer_amount);
        marketer.transfer(marketer_amount);
        uint256 profit = cost - manufacturer_amount - designer_amount - marketer_amount;
        daoAddress.transfer(profit);
        emit Sale(item_id, delivery_instructions);

    }
}

//I think that the easiest way would be that dao.sol has a function that constructs a swag sale.
//This swag sale will in turn have a sale function that can only be called if the smart contract has a certain number of SilkTokens.
