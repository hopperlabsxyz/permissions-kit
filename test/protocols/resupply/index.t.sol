// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.28;

import {BaseTest, IUsdc} from "@test/Base.t.sol";
import {TestAvatar} from "@test/TestAvatar.sol";
import {Vault} from "@test/interfaces/IVault.sol";
import {IResupplyPair} from "@test/interfaces/IResupplyPair.sol";
import "@forge-std/Test.sol";

address constant ASSET = 0xf939E0A03FB07F59A73314E73794Be0E57ac1b4E;
address constant TARGET = 0xCF1deb0570c2f7dEe8C07A7e5FA2bd4b2B96520D;

contract ResupplyTest is BaseTest {
    bytes[] depositAndBorrow;
    bytes[] deposit;

    constructor() {
        _loadPermissions("test/data/permissions.json");
    }

    function _loadPermissions(string memory path) internal {
        string memory json = vm.readFile(path);

        depositAndBorrow = abi.decode(
            vm.parseJson(json, "$.resupply.depositAndBorrow"),
            (bytes[])
        );
        deposit = abi.decode(
            vm.parseJson(json, "$.resupply.deposit"),
            (bytes[])
        );
    }
}

contract DepositTest is ResupplyTest {
    function setUp() public {
        applyPermissionsOnRole(deposit);
    }

    function test_approve() public {
        bytes memory call = abi.encodeWithSelector(
            IUsdc(ASSET).approve.selector,
            TARGET,
            10
        );
        vm.prank(manager);
        role.execTransactionWithRole(ASSET, 0, call, 0, TEST_ROLE, false);
    }

    function test_addCollateral() public {
        bytes memory call = abi.encodeWithSelector(
            IResupplyPair(TARGET).addCollateral.selector,
            10,
            avatar
        );
        vm.prank(manager);
        role.execTransactionWithRole(TARGET, 0, call, 0, TEST_ROLE, false);
    }

    function test_addCollateral_revert() public {
        bytes memory call = abi.encodeWithSelector(
            IResupplyPair(TARGET).addCollateral.selector,
            10,
            address(0xdead)
        );
        vm.prank(manager);
        vm.expectRevert();
        role.execTransactionWithRole(TARGET, 0, call, 0, TEST_ROLE, false);
    }

    function test_removeCollateral() public{
        bytes memory call = abi.encodeWithSelector(
            IResupplyPair(TARGET).removeCollateral.selector,
            10,
            avatar
        );
        vm.prank(manager);
        role.execTransactionWithRole(TARGET, 0, call, 0, TEST_ROLE, false);
    }

        function test_withdrawCollateral_revert() public{
        bytes memory call = abi.encodeWithSelector(
            IResupplyPair(TARGET).removeCollateral.selector,
            10,
            address(0xdead)
        );
        vm.prank(manager);
        vm.expectRevert();
        role.execTransactionWithRole(TARGET, 0, call, 0, TEST_ROLE, false);
    }
}

contract DepositAndBorrowTest is ResupplyTest {
    function setUp() public {
        applyPermissionsOnRole(depositAndBorrow);
    }

    function test_approve() public {
        bytes memory call = abi.encodeWithSelector(
            IUsdc(ASSET).approve.selector,
            TARGET,
            10
        );
        vm.prank(manager);
        role.execTransactionWithRole(ASSET, 0, call, 0, TEST_ROLE, false);
    }

    function test_addCollateral() public {
        bytes memory call = abi.encodeWithSelector(
            IResupplyPair(TARGET).addCollateral.selector,
            10,
            avatar
        );
        vm.prank(manager);
        role.execTransactionWithRole(TARGET, 0, call, 0, TEST_ROLE, false);
    }

    function test_addCollateral_revert() public {
        bytes memory call = abi.encodeWithSelector(
            IResupplyPair(TARGET).addCollateral.selector,
            10,
            address(0xdead)
        );
        vm.prank(manager);
        vm.expectRevert();
        role.execTransactionWithRole(TARGET, 0, call, 0, TEST_ROLE, false);
    }

}
