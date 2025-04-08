// SPDX-License-Identifier: BUSL-1.1
pragma solidity >= 0.8.28;

import {BaseTest, USDC} from "@test/Base.t.sol";
import {TestAvatar} from "@test/TestAvatar.sol";
import "@forge-std/Test.sol";

contract SimpleTest is BaseTest {
    constructor() {}

    function testApproveUsdc() public {
        
        // assertTrue(true);
        bytes memory data = abi.encodeWithSelector(USDC.approve.selector, 0x64FCC3A02eeEba05Ef701b7eed066c6ebD5d4E51, 10);
        vm.prank(manager.addr);
        role.execTransactionWithRole(address(USDC), 0, data, 0, TEST_ROLE, false);

        assertEq(USDC.allowance(manager.addr, 0x64FCC3A02eeEba05Ef701b7eed066c6ebD5d4E51), 10);
    }
}