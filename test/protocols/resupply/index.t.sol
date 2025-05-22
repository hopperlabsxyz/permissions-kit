// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.28;

import "@forge-std/Test.sol";
import {BaseTest, IUsdc} from "@test/Base.t.sol";
import {TestAvatar} from "@test/TestAvatar.sol";
import {IResupplyPair} from "@test/interfaces/IResupplyPair.sol";
import {Vault} from "@test/interfaces/IVault.sol";

address constant UNDERLYING_TOKEN = 0xf939E0A03FB07F59A73314E73794Be0E57ac1b4E;
address constant PAIR_POOL = 0xCF1deb0570c2f7dEe8C07A7e5FA2bd4b2B96520D;
address constant LOAN_TOKEN = 0x57aB1E0003F623289CD798B1824Be09a793e4Bec; //WETH

contract ResupplyTest is BaseTest(1) {
    bytes[] depositAndBorrow;
    bytes[] deposit;
    bytes[] borrow;

    constructor() {
        _loadPermissions("test/data/permissions.json");
    }

    function _loadPermissions(
        string memory path
    ) internal {
        string memory json = vm.readFile(path);

        depositAndBorrow = abi.decode(vm.parseJson(json, "$.resupply.depositAndBorrow"), (bytes[]));
        deposit = abi.decode(vm.parseJson(json, "$.resupply.deposit"), (bytes[]));
        borrow = abi.decode(vm.parseJson(json, "$.resupply.borrow"), (bytes[]));
    }
}

contract DepositTest is ResupplyTest {
    function setUp() public {
        applyPermissionsOnRole(deposit);
    }

    function test_approve() public {
        bytes memory call = abi.encodeWithSelector(IUsdc(UNDERLYING_TOKEN).approve.selector, PAIR_POOL, 10);
        vm.prank(manager);
        role.execTransactionWithRole(UNDERLYING_TOKEN, 0, call, 0, TEST_ROLE, false);
    }

    function test_addCollateral() public {
        bytes memory call =
            abi.encodeWithSelector(IResupplyPair(PAIR_POOL).addCollateral.selector, 10, avatar);
        vm.prank(manager);
        role.execTransactionWithRole(PAIR_POOL, 0, call, 0, TEST_ROLE, false);
    }

    function test_addCollateral_revert() public {
        bytes memory call =
            abi.encodeWithSelector(IResupplyPair(PAIR_POOL).addCollateral.selector, 10, address(0xdead));
        vm.prank(manager);
        vm.expectRevert();
        role.execTransactionWithRole(PAIR_POOL, 0, call, 0, TEST_ROLE, false);
    }

    function test_removeCollateral() public {
        bytes memory call =
            abi.encodeWithSelector(IResupplyPair(PAIR_POOL).removeCollateral.selector, 10, avatar);
        vm.prank(manager);
        role.execTransactionWithRole(PAIR_POOL, 0, call, 0, TEST_ROLE, false);
    }

    function test_getReward() public {
        bytes memory call = abi.encodeWithSignature("getReward(address)", avatar);
        vm.prank(manager);
        role.execTransactionWithRole(PAIR_POOL, 0, call, 0, TEST_ROLE, false);
    }

    function test_getRewardForward() public {
        bytes memory call = abi.encodeWithSignature("getReward(address,address)", avatar, avatar);
        vm.prank(manager);
        role.execTransactionWithRole(PAIR_POOL, 0, call, 0, TEST_ROLE, false);
    }

    function test_withdrawCollateral_revert() public {
        bytes memory call =
            abi.encodeWithSelector(IResupplyPair(PAIR_POOL).removeCollateral.selector, 10, address(0xdead));
        vm.prank(manager);
        vm.expectRevert();
        role.execTransactionWithRole(PAIR_POOL, 0, call, 0, TEST_ROLE, false);
    }
}

contract BorrowTest is ResupplyTest {
    function setUp() public {
        applyPermissionsOnRole(borrow);
    }

    function test_approve() public {
        bytes memory call = abi.encodeWithSelector(IUsdc(LOAN_TOKEN).approve.selector, PAIR_POOL, 10);
        vm.prank(manager);
        role.execTransactionWithRole(LOAN_TOKEN, 0, call, 0, TEST_ROLE, false);
    }

    function test_borrow() public {
        bytes memory call = abi.encodeWithSelector(IResupplyPair(PAIR_POOL).borrow.selector, 5, 5, avatar);
        vm.prank(manager);
        role.execTransactionWithRole(PAIR_POOL, 0, call, 0, TEST_ROLE, false);
    }

    function test_borrow_revert() public {
        bytes memory call =
            abi.encodeWithSelector(IResupplyPair(PAIR_POOL).borrow.selector, 5, 5, address(0xdead));
        vm.prank(manager);
        vm.expectRevert();
        role.execTransactionWithRole(PAIR_POOL, 0, call, 0, TEST_ROLE, false);
    }

    function test_repay() public {
        bytes memory call = abi.encodeWithSelector(IResupplyPair(PAIR_POOL).repay.selector, 5, avatar);
        vm.prank(manager);
        role.execTransactionWithRole(PAIR_POOL, 0, call, 0, TEST_ROLE, false);
    }

    function test_repay_revert() public {
        bytes memory call =
            abi.encodeWithSelector(IResupplyPair(PAIR_POOL).repay.selector, 5, address(0xdead));
        vm.prank(manager);
        vm.expectRevert();
        role.execTransactionWithRole(PAIR_POOL, 0, call, 0, TEST_ROLE, false);
    }
}

contract DepositAndBorrowTest is ResupplyTest {
    function setUp() public {
        applyPermissionsOnRole(depositAndBorrow);
    }

    function test_approve() public {
        bytes memory call = abi.encodeWithSelector(IUsdc(UNDERLYING_TOKEN).approve.selector, PAIR_POOL, 10);
        vm.prank(manager);
        role.execTransactionWithRole(UNDERLYING_TOKEN, 0, call, 0, TEST_ROLE, false);
    }

    function test_addCollateral() public {
        bytes memory call =
            abi.encodeWithSelector(IResupplyPair(PAIR_POOL).addCollateral.selector, 10, avatar);
        vm.prank(manager);
        role.execTransactionWithRole(PAIR_POOL, 0, call, 0, TEST_ROLE, false);
    }

    function test_addCollateral_revert() public {
        bytes memory call =
            abi.encodeWithSelector(IResupplyPair(PAIR_POOL).addCollateral.selector, 10, address(0xdead));
        vm.prank(manager);
        vm.expectRevert();
        role.execTransactionWithRole(PAIR_POOL, 0, call, 0, TEST_ROLE, false);
    }
}
