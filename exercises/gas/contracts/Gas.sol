// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "./Ownable.sol";

error Unauthorized();

contract GasContract {
    uint256 public immutable totalSupply; // cannot be updated
    address[5] public administrators;

    address private contractOwner;

    mapping(address => uint256) public whitelist;
    mapping(address => Payment[]) private payments;
    uint256 private paymentCounter;

    mapping(address => uint256) private balances;
    
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
        balances[contractOwner] = _totalSupply;    
    }

    function transfer(
        address _recipient,
        uint256 _amount,
        string calldata
    ) 
        external
    {
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;

        payments[msg.sender].push(Payment({
            id: ++paymentCounter,
            paymentType: PaymentType.BasicPayment,
            amount: _amount
        }));
        
        emit Transfer(_recipient, _amount);
    }

    function balanceOf(address _user) external view returns (uint256 balance_) {
        return balances[_user];
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
        balances[msg.sender] -= total;
        balances[_recipient] += total;
    }
    
    function updatePayment(
        address _user,
        uint256 _ID,
        uint256 _amount,
        PaymentType _type
    ) external {
        if (msg.sender != contractOwner || !isAdmin(msg.sender)) {
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

    function isAdmin(address _user) private view returns (bool admin_) {
        address[5] memory administratorsTemp = administrators;
        for (uint256 i = 0; i < 5;) {
            if (administratorsTemp[i] == _user) {
                return true;
            }
            unchecked{ i++; }
        }
        return false;
    }    
}
