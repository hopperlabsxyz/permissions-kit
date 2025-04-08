// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.28;

import {BaseTest, USDC} from "@test/Base.t.sol";
import {TestAvatar} from "@test/TestAvatar.sol";
import "@forge-std/Test.sol";

address constant SPECTRA = 0x64FCC3A02eeEba05Ef701b7eed066c6ebD5d4E51;

contract SimpleTest is BaseTest {
    constructor() {}

    function test_manager_is_member_of_role() public view {
        assertTrue(
            role.isModuleEnabled(manager.addr),
            "manager is not enabled as module on the role modifier"
        );
    }

    function test_approve_usdc() public {
        bytes memory data = abi.encodeWithSelector(
            USDC.approve.selector,
            SPECTRA,
            10
        );
        console.logBytes32(TEST_ROLE);
        vm.prank(manager.addr);
        role.execTransactionWithRole(
            address(USDC),
            0,
            data,
            0,
            TEST_ROLE,
            false
        );

        assertEq(USDC.allowance(address(avatar), SPECTRA), 10);
    }
}

