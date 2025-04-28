// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.28;

import "@forge-std/Test.sol";
import {BaseTest, ISimpleOFTAdapter} from "@test/Base.t.sol";
import {TestAvatar} from "@test/TestAvatar.sol";
import {Vault} from "@test/interfaces/IVault.sol";
import {IUsdc} from "@test/interfaces/IUsdc.sol";

// Constants based on transaction records
address constant UNDERLYING_TOKEN = 0x66a1E37c9b0eAddca17d3662D6c05F4DECf3e110;
address constant SIMPLE_OFT_ADAPTER = 0xD2eE2776F34Ef4E7325745b06E6d464b08D4be0E;

contract StargateBridgeTest is BaseTest {
    bytes[] transfer;

    constructor() {
        _loadPermissions("test/data/permissions.json");
    }

    function _loadPermissions(string memory path) internal {
        string memory json = vm.readFile(path);
        transfer = abi.decode(
            vm.parseJson(json, "$.bridge.stargate.transfer"),
            (bytes[])
        );
    }
}

contract Transfer is StargateBridgeTest {
    function setUp() public {
        applyPermissionsOnRole(transfer);
    }
    function test_approve() public {
        bytes memory call = abi.encodeWithSelector(
            IUsdc(UNDERLYING_TOKEN).approve.selector,
            SIMPLE_OFT_ADAPTER,
            42
        );
        vm.prank(manager);
        role.execTransactionWithRole(UNDERLYING_TOKEN, 0, call, 0, TEST_ROLE, false);
    }

    function test_send_with_full_parameters() public {
        ISimpleOFTAdapter.SendParam memory sendParam = ISimpleOFTAdapter
            .SendParam({
                dstEid: 30332,
                to: bytes32(
                    0x0000000000000000000000005615dEB798BB3E4dFa0139dFa1b3D433Cc23b72f
                ),
                amountLD: 0,
                minAmountLD: 0,
                extraOptions: "",
                composeMsg: "",
                oftCmd: ""
            });
        ISimpleOFTAdapter.MessagingFee memory messagingFee = ISimpleOFTAdapter
            .MessagingFee({nativeFee: 0, lzTokenFee: 0});

        bytes memory call = abi.encodeWithSelector(
            ISimpleOFTAdapter(UNDERLYING_TOKEN).send.selector,
            sendParam,
            messagingFee,
            avatar
        );

        vm.prank(manager);
        role.execTransactionWithRole(
            SIMPLE_OFT_ADAPTER,
            0,
            call,
            0,
            TEST_ROLE,
            false
        );
    }

function test_send_with_different_chain_id() public {
        ISimpleOFTAdapter.SendParam memory sendParam = ISimpleOFTAdapter
            .SendParam({
                dstEid: 30333,
                to: bytes32(
                    0x0000000000000000000000005615dEB798BB3E4dFa0139dFa1b3D433Cc23b72f
                ),
                amountLD: 100,
                minAmountLD: 0,
                extraOptions: "",
                composeMsg: "",
                oftCmd: ""
            });
        ISimpleOFTAdapter.MessagingFee memory messagingFee = ISimpleOFTAdapter
            .MessagingFee({nativeFee: 0, lzTokenFee: 0});

        bytes memory call = abi.encodeWithSelector(
            ISimpleOFTAdapter(UNDERLYING_TOKEN).send.selector,
            sendParam,
            messagingFee,
            avatar
        );

        vm.prank(manager);
        vm.expectRevert();//unsupported chain id
        role.execTransactionWithRole(
            SIMPLE_OFT_ADAPTER,
            0,
            call,
            0,
            TEST_ROLE,
            false
        );
    }


function test_send_should_revert_with_unvalid_destination() public {
        ISimpleOFTAdapter.SendParam memory sendParam = ISimpleOFTAdapter
            .SendParam({
                dstEid: 30332,
                to: bytes32(
                    0x0000000000000000000000000000000000000000000000000000000000000000
                ),
                amountLD: 100,
                minAmountLD: 0,
                extraOptions: "",
                composeMsg: "",
                oftCmd: ""
            });
        ISimpleOFTAdapter.MessagingFee memory messagingFee = ISimpleOFTAdapter
            .MessagingFee({nativeFee: 0, lzTokenFee: 0});

        bytes memory call = abi.encodeWithSelector(
            ISimpleOFTAdapter(UNDERLYING_TOKEN).send.selector,
            sendParam,
            messagingFee,
            avatar
        );

        vm.prank(manager);
        vm.expectRevert(); // Should revert since destination  address is invalid
        role.execTransactionWithRole(
            SIMPLE_OFT_ADAPTER,
            0,
            call,
            0,
            TEST_ROLE,
            false
        );
    }

function test_send_should_revert_with_wrong_refund_address() public {
        ISimpleOFTAdapter.SendParam memory sendParam = ISimpleOFTAdapter
            .SendParam({
                dstEid: 30332,
                to: bytes32(
                    0x0000000000000000000000005615dEB798BB3E4dFa0139dFa1b3D433Cc23b72f
                ),
                amountLD: 100,
                minAmountLD: 0,
                extraOptions: "",
                composeMsg: "",
                oftCmd: ""
            });
        ISimpleOFTAdapter.MessagingFee memory messagingFee = ISimpleOFTAdapter
            .MessagingFee({nativeFee: 0, lzTokenFee: 0});

        bytes memory call = abi.encodeWithSelector(
            ISimpleOFTAdapter(UNDERLYING_TOKEN).send.selector,
            sendParam,
            messagingFee,
            address(0)
        );

        vm.prank(manager);
        vm.expectRevert(); // Should revert since refund address is invalid
        role.execTransactionWithRole(
            SIMPLE_OFT_ADAPTER,
            0,
            call,
            0,
            TEST_ROLE,
            false
        );
    }

}