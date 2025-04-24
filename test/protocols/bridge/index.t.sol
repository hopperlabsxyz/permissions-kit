// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.28;

import {BaseTest, ISimpleOFTAdapter} from "@test/Base.t.sol";
import {TestAvatar} from "@test/TestAvatar.sol";
import {Vault} from "@test/interfaces/IVault.sol";
import "@forge-std/Test.sol";

contract BridgeTestAdvanced is BaseTest {
    // Constants based on transaction records
    address constant UNDERLYING_TOKEN = 0x66a1E37c9b0eAddca17d3662D6c05F4DECf3e110;
    address constant Proxy_Resolv = 0xD2eE2776F34Ef4E7325745b06E6d464b08D4be0E;
    uint16 constant DST_EID = 30184;
    uint256 constant AMOUNT_LD = 224836000000000000;
    uint256 constant MIN_AMOUNT_LD = 223712735839484713;
    bytes constant EXTRA_OPTIONS = hex"0003";
    bytes constant COMPOSE_MSG = "";
    bytes constant OFT_CMD = "";
    uint256 constant FEE_0 = 86491082257887;
    uint256 constant FEE_1 = 0;
    
    bytes[] transfer;

    constructor() {
        _loadPermissions("test/data/permissions.json");
    }

    function _loadPermissions(string memory path) internal {
        string memory json = vm.readFile(path);
        transfer = abi.decode(
            vm.parseJson(json, "$.bridge.transfer"),
            (bytes[])
        );
    }

    function setUp() public {
        applyPermissionsOnRole(transfer);
    }

    function test_send_with_full_parameters() public {
        // Create parameters exactly matching the transaction record
        bytes memory call = abi.encodeWithSelector(
            ISimpleOFTAdapter(UNDERLYING_TOKEN).send.selector,
            DST_EID,
            abi.encodePacked(avatar), // to address
            AMOUNT_LD,
            MIN_AMOUNT_LD,
            EXTRA_OPTIONS,
            COMPOSE_MSG,
            OFT_CMD,
            [FEE_0, FEE_1],
            avatar // refundAddress
        );
        
        vm.prank(manager);
        role.execTransactionWithRole(
            Proxy_Resolv,
            0,
            call,
            0,
            TEST_ROLE,
            false
        );
    }
    
    // function test_send_with_different_chain_id() public {
    //     // The permissions allow any dstEid
    //     uint16 differentChainId = 31337;
        
    //     bytes memory call = abi.encodeWithSelector(
    //         ISimpleOFTAdapter(UNDERLYING_TOKEN).send.selector,
    //         differentChainId,
    //         abi.encodePacked(avatar),
    //         AMOUNT_LD,
    //         MIN_AMOUNT_LD,
    //         EXTRA_OPTIONS,
    //         COMPOSE_MSG,
    //         OFT_CMD,
    //         [FEE_0, FEE_1],
    //         avatar
    //     );
        
    //     vm.prank(manager);
    //     role.execTransactionWithRole(
    //         UNDERLYING_TOKEN,
    //         0,
    //         call,
    //         0,
    //         TEST_ROLE,
    //         false
    //     );
    // }
    
    // function test_send_with_different_amounts() public {
    //     // The permissions allow any amountLD and minAmountLD
    //     uint256 newAmount = 1000000000000000000; // 1 ETH
    //     uint256 newMinAmount = 990000000000000000; // 0.99 ETH
        
    //     bytes memory call = abi.encodeWithSelector(
    //         ISimpleOFTAdapter(UNDERLYING_TOKEN).send.selector,
    //         DST_EID,
    //         abi.encodePacked(avatar),
    //         newAmount,
    //         newMinAmount,
    //         EXTRA_OPTIONS,
    //         COMPOSE_MSG,
    //         OFT_CMD,
    //         [FEE_0, FEE_1],
    //         avatar
    //     );
        
    //     vm.prank(manager);
    //     role.execTransactionWithRole(
    //         UNDERLYING_TOKEN,
    //         0,
    //         call,
    //         0,
    //         TEST_ROLE,
    //         false
    //     );
    // }
    
    // function test_send_should_revert_with_wrong_destination() public { //ok
    //     address wrongDestination = address(0xdead);
        
    //     bytes memory call = abi.encodeWithSelector(
    //         ISimpleOFTAdapter(UNDERLYING_TOKEN).send.selector,
    //         DST_EID,
    //         abi.encodePacked(wrongDestination), // Not the avatar
    //         AMOUNT_LD,
    //         MIN_AMOUNT_LD,
    //         EXTRA_OPTIONS,
    //         COMPOSE_MSG,
    //         OFT_CMD,
    //         [FEE_0, FEE_1],
    //         avatar
    //     );
        
    //     vm.prank(manager);
    //     vm.expectRevert(); // Should revert since destination must be avatar
    //     role.execTransactionWithRole(
    //         UNDERLYING_TOKEN,
    //         0,
    //         call,
    //         0,
    //         TEST_ROLE,
    //         false
    //     );
    // }
    
    // function test_send_should_revert_with_wrong_refund_address() public { //ok
    //     address wrongRefundAddress = address(0xdead);
        
    //     bytes memory call = abi.encodeWithSelector(
    //         ISimpleOFTAdapter(UNDERLYING_TOKEN).send.selector,
    //         DST_EID,
    //         abi.encodePacked(avatar),
    //         AMOUNT_LD,
    //         MIN_AMOUNT_LD,
    //         EXTRA_OPTIONS,
    //         COMPOSE_MSG,
    //         OFT_CMD,
    //         [FEE_0, FEE_1],
    //         wrongRefundAddress // Not the avatar
    //     );
        
    //     vm.prank(manager);
    //     vm.expectRevert(); // Should revert since refund address must be avatar
    //     role.execTransactionWithRole(
    //         UNDERLYING_TOKEN,
    //         0,
    //         call,
    //         0,
    //         TEST_ROLE,
    //         false
    //     );
    // }
}