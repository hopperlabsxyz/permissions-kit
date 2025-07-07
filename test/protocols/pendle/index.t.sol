// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.28;

import "@forge-std/Test.sol";
import {BaseTest, IUsdc} from "@test/Base.t.sol";
import {TestAvatar} from "@test/TestAvatar.sol";
import {Vault} from "@test/interfaces/IVault.sol";
import {IActionAddRemoveLiqV3} from "@test/interfaces/base/IActionAddRemoveLiqV3.sol";

address constant USR = 0x35E5dB674D8e93a03d814FA0ADa70731efe8a4b9;
address constant USR_MARKET = 0x715509Bde846104cF2cCeBF6fdF7eF1BB874Bc45; //USR-BASE
address constant PENDLEROUTERV4 = 0x888888888889758F76e7103c6CbF23ABbF58F946; //proxy

contract PendleTest is BaseTest(8453) {
    bytes[] deposit;

    constructor() {
        deposit = loadPermissions("$.pendle.deposit");
    }
}

contract DepositTokenTest is PendleTest {
    function setUp() public {
        applyPermissionsOnRole(deposit);
    }

    function test_approve() public {
        bytes memory call = abi.encodeWithSelector(
            IUsdc(USR).approve.selector,
            PENDLEROUTERV4,
            30
        );
        vm.prank(manager);
        role.execTransactionWithRole(USR, 0, call, 0, TEST_ROLE, false);
    }

    function test_pendle_addLiquiditySingleToken() public {
        bytes memory call = abi.encodeWithSelector(
            IActionAddRemoveLiqV3(PENDLEROUTERV4)
                .addLiquiditySingleToken
                .selector,
            avatar,
            USR_MARKET,
            3,
            0,
            0
        );
        vm.prank(manager);
        role.execTransactionWithRole(
            PENDLEROUTERV4,
            0,
            call,
            0,
            TEST_ROLE,
            false
        );
    }

    //test should fail
    function test_pendle_addLiquiditySingleToken_wrong_market() public {
        bytes memory call = abi.encodeWithSelector(
            IActionAddRemoveLiqV3(PENDLEROUTERV4)
                .addLiquiditySingleToken
                .selector,
            avatar,
            PENDLEROUTERV4, //should be USR_MARKET
            3,
            0,
            0
        );
        vm.prank(manager);
        vm.expectRevert();
        role.execTransactionWithRole(
            PENDLEROUTERV4,
            0,
            call,
            0,
            TEST_ROLE,
            false
        );
    }

    function test_pendle_removeLiquiditySingleToken() public {
        bytes memory call = abi.encodeWithSelector(
            IActionAddRemoveLiqV3(PENDLEROUTERV4)
                .removeLiquiditySingleToken
                .selector,
            avatar,
            USR_MARKET,
            3,
            0,
            0
        );
        vm.prank(manager);
        role.execTransactionWithRole(
            PENDLEROUTERV4,
            0,
            call,
            0,
            TEST_ROLE,
            false
        );
    }

    function test_pendle_removeLiquiditySingleToken_wrong_market() public {
        bytes memory call = abi.encodeWithSelector(
            IActionAddRemoveLiqV3(PENDLEROUTERV4)
                .removeLiquiditySingleToken
                .selector,
            avatar,
            PENDLEROUTERV4, //should be USR_MARKET
            3,
            0,
            0
        );
        vm.prank(manager);
        vm.expectRevert();
        role.execTransactionWithRole(
            PENDLEROUTERV4,
            0,
            call,
            0,
            TEST_ROLE,
            false
        );
    }
}
