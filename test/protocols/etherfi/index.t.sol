// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.28;

import {BaseTest, IUsdc} from "@test/Base.t.sol";
import {TestAvatar} from "@test/TestAvatar.sol";
import {DepositAdapter} from "@test/interfaces/IDepositAdapter.sol";
import "@forge-std/Test.sol";

address payable constant DEPOSIT_ADAPTER = payable(
    0xcfC6d9Bd7411962Bfe7145451A7EF71A24b6A7A2
);
address constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

contract EtherfiTest is BaseTest {
    bytes[] deposit;

    constructor() {
        _loadPermissions("test/data/permissions.json");
    }

    function _loadPermissions(string memory path) internal {
        string memory json = vm.readFile(path);

        deposit = abi.decode(
            vm.parseJson(json, "$.etherfi.deposit"),
            (bytes[])
        );
    }
}

contract Deposit is EtherfiTest {
    function setUp() public {
        applyPermissionsOnRole(deposit);
    }

    function test_approveWETH() public {
        bytes memory call = abi.encodeWithSelector(
            IUsdc(WETH).approve.selector,
            DEPOSIT_ADAPTER,
            42
        );
        vm.prank(manager);
        role.execTransactionWithRole(WETH, 0, call, 0, TEST_ROLE, false);
    }

    function test_depositWETH() public {
        bytes memory call = abi.encodeWithSelector(
            DepositAdapter(DEPOSIT_ADAPTER).depositWETHForWeETH.selector,
            42,
            address(0xdead)
        );
        vm.prank(manager);
        role.execTransactionWithRole(
            DEPOSIT_ADAPTER,
            0,
            call,
            0,
            TEST_ROLE,
            false
        );
    }

    function test_depositETH() public {
        bytes memory call = abi.encodeWithSelector(
            DepositAdapter(DEPOSIT_ADAPTER).depositETHForWeETH.selector,
            address(0xdead)
        );
        vm.prank(manager);
        role.execTransactionWithRole(
            DEPOSIT_ADAPTER,
            1,
            call,
            0,
            TEST_ROLE,
            false
        );
    }
}
