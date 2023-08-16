// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BitMasking {
    uint16 public a;
    uint16 public b = 0xbeef;
    uint32 public c;
    uint64 public d;
    uint128 public e = 0x0000ca11ab1ebeef00000000feedbee5;

    function getSlot() external view returns (bytes32 ret) {
        assembly {
            ret := sload(0)
        }
    }

    // TODO:
    // 1. Read slot b and return its value 0xbeef
    function readBeef() external view returns (bytes32 ret) {
        assembly {
            // start here: Solution provided
            let value := sload(b.slot)
            let offset := b.offset
            let shifted := shr(mul(offset, 8), value)
            ret := and(0xffff, shifted)
        }
    }

    // TODO:
    // 1. Store 0xf00dc0de in c
    // 2. Store 0xc0ffee0000d15ea5 in d
    // Note: use yul, bit shifting and bit masking only

    function foodCode() external {
        assembly {
            let slot0 := sload(0)
            // start here
        }
    }

    // TODO:
    // 1. Modify the first two bytes of e to be `0xce00`
    // 2. Add 0xfaceb00c to fill the 9th - 12th byte of variable e inplace
    function facebooc() external {
        assembly {
            let slot0 := sload(0)
            // start here
        }
    }

    // TODO:
    // 1. For e, mask the word `beef` and `bee` and discard all other bytes
    // 2. For d, mask the word `fee`, then add `d` after `fee` on the next byte
    // 3. For b, mask the word `beef` that appears once, and dicard all other packed bytes
    // Update all variables, such that the value in slot 0 returns 0xbeef000000000000bee0000feed00000000000000000beef0000
    function beefBeeFeedBeef() external view {
        assembly {
            let slot0 := sload(0)
            // start here
        }
    }
}
