// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.28;

import {BaseTest} from "./Base.t.sol";
import "../lib/forge-std/src/Test.sol";

contract SimpleTest is BaseTest {
    constructor() {}

    function test_simple_test() public pure {
        assertTrue(true);
    }
}
