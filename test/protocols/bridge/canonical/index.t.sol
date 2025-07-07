// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.28;

import "@forge-std/Test.sol";
import {BaseTest, ISimpleOFTAdapter} from "@test/Base.t.sol";
import {TestAvatar} from "@test/TestAvatar.sol";
import {L1StandardBridge} from "@test/interfaces/IL1StandardBridge.sol";

//implementation: 0x2492d0006411af6c8bbb1c8afc1b0197350a79e9

address payable constant MAINNET_TO_UNICHAIN = payable(
    0x81014F44b0a345033bB2b3B21C7a1A308B35fEeA
);

contract CanonicalBridgeTest is BaseTest(1) {
    bytes[] transfer;

    constructor() {
        transfer = loadPermissions("$.bridge.canonical.transfer");
    }
}

contract Transfer is CanonicalBridgeTest {
    function setUp() public {
        applyPermissionsOnRole(transfer);
    }

    function test_bridgeETHTO() public {
        bytes memory call = abi.encodeWithSelector(
            L1StandardBridge(MAINNET_TO_UNICHAIN).bridgeETHTo.selector,
            avatar,
            0,
            bytes32("")
        );
        vm.prank(manager);
        role.execTransactionWithRole(
            MAINNET_TO_UNICHAIN,
            0,
            call,
            0,
            TEST_ROLE,
            false
        );
    }

    function test_finalizeBridgeETH() public {
        bytes memory call = abi.encodeWithSelector(
            L1StandardBridge(MAINNET_TO_UNICHAIN).finalizeBridgeETH.selector,
            address(0xdead),
            address(0xdead),
            0,
            bytes32("")
        );
        vm.prank(manager);
        role.execTransactionWithRole(
            MAINNET_TO_UNICHAIN,
            0,
            call,
            0,
            TEST_ROLE,
            false
        );
    }
}
