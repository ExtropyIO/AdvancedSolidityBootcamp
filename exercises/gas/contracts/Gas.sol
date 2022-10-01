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
    
    History[] private paymentHistory; // when a payment was updated
    
    enum PaymentType {
        Unknown,
        BasicPayment,
        Refund,
        Dividend,
        GroupPayment
    }

    struct Payment {
        PaymentType paymentType;
        uint256 paymentID;
        uint256 amount;
        string recipientName; // max 8 characters   - cannot optimize because of the tests
        address recipient;
        address admin; // administrators address
        bool adminUpdated;
    }

    struct History {
        uint256 lastUpdate;
        uint256 blockNumber;
        address updatedBy;
    }
    struct ImportantStruct {
        // cannot optimize with tight packing because of the test
        uint256 valueA; // max 3 digits
        uint256 bigValue;
        uint256 valueB; // max 3 digits
    }

    event AddedToWhitelist(address indexed userAddress, uint256 indexed tier);
    event Transfer(address indexed recipient, uint256 indexed amount);
    event PaymentUpdated(
        address indexed admin,
        uint256 indexed ID,
        uint256 indexed amount,
        string recipient
    );
    event WhiteListTransfer(address indexed recipient);

    constructor(address[5] memory _admins, uint256 _totalSupply) {        
        contractOwner = msg.sender;
        totalSupply = _totalSupply;
        administrators = _admins;
        balances[contractOwner] = _totalSupply;    
    }

    function transfer(
        address _recipient,
        uint256 _amount,
        string calldata _name
    ) 
        external
    {
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;

        payments[msg.sender].push(Payment({
            paymentType: PaymentType.BasicPayment,
            paymentID: ++paymentCounter,
            amount: _amount,
            recipientName: _name,
            recipient: _recipient,
            admin: address(0),
            adminUpdated: false
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
        emit AddedToWhitelist(_userAddrs, _tier);
    }

    function whiteTransfer(
        address _recipient,
        uint256 _amount,
        ImportantStruct calldata _struct
    ) external {
        uint256 total = _amount - whitelist[msg.sender]; 
        balances[msg.sender] -= total;
        balances[_recipient] += total;

        emit WhiteListTransfer(_recipient);
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

        Payment[] storage userPayments = payments[_user];
        for (uint256 i = 0; i < userPayments.length;) {
            if (userPayments[i].paymentID == _ID) {
                userPayments[i].adminUpdated = true;
                userPayments[i].admin = _user;
                userPayments[i].paymentType = _type;
                userPayments[i].amount = _amount;

                addHistory(_user, getTradingMode());
                emit PaymentUpdated(
                    msg.sender,
                    _ID,
                    _amount,
                    userPayments[i].recipientName
                );
                break;
            }
            unchecked { i++; }
        }
    }

    function getPayments(address _user)
        external
        view
        returns (Payment[] memory payments_)
    {
        return payments[_user];
    }
    
    function getTradingMode() public pure returns (bool mode_) {
        return true;
    }
    
    function addHistory(address _updateAddress, bool _tradeMode)
        private
        returns (bool status_, bool tradeMode_)
    {
        paymentHistory.push(History(block.timestamp, block.number, _updateAddress));
        return (true, _tradeMode);
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
