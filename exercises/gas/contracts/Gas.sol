// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "./Ownable.sol";

error Unauthorized();

contract GasContract {
    uint256 public immutable totalSupply; // cannot be updated
    address[5] public administrators;
    mapping(address => uint256) public whitelist;
    mapping(address => uint256) public balanceOf;
    mapping(address => Payment[]) payments;
    uint256 paymentCounter;
    address immutable contractOwner;
    
    enum PaymentType {
        Unknown,
        BasicPayment,
        Refund,
        Dividend,
        GroupPayment
    }

    struct Payment {
        uint256 id;
        PaymentType paymentType;
        uint256 amount;
    }

    struct ImportantStruct {
        // cannot optimize with tight packing because of the test
        uint256 valueA; // max 3 digits
        uint256 bigValue;
        uint256 valueB; // max 3 digits
    }

    event Transfer(address indexed recipient, uint256 indexed amount);

    constructor(address[5] memory _admins, uint256 _totalSupply) {        
        contractOwner = msg.sender;
        totalSupply = _totalSupply;
        administrators = _admins;
        balanceOf[contractOwner] = _totalSupply;    
    }

    function transfer(
        address _recipient,
        uint256 _amount,
        string calldata
    ) 
        external
    {
        balanceOf[msg.sender] -= _amount;
        balanceOf[_recipient] += _amount;
        
        unchecked{
            payments[msg.sender].push(Payment({
                id: ++paymentCounter,
                paymentType: PaymentType.BasicPayment,
                amount: _amount
            }));
        }
        emit Transfer(_recipient, _amount);
    }

    function addToWhitelist(address _userAddrs, uint8 _tier)
        external
    {
        whitelist[_userAddrs] = _tier > 3 ? 3 : _tier;
    }

    function whiteTransfer(
        address _recipient,
        uint256 _amount,
        ImportantStruct calldata
    ) external {
        uint256 total = _amount - whitelist[msg.sender]; 
        balanceOf[msg.sender] -= total;
        balanceOf[_recipient] += total;
    }
    
    function updatePayment(
        address _user,
        uint256 _ID,
        uint256 _amount,
        PaymentType _type
    ) external {
        if (msg.sender != contractOwner) {
            revert Unauthorized();
        }
        uint256 index;
        unchecked{  index = _ID - 1; }
        
        Payment storage payment = payments[_user][index];
        payment.paymentType = _type;
        payment.amount = _amount;
    }

    function getPayments(address _user)
        external
        view
        returns (Payment[] memory payments_)
    {
        return payments[_user];
    }
    
    function getTradingMode() external pure returns (bool mode_) {
        return true;
    }
}
