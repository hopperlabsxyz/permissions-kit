// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";

contract ExampleTest is Test {
    function setUp() public {
        // Setup code here
    }

    function testExample() public pure {
        //test function pure since it doesn't read or modify state
        // Test code here
        assertTrue(true, "This is an example test");
    }
}


//README:
//Foundry's testing conventions:
// Test files end with .t.sol
// Test functions start with test
// Inherits from Test contract for assertion utilities
// Uses setUp() for initialization (though empty in our example)


//How to use:
// # Run all tests
//    forge test
   
//    # Run tests with verbosity
//    forge test -vv
   
//    # Run a specific test file
//    forge test --match-path test/Example.t.sol