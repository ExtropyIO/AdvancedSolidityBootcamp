// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.4;

import "./Ownable.sol";

error OnlyAdminOrOwner();
error UserNotWhitelisted();
error IncorrectWhitelistTier();
error OriginatorNotSender();
error IsZeroAddress();
error InsufficientBalance();
error RecipientNameTooLong();
error AmountIsZero();
error IdIsZero();
error TierGreaterThan255();
error AmountSmallerThan3();

contract GasContract is Ownable {
    uint8 constant MAX_ADMINS = 5;
    uint256 public totalSupply = 0; // cannot be updated
    mapping(address => uint256) public balances;
    mapping(address => Payment[]) public payments;
    mapping(address => uint256) public whitelist;
    mapping(address => bool) isAdmin;
    address[MAX_ADMINS] public administrators;

    struct Payment {
        uint8 paymentType;
        bool adminUpdated;
        bytes8 recipientName; // max 8 characters
        address recipient;
        uint256 paymentID;
        uint256 amount;
    }
    
    struct ImportantStruct {
        uint256 valueA; // max 3 digits
        uint256 bigValue;
        uint256 valueB; // max 3 digits
    }

    mapping(address => ImportantStruct) public whiteListStruct;

    event AddedToWhitelist(address userAddress, uint256 tier);

    modifier onlyAdminOrOwner() {
        if(msg.sender == owner()) {
            _;
            return;
        }
        if(isAdmin[msg.sender]) {
            _;
            return;
        }
        revert OnlyAdminOrOwner();
    }

    modifier checkIfWhiteListed(address sender) {
        if (msg.sender != sender) {
            revert OriginatorNotSender();
        }
        uint256 usersTier = whitelist[msg.sender];
        if (usersTier < 1) {
            revert UserNotWhitelisted();
        }
        if (usersTier > 3) {
            revert IncorrectWhitelistTier();
        }
        _;
    }

    event supplyChanged(address indexed, uint256 indexed);
    event Transfer(address recipient, uint256 amount);

    constructor(address[] memory _admins, uint256 _totalSupply) {
        totalSupply = _totalSupply;

        for (uint256 ii = 0; ii < MAX_ADMINS;) {
            if (_admins[ii] != address(0)) {
                address admin = _admins[ii];
                administrators[ii] = admin;
                isAdmin[admin] = true;
                if (admin == msg.sender) {
                    balances[msg.sender] = _totalSupply;
                    emit supplyChanged(admin, _totalSupply);
                } else {
                    balances[admin] = 0;
                    emit supplyChanged(admin, 0);
                }
            }
            unchecked{ ii++; }
        }
    }

    function balanceOf(address _user) public view returns (uint256 balance_) {
        uint256 balance = balances[_user];
        return balance;
    }

    function getTradingMode() public pure returns (bool mode_) {
        return true;
    }

    function getPayments(address _user)
        public
        view
        returns (Payment[] memory payments_)
    {
        if (_user == address(0)) {
            revert IsZeroAddress();
        }
        return payments[_user];
    }

    function convertBytesToBytes8(bytes memory inBytes) private pure returns (bytes8 outBytes8) {
        if (inBytes.length == 0) {
            return 0x0;
        }

        assembly {
            outBytes8 := mload(add(inBytes, 32))
        }
    }
    
    function transfer(
        address _recipient,
        uint256 _amount,
        string calldata _name
    ) public returns (bool status_) {
        uint256 senderBalance = balances[msg.sender];

        if (senderBalance < _amount) {
            revert InsufficientBalance();
        }
        // This could also be assert(bytes(_name).length < 9)
        if (bytes(_name).length > 8) {
            revert RecipientNameTooLong();
        }

        balances[msg.sender] = senderBalance - _amount;
        balances[_recipient] += _amount;
        emit Transfer(_recipient, _amount);

        Payment[] storage currentPayments = payments[msg.sender];
        uint256 paymentID;
        if (currentPayments.length > 0) {
            Payment storage lastPayment = currentPayments[currentPayments.length - 1];
            paymentID = lastPayment.paymentID + 1;

        } else {
            paymentID = 1;
        }

        Payment memory payment = Payment(
            1,
            false, 
            convertBytesToBytes8(bytes(_name)),
            _recipient,
            paymentID, 
            _amount
        );
        payments[msg.sender].push(payment);

        return true;
    }

    function updatePayment(
        address _user,
        uint256 _ID,
        uint256 _amount,
        uint8 _type
    ) public onlyAdminOrOwner {
        if (_ID < 1) {
            revert IdIsZero();
        }
        if (_amount < 1) {
            revert AmountIsZero();
        }
        if (_user == address(0)) {
            revert IsZeroAddress();
        }

        for (uint256 ii = 0; ii < payments[_user].length;) {
            if (payments[_user][ii].paymentID == _ID) {
                payments[_user][ii].adminUpdated = true;
                payments[_user][ii].paymentType = uint8(_type);
                payments[_user][ii].amount = _amount;
            }
            unchecked{ ii++; }
        }
    }

    function addToWhitelist(address _userAddrs, uint256 _tier)
        public
        onlyAdminOrOwner
    {
        // if (_tier > 255) {
        //     revert TierGreaterThan255();
        // }
        // whitelist[_userAddrs] = _tier;
        // if (_tier > 3) {
        //     whitelist[_userAddrs] = 3;
        // } else {
        //     whitelist[_userAddrs] = _tier;
        // }
        assembly {
            // assert(_tier < 255);
            if lt(_tier, 255) {
                // whitelist[_userAddrs] = _tier;
                mstore(0, _userAddrs)
                mstore(32, whitelist.slot)
                let whitelistMappingPos := keccak256(0, 64)
                sstore(whitelistMappingPos, _tier)
            }
        }
        emit AddedToWhitelist(_userAddrs, _tier);
    }

    function whiteTransfer(
        address _recipient,
        uint256 _amount,
        ImportantStruct memory _struct
    ) public checkIfWhiteListed(msg.sender) {
        uint256 senderBalance = balances[msg.sender];
        if (senderBalance < _amount) {
            revert InsufficientBalance();
        }
        if (_amount <= 3) {
            revert AmountSmallerThan3();
        }
        uint256 whitelistSenderAmount = whitelist[msg.sender];
        uint256 tempBalance = senderBalance;
        tempBalance -= _amount;
        tempBalance += whitelistSenderAmount;
        balances[msg.sender] = tempBalance;

        tempBalance = balances[_recipient];
        tempBalance += _amount;
        tempBalance -= whitelistSenderAmount;
        balances[_recipient] = tempBalance;

        whiteListStruct[msg.sender] = _struct;
    }
}
