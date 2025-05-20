// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.28;

import {BaseTest, IUsdc} from "@test/Base.t.sol";
import {TestAvatar} from "@test/TestAvatar.sol";
import {Vault} from "@test/interfaces/IVault.sol";
import {Booster} from "@test/interfaces/IBooster.sol";
import "@forge-std/Test.sol";

address constant BOOSTER = 0xF403C135812408BFbE8713b5A23a04b3D48AAE31;
address constant reUSDsCRV = 0xc522A6606BBA746d7960404F22a3DB936B6F4F50;

contract CurveTest is BaseTest(1) {
    bytes[] deposit;

    constructor() {
        _loadPermissions("test/data/permissions.json");
    }

    function _loadPermissions(string memory path) internal {
        string memory json = vm.readFile(path);

        deposit = abi.decode(vm.parseJson(json, "$.convex.deposit"), (bytes[]));
    }
}

contract DepositStableSwapNg is CurveTest {
    function setUp() public {
        applyPermissionsOnRole(deposit);
    }

    function test_approve() public {
        bytes memory call = abi.encodeWithSelector(
            IUsdc(reUSDsCRV).approve.selector,
            BOOSTER,
            42
        );
        vm.prank(manager);
        role.execTransactionWithRole(reUSDsCRV, 0, call, 0, TEST_ROLE, false);
    }

    function test_deposit() public {
        bytes memory call = abi.encodeWithSelector(
            Booster(BOOSTER).deposit.selector,
            440,
            42
        );
        vm.prank(manager);
        role.execTransactionWithRole(BOOSTER, 0, call, 0, TEST_ROLE, false);
    }

    function test_deposit_revert() public {
        bytes memory call = abi.encodeWithSelector(
            Booster(BOOSTER).deposit.selector,
            1111111111111111,
            42
        );
        vm.prank(manager);
        vm.expectRevert();
        role.execTransactionWithRole(BOOSTER, 0, call, 0, TEST_ROLE, false);
    }

    function test_depositAll() public {
        bytes memory call = abi.encodeWithSelector(
            Booster(BOOSTER).depositAll.selector,
            440
        );
        vm.prank(manager);
        role.execTransactionWithRole(BOOSTER, 0, call, 0, TEST_ROLE, false);
    }

    function test_depositAll_revert() public {
        bytes memory call = abi.encodeWithSelector(
            Booster(BOOSTER).depositAll.selector,
            1111111111111111
        );
        vm.prank(manager);
        vm.expectRevert();
        role.execTransactionWithRole(BOOSTER, 0, call, 0, TEST_ROLE, false);
    }

    function test_withdraw() public {
        bytes memory call = abi.encodeWithSelector(
            Booster(BOOSTER).withdraw.selector,
            440,
            42
        );
        vm.prank(manager);
        role.execTransactionWithRole(BOOSTER, 0, call, 0, TEST_ROLE, false);
    }

    function test_withdrawAll() public {
        bytes memory call = abi.encodeWithSelector(
            Booster(BOOSTER).withdrawAll.selector,
            440
        );
        vm.prank(manager);
        role.execTransactionWithRole(BOOSTER, 0, call, 0, TEST_ROLE, false);
    }

    function test_withdrawTo() public {
        bytes memory call = abi.encodeWithSelector(
            Booster(BOOSTER).withdrawTo.selector,
            440,
            42,
            avatar
        );
        vm.prank(manager);
        role.execTransactionWithRole(BOOSTER, 0, call, 0, TEST_ROLE, false);
    }
}
