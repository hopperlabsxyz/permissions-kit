// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.28;

import {BaseTest, IUsdc} from "@test/Base.t.sol";
import {TestAvatar} from "@test/TestAvatar.sol";
import "@forge-std/Test.sol";

address constant TARGET = 0x07ed467acD4ffd13023046968b0859781cb90D9B; // 9SETH
address constant ASSET = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; // USDC

contract SettleDepositTest is BaseTest {
    constructor() {}

    function test_settle_deposit() public {
        bytes memory data = abi.encodeWithSelector(
            IUsdc(ASSET).approve.selector,
            TARGET,
            10
        );
        vm.prank(manager.addr);
        role.execTransactionWithRole(
            address(IUsdc(ASSET)),
            0,
            data,
            0,
            TEST_ROLE,
            false
        );

        assertEq(IUsdc(ASSET).allowance(address(avatar), TARGET), 10);
    }
}
