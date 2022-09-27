pragma solidity ^0.8.4;

contract Scope {
    uint256 public count = 10;

    function increment(uint256 num) public {
        // Modify state of the count from within
        // the assembly segment
        assembly {

        }
    }
}
