//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;

import "./Token.sol";

contract DeFi1 {
    uint256 initialAmount = 0;
    address[] public investors;
    uint256 blockReward = 0;
    Token public token;

    constructor(uint256 _initialAmount, uint256 _blockReward) {
        initialAmount = initialAmount;
        token = new Token(_initialAmount);
        blockReward = _blockReward;
    }

    function addInvestor(address _investor) public {
        investors.push(_investor);
    }

    function claimTokens() public {
        bool found = false;
        uint256 payout = 0;

        for (uint256 ii = 0; ii < investors.length; ii++) {
            if (investors[ii] == msg.sender) {
                found = true;
            } else {
                found = false;
            }
        }
        if (found == true) {
            calculatePayout();
        }

        token.transfer(msg.sender, payout);
    }

    function calculatePayout() public returns (uint256) {
        uint256 payout = 0;
        uint256 blockReward = blockReward;
        blockReward = block.number % 1000;
        payout = initialAmount / investors.length;
        payout = payout * blockReward;
        blockReward--;
        return payout;
    }
}
