// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.28;

import {BaseTest, IUsdc} from "@test/Base.t.sol";
import {TestAvatar} from "@test/TestAvatar.sol";
import {Vault} from "@test/interfaces/IVault.sol";
import "@forge-std/Test.sol";

address constant TARGET = 0x07ed467acD4ffd13023046968b0859781cb90D9B; // 9SETH
address constant ASSET = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; // USDC

contract SettleDepositTest is BaseTest {
    function setUp() public {
        bytes[] memory permissions = parsePermissions(
            "test/protocols/lagoon/settle_deposit.json"
        );
        applyPermissionsOnRole(permissions);
    }

    function test_settle_deposit() public {
        // test to use approve on vault underlying
        bytes memory data = abi.encodeWithSelector(
            IUsdc(ASSET).approve.selector,
            TARGET,
            10
        );
        vm.prank(manager);
        bool success = role.execTransactionWithRole(
            ASSET,
            0,
            data,
            0,
            TEST_ROLE,
            false
        );

        // test to use settle deposit on vault underlying
        data = abi.encodeWithSelector(Vault(TARGET).settleDeposit.selector, 42);
        vm.prank(manager);
        success = role.execTransactionWithRole(
            TARGET,
            0,
            data,
            0,
            TEST_ROLE,
            false
        );
    }

    function test_settle_redeem() public {
        // test to use approve on vault underlying
        bytes memory data = abi.encodeWithSelector(
            IUsdc(ASSET).approve.selector,
            TARGET,
            10
        );
        vm.prank(manager);
        bool success = role.execTransactionWithRole(
            ASSET,
            0,
            data,
            0,
            TEST_ROLE,
            false
        );

        // test to use settle deposit on vault underlying
        data = abi.encodeWithSelector(Vault(TARGET).settleRedeem.selector, 42);
        vm.prank(manager);
        success = role.execTransactionWithRole(
            TARGET,
            0,
            data,
            0,
            TEST_ROLE,
            false
        );
    }
}
