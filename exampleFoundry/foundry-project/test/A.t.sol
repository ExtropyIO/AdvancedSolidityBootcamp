// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// Standard test libs
import "forge-std/Test.sol";
import "forge-std/Vm.sol";

// Contract under test
import {A} from "../src/A.sol";

contract ATest is Test {
    // Variable for contract instance
    A private a;

    function setUp() public {
        // Instantiate new contract instance
        a = new A();
    }

    function test_Log() public {
        // Various log examples
        emit log("here");
        emit log_address(address(this));
        // HEVM_ADDRESS is a special reserved address for the VM
        emit log_address(HEVM_ADDRESS);
    }

    function test_GetValue() public {
        assertTrue(a.retrieve() == 0);
    }

    function test_SetValue() public {
        uint256 x = 123;
        a.store(x);
        assertTrue(a.retrieve() == 123);
    }

    // Define the value(s) being fuzzed as an input argument
    function test_FuzzValue(uint256 _value) public {
        // Define the boundaries for the fuzzing, in this case 0 and 99999
        _value = bound(_value, 0, 99999);
        // Call contract function with value
        a.store(_value);
        // Perform validation
        assertTrue(a.retrieve() == _value);
    }
}
