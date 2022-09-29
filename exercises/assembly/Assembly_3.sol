// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract SubOverflow {
    // Modify this function so that on overflow it returns the value 0
    // otherwise it should return x - y
    function subtract(uint256 x, uint256 y) public pure returns (uint256) {
        // Write assembly code that handles overflows
        assembly {
            if lt(x, y) { 
                mstore(0x80, 0) 
                return(0x80, 32)
            }

            mstore(0x80, sub(x, y))
            return(0x80, 32)
        }
    }
}