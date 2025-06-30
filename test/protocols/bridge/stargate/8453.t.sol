// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.28;

import "@forge-std/Test.sol";
import {BaseTest, ISimpleOFTAdapter} from "@test/Base.t.sol";
import {TestAvatar} from "@test/TestAvatar.sol";

import {IUsdc} from "@test/interfaces/IUsdc.sol";
import {Vault} from "@test/interfaces/IVault.sol";

address constant UNDERLYING_TOKEN = 0x35E5dB674D8e93a03d814FA0ADa70731efe8a4b9;
address constant SIMPLE_OFT_BASE = 0x2492D0006411Af6C8bbb1c8afc1B0197350a79e9;

contract StargateBridgeTest is BaseTest(8453) {
    bytes[] transfer;

    constructor() {
        _loadPermissions("test/data/permissions8453.json");
    }

    function _loadPermissions(
        string memory path
    ) internal {
        string memory json = vm.readFile(path);
        transfer = abi.decode(vm.parseJson(json, "$.bridge.stargate.transfer"), (bytes[]));
    }
}

contract Transfer is StargateBridgeTest {
    function setUp() public {
        applyPermissionsOnRole(transfer);
    }

    function test_approve() public {
        bytes memory call =
            abi.encodeWithSelector(IUsdc(UNDERLYING_TOKEN).approve.selector, SIMPLE_OFT_BASE, 42);
        vm.prank(manager);
        role.execTransactionWithRole(UNDERLYING_TOKEN, 0, call, 0, TEST_ROLE, false);
    }

    // WIP base, on hold for now
    function test_bridge_usr_from_base() public {
        ISimpleOFTAdapter.SendParam memory sendParam = ISimpleOFTAdapter.SendParam({
            dstEid: 30_111,
            to: bytes32(uint256(uint160(avatar))),
            amountLD: 100,
            minAmountLD: 0,
            extraOptions: "",
            composeMsg: "",
            oftCmd: ""
        });
        ISimpleOFTAdapter.MessagingFee memory messagingFee =
            ISimpleOFTAdapter.MessagingFee({nativeFee: 0, lzTokenFee: 0});

        bytes memory call = abi.encodeWithSelector(
            ISimpleOFTAdapter(UNDERLYING_TOKEN).send.selector, sendParam, messagingFee, avatar
        );

        vm.prank(manager);
        role.execTransactionWithRole(SIMPLE_OFT_BASE, 0, call, 0, TEST_ROLE, false);
    }

    function test_send_with_different_chain_id() public {
        ISimpleOFTAdapter.SendParam memory sendParam = ISimpleOFTAdapter.SendParam({
            dstEid: 30_333,
            to: bytes32(uint256(uint160(avatar))),
            amountLD: 100,
            minAmountLD: 0,
            extraOptions: "",
            composeMsg: "",
            oftCmd: ""
        });
        ISimpleOFTAdapter.MessagingFee memory messagingFee =
            ISimpleOFTAdapter.MessagingFee({nativeFee: 0, lzTokenFee: 0});

        bytes memory call = abi.encodeWithSelector(
            ISimpleOFTAdapter(UNDERLYING_TOKEN).send.selector, sendParam, messagingFee, avatar
        );

        vm.prank(manager);
        vm.expectRevert(); //unsupported chain id
        role.execTransactionWithRole(SIMPLE_OFT_BASE, 0, call, 0, TEST_ROLE, false);
    }

    function test_send_should_revert_with_unvalid_destination() public {
        ISimpleOFTAdapter.SendParam memory sendParam = ISimpleOFTAdapter.SendParam({
            dstEid: 30_111,
            to: bytes32(uint256(uint160(address(42)))),
            amountLD: 100,
            minAmountLD: 0,
            extraOptions: "",
            composeMsg: "",
            oftCmd: ""
        });
        ISimpleOFTAdapter.MessagingFee memory messagingFee =
            ISimpleOFTAdapter.MessagingFee({nativeFee: 0, lzTokenFee: 0});

        bytes memory call = abi.encodeWithSelector(
            ISimpleOFTAdapter(UNDERLYING_TOKEN).send.selector, sendParam, messagingFee, avatar
        );

        vm.prank(manager);
        vm.expectRevert(); // Should revert since destination  address is invalid
        role.execTransactionWithRole(SIMPLE_OFT_BASE, 0, call, 0, TEST_ROLE, false);
    }

    function test_send_should_revert_with_wrong_refund_address() public {
        ISimpleOFTAdapter.SendParam memory sendParam = ISimpleOFTAdapter.SendParam({
            dstEid: 30_332,
            to: bytes32(uint256(uint160(avatar))),
            amountLD: 100,
            minAmountLD: 0,
            extraOptions: "",
            composeMsg: "",
            oftCmd: ""
        });
        ISimpleOFTAdapter.MessagingFee memory messagingFee =
            ISimpleOFTAdapter.MessagingFee({nativeFee: 0, lzTokenFee: 0});

        bytes memory call = abi.encodeWithSelector(
            ISimpleOFTAdapter(UNDERLYING_TOKEN).send.selector, sendParam, messagingFee, address(0)
        );

        vm.prank(manager);
        vm.expectRevert(); // Should revert since refund address is invalid
        role.execTransactionWithRole(SIMPLE_OFT_BASE, 0, call, 0, TEST_ROLE, false);
    }
}
