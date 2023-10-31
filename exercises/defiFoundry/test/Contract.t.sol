// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Vm.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/DeFi1.sol";
import "../src/Token.sol";

contract User {
    receive() external payable {}
}

contract ContractTest is Test {
    DeFi1 defi;
    Token token;
    User internal alice;
    User internal bob;
    User internal chloe;
    uint256 initialAmount = 1000;
    uint256 blockReward = 5;

    function setUp() public {
        defi = new DeFi1(initialAmount, blockReward);
        token = Token(defi.token.address);
        alice = new User();
        bob = new User();
        chloe = new User();
    }

    function testInitialBalance() public {
        
    }

    function testAddInvestor() public {
        defi.addInvestor(address(alice));
        assert(defi.investors(0) == address(alice));
    }

    function testClaim() public {
        defi.addInvestor(address(alice));
        defi.addInvestor(address(bob));
        vm.prank(address(alice));
        vm.roll(1);
        defi.claimTokens();
    }


    function testCorrectPayoutAmount() public {

    }

    function testAddingManyInvestors() public {

    }

    function testAddingManyInvestorsAndClaiming() public {

    }

}
