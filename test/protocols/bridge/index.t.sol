// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.28;

import {BaseTest, ISimpleOFTAdapter} from "@test/Base.t.sol";
import {TestAvatar} from "@test/TestAvatar.sol";
import {Vault} from "@test/interfaces/IVault.sol";
import {IResupplyPair} from "@test/interfaces/IResupplyPair.sol";
import "@forge-std/Test.sol";

address constant UNDERLYING_TOKEN = 0x66a1E37c9b0eAddca17d3662D6c05F4DECf3e110;
address constant SimpleOFTAdapter = 0xC4543073Bfaba77781B46dfb4D43b5Ae4e30Eb28;

// address constant LOAN_TOKEN = 0x57aB1E0003F623289CD798B1824Be09a793e4Bec; //WETH

contract BridgeTest is BaseTest {
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
}

contract ApproveAndTransferTest is BridgeTest {
    function setUp() public {
        applyPermissionsOnRole(transfer);
    }

    function test_send() public {
        bytes memory call = abi.encodeWithSelector(
            ISimpleOFTAdapter(UNDERLYING_TOKEN).send.selector,
            SimpleOFTAdapter,
            10
        );
        vm.prank(manager);
        role.execTransactionWithRole(
            UNDERLYING_TOKEN,
            0,
            call,
            0,
            TEST_ROLE,
            false
        );
    }
}

// contract DepositAndBorrowTest is ResupplyTest {
//     function setUp() public {
//         applyPermissionsOnRole(depositAndBorrow);
//     }

//     function test_approve() public {
//         bytes memory call = abi.encodeWithSelector(
//             IUsdc(UNDERLYING_TOKEN).approve.selector,
//             PAIR_POOL,
//             10
//         );
//         vm.prank(manager);
//         role.execTransactionWithRole(
//             UNDERLYING_TOKEN,
//             0,
//             call,
//             0,
//             TEST_ROLE,
//             false
//         );
//     }

//     function test_addCollateral() public {
//         bytes memory call = abi.encodeWithSelector(
//             IResupplyPair(PAIR_POOL).addCollateral.selector,
//             10,
//             avatar
//         );
//         vm.prank(manager);
//         role.execTransactionWithRole(PAIR_POOL, 0, call, 0, TEST_ROLE, false);
//     }

//     function test_addCollateral_revert() public {
//         bytes memory call = abi.encodeWithSelector(
//             IResupplyPair(PAIR_POOL).addCollateral.selector,
//             10,
//             address(0xdead)
//         );
//         vm.prank(manager);
//         vm.expectRevert();
//         role.execTransactionWithRole(PAIR_POOL, 0, call, 0, TEST_ROLE, false);
//     }
// }
