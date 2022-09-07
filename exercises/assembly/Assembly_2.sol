// I AM NOT DONE

pragma solidity ^0.8.4;
contract Add {
    function addAssembly(uint x, uint y) public pure returns (uint) {        

        // Intermediate variables can't communicate 
        assembly {            

            let result := add(x, y)          
        }

        assembly {         
            mstore(0x11, result)                         
        }
        // But can be written to memory in one block        
        // and retrieved in another        
        assembly {            
            return(0x11, 32)            
        }
    }
    
    function addSolidity(uint x, uint y) public pure returns (uint) {
        return x + y;
    }
}


