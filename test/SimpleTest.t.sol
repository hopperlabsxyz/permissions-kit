// SPDX-License-Identifier: BUSL-1.1
pragma solidity >= 0.8.28;

import {BaseTest} from "@test/Base.t.sol";
import {TestAvatar} from "@test/TestAvatar.sol";
import "@forge-std/Test.sol";

contract SimpleTest is BaseTest {
    constructor() {}

    function test_simple_test() public pure {
        assertTrue(true);
    }

    function test_check_avatar_balance() public {
        //instantiate the avatar
        TestAvatar avatar = new TestAvatar();
        //check the balance of the avatar
        assertEq(address(avatar).balance, 0);
        //check the balance of the owner
        console.log("Avatar balance: %d", address(avatar).balance);
        //check the address of the avatar
        console.log("Avatar address:", address(avatar));
    }
}