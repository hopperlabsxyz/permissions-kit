// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.28;

import {BaseTest} from "@test/Base.t.sol";
import "@forge-std/Test.sol";

contract SimpleTest is BaseTest {
    constructor() {}

    function test_simple_test() public pure {
        assertTrue(true);
    }
}
