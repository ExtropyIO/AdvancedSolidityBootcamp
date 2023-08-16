// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/BitMasking.sol";

contract BitMaskingTest is Test {
    BitMasking public contract_;

    function setUp() public {
        contract_ = new BitMasking();
    }

    function testReadBeef() public {
        bytes32 val = contract_.readBeef();
        assertEq(uint(val), uint(0xbeef));
    }

    function testFoodCodee() public {
        contract_.foodCode();
        bytes32 slot0 = contract_.getSlot();
        assertEq(
            slot0,
            0x0000ca11ab1ebeef00000000feedbee5c0ffee0000d15ea5f00dc0debeef0000
        );
    }

    function testSetFacebooc() public {
        contract_.facebooc();
        bytes32 slot0 = contract_.getSlot();
        assertEq(
            slot0,
            0xce00ca11ab1ebeeffaceb00cfeedbee5000000000000000000000000beef0000
        );
    }

    function testBeefBeeFeedBeef() public {
        contract_.beefBeeFeedBeef();
        bytes32 slot0 = contract_.getSlot();
        assertEq(
            slot0,
            0x000000000000beef000000000000bee0000feed00000000000000000beef0000
        );
    }
}
