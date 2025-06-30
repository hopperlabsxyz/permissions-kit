// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.28;

import "@forge-std/Test.sol";
import {BaseTest, IUsdc} from "@test/Base.t.sol";
import {TestAvatar} from "@test/TestAvatar.sol";
import {IResupplyPair} from "@test/interfaces/IResupplyPair.sol";
import {Vault} from "@test/interfaces/IVault.sol";

address constant UNDERLYING_TOKEN = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

address constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
address constant BORING_VAULT = 0x294eecec65A0142e84AEdfD8eB2FBEA8c9a9fbad;
address constant TELLER = 0xe97365b41B340352d3d32CA2C7230330F19A1e73;

contract Se7enseasTest is BaseTest(1) {
    bytes[] depositBoringVault;

    constructor() {
        depositBoringVault = loadPermissions("$.se7enseas.depositBoringVault");
    }
}

contract DepositBoringVaultTest is Se7enseasTest {
    function setUp() public {
        applyPermissionsOnRole(depositBoringVault);
    }

    function test_approve() public {
        bytes memory call = abi.encodeWithSelector(
            IUsdc(UNDERLYING_TOKEN).approve.selector,
            BORING_VAULT,
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

    function test_erc20() public {
        bytes memory call = abi.encodeWithSignature(
            "deposit(address,uint256,uint256)",
            UNDERLYING_TOKEN,
            42,
            42
        );
        vm.prank(manager);
        role.execTransactionWithRole(TELLER, 0, call, 0, TEST_ROLE, false);
    }

    function test_eth() public {
        bytes memory call = abi.encodeWithSignature(
            "deposit(address,uint256,uint256)",
            ETH,
            42,
            42
        );
        vm.prank(manager);
        role.execTransactionWithRole(TELLER, 0, call, 0, TEST_ROLE, false);
    }
}
