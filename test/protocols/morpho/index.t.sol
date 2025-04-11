// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.28;

import {BaseTest, IUsdc} from "@test/Base.t.sol";
import {TestAvatar} from "@test/TestAvatar.sol";
import {Vault} from "@test/interfaces/IVault.sol";
import "@forge-std/Test.sol";

//TODO: need to be setup correctly
// address constant TARGET = 0x07ed467acD4ffd13023046968b0859781cb90D9B; // 9SETH
// address constant ASSET = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; // USDC

contract DepositTest is BaseTest {
    //TODO: need to setup json file correctly, a script?
    function setUp() public {
        bytes[] memory permissions = parsePermissions(//TODO: need to be scripted automatically "test/protocols/${PROTOCOL}/deposit.json"
            "test/protocols/morpho/deposit.json"
        );
        applyPermissionsOnRole(permissions);
    }

    // function test_deposit() public {
    //     // test to use approve on vault underlying
    //     bytes memory data = abi.encodeWithSelector(
    //         IUsdc(ASSET).approve.selector,
    //         TARGET,
    //         10
    //     );
    //     vm.prank(manager);
    //     bool success = role.execTransactionWithRole(
    //         ASSET,
    //         0,
    //         data,
    //         0,
    //         TEST_ROLE,
    //         false
    //     );

    //     // test to use settle deposit on vault underlying
    //     data = abi.encodeWithSelector(Vault(TARGET).settleDeposit.selector, 42);
    //     vm.prank(manager);
    //     success = role.execTransactionWithRole(
    //         TARGET,
    //         0,
    //         data,
    //         0,
    //         TEST_ROLE,
    //         false
    //     );
    // }

    // function test_withdraw() public {
    //     // test to use approve on vault underlying
    //     bytes memory data = abi.encodeWithSelector(
    //         IUsdc(ASSET).approve.selector,
    //         TARGET,
    //         10
    //     );
    //     vm.prank(manager);
    //     bool success = role.execTransactionWithRole(
    //         ASSET,
    //         0,
    //         data,
    //         0,
    //         TEST_ROLE,
    //         false
    //     );

    //     // test to use settle deposit on vault underlying
    //     data = abi.encodeWithSelector(Vault(TARGET).settleRedeem.selector, 42);
    //     vm.prank(manager);
    //     success = role.execTransactionWithRole(
    //         TARGET,
    //         0,
    //         data,
    //         0,
    //         TEST_ROLE,
    //         false
    //     );
    // }
}
