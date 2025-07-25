// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.28;

import "@forge-std/Test.sol";
import {BaseTest, IUsdc} from "@test/Base.t.sol";
import {TestAvatar} from "@test/TestAvatar.sol";
import {Vault} from "@test/interfaces/IVault.sol";

address constant TARGET = 0x07ed467acD4ffd13023046968b0859781cb90D9B; // 9SETH
address constant ASSET = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; // USDC

contract LagoonTest is BaseTest(1) {
    bytes[] depositAndWithdrawFromVault;
    bytes[] manageVault;
    bytes[] closeVault;
    bytes[] settleVault;

    constructor() {
        depositAndWithdrawFromVault = loadPermissions(
            "$.lagoon.depositAndWithdrawFromVault"
        );
        manageVault = loadPermissions("$.lagoon.manageVault");
        closeVault = loadPermissions("$.lagoon.closeVault");
        settleVault = loadPermissions("$.lagoon.settleVault");
    }
}

contract SettleVaultTest is LagoonTest {
    function setUp() public {
        applyPermissionsOnRole(settleVault);
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

    function test_settleDeposit() public {
        bytes memory call = abi.encodeWithSelector(
            Vault(TARGET).settleDeposit.selector,
            42
        );
        vm.prank(manager);
        role.execTransactionWithRole(TARGET, 0, call, 0, TEST_ROLE, false);
    }

    function test_settleRedeem() public {
        bytes memory call = abi.encodeWithSelector(
            Vault(TARGET).settleRedeem.selector,
            42
        );
        vm.prank(manager);
        role.execTransactionWithRole(TARGET, 0, call, 0, TEST_ROLE, false);
    }
}

contract CloseVaultTest is LagoonTest {
    function setUp() public {
        applyPermissionsOnRole(closeVault);
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

    function test_initiateClosing() public {
        bytes memory call = abi.encodeWithSelector(
            Vault(TARGET).initiateClosing.selector
        );
        vm.prank(manager);
        role.execTransactionWithRole(TARGET, 0, call, 0, TEST_ROLE, false);
    }

    function test_close() public {
        bytes memory call = abi.encodeWithSelector(
            Vault(TARGET).close.selector,
            42
        );
        vm.prank(manager);
        role.execTransactionWithRole(TARGET, 0, call, 0, TEST_ROLE, false);
    }
}

contract ManageVaultTest is LagoonTest {
    function setUp() public {
        applyPermissionsOnRole(manageVault);
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

    function test_settleDeposit() public {
        bytes memory call = abi.encodeWithSelector(
            Vault(TARGET).settleDeposit.selector,
            42
        );
        vm.prank(manager);
        role.execTransactionWithRole(TARGET, 0, call, 0, TEST_ROLE, false);
    }

    function test_settleRedeem() public {
        bytes memory call = abi.encodeWithSelector(
            Vault(TARGET).settleRedeem.selector,
            42
        );
        vm.prank(manager);
        role.execTransactionWithRole(TARGET, 0, call, 0, TEST_ROLE, false);
    }

    function test_update_lifespan() public {
        bytes memory call = abi.encodeWithSelector(
            Vault(TARGET).updateTotalAssetsLifespan.selector,
            24
        );
        vm.prank(manager);
        role.execTransactionWithRole(TARGET, 0, call, 0, TEST_ROLE, false);
    }

    function test_update_invalid_lifespan() public {
        bytes memory call = abi.encodeWithSelector(
            Vault(TARGET).updateTotalAssetsLifespan.selector,
            300_000_000_000_000
        );
        vm.prank(manager);
        vm.expectRevert();
        role.execTransactionWithRole(TARGET, 0, call, 0, TEST_ROLE, false);
    }

    function test_expireTotalAssets() public {
        bytes memory call = abi.encodeWithSelector(
            Vault(TARGET).expireTotalAssets.selector
        );
        vm.prank(manager);
        role.execTransactionWithRole(TARGET, 0, call, 0, TEST_ROLE, false);
    }

    function test_initiateClosing() public {
        bytes memory call = abi.encodeWithSelector(
            Vault(TARGET).initiateClosing.selector
        );
        vm.prank(manager);
        role.execTransactionWithRole(TARGET, 0, call, 0, TEST_ROLE, false);
    }

    function test_close() public {
        bytes memory call = abi.encodeWithSelector(
            Vault(TARGET).close.selector,
            42
        );
        vm.prank(manager);
        role.execTransactionWithRole(TARGET, 0, call, 0, TEST_ROLE, false);
    }

    struct Rates {
        uint16 managementRate;
        uint16 performanceRate;
    }

    function test_updateRates() public {
        bytes memory call = abi.encodeWithSelector(
            Vault(TARGET).updateRates.selector,
            Rates({managementRate: 42, performanceRate: 42})
        );
        vm.prank(manager);
        role.execTransactionWithRole(TARGET, 0, call, 0, TEST_ROLE, false);
    }

    function test_canClaimSharesOnBehalf() public {
        bytes memory call = abi.encodeWithSelector(
            Vault(TARGET).claimSharesOnBehalf.selector
        );
        vm.prank(manager);
        role.execTransactionWithRole(TARGET, 0, call, 0, TEST_ROLE, false);
    }
}

contract DepositAndWithdrawFromVaultTest is LagoonTest {
    function setUp() public {
        applyPermissionsOnRole(depositAndWithdrawFromVault);
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

    function test_requestDeposit1() public {
        bytes memory call = abi.encodeWithSignature(
            "requestDeposit(uint256,address,address)",
            42,
            address(avatar),
            address(avatar)
        );
        vm.prank(manager);
        role.execTransactionWithRole(TARGET, 0, call, 0, TEST_ROLE, false);
    }

    function test_requestDeposit2() public {
        bytes memory call = abi.encodeWithSignature(
            "requestDeposit(uint256,address,address,address)",
            42,
            address(avatar),
            address(avatar),
            address(0x1) // referral code
        );
        vm.prank(manager);
        role.execTransactionWithRole(TARGET, 0, call, 0, TEST_ROLE, false);
    }

    function test_requestRedeem() public {
        bytes memory call = abi.encodeWithSignature(
            "requestRedeem(uint256,address,address)",
            42,
            address(avatar),
            address(avatar)
        );
        vm.prank(manager);
        role.execTransactionWithRole(TARGET, 0, call, 0, TEST_ROLE, false);
    }

    function test_claimSharesAndRequestRedeem() public {
        bytes memory call = abi.encodeWithSignature(
            "claimSharesAndRequestRedeem(uint256)",
            42
        );
        vm.prank(manager);
        role.execTransactionWithRole(TARGET, 0, call, 0, TEST_ROLE, false);
    }

    function test_deposit1() public {
        bytes memory call = abi.encodeWithSignature(
            "deposit(uint256,address)",
            42,
            address(avatar)
        );
        vm.prank(manager);
        role.execTransactionWithRole(TARGET, 0, call, 0, TEST_ROLE, false);
    }

    function test_deposit2() public {
        bytes memory call = abi.encodeWithSignature(
            "deposit(uint256,address,address)",
            42,
            address(avatar),
            address(avatar)
        );
        vm.prank(manager);
        role.execTransactionWithRole(TARGET, 0, call, 0, TEST_ROLE, false);
    }

    function test_sync_deposit() public {
        bytes memory call = abi.encodeWithSignature(
            "syncDeposit(uint256,address,address)",
            24,
            address(avatar),
            address(avatar)
        );
        vm.prank(manager);
        role.execTransactionWithRole(TARGET, 0, call, 0, TEST_ROLE, false);
    }

    function test_mint1() public {
        bytes memory call = abi.encodeWithSignature(
            "mint(uint256,address,address)",
            42,
            address(avatar),
            address(avatar)
        );
        vm.prank(manager);
        role.execTransactionWithRole(TARGET, 0, call, 0, TEST_ROLE, false);
    }

    function test_mint2() public {
        bytes memory call = abi.encodeWithSignature(
            "mint(uint256,address)",
            42,
            address(avatar)
        );
        vm.prank(manager);
        role.execTransactionWithRole(TARGET, 0, call, 0, TEST_ROLE, false);
    }

    function test_redeem() public {
        bytes memory call = abi.encodeWithSignature(
            "redeem(uint256,address,address)",
            42,
            address(avatar),
            address(avatar)
        );
        vm.prank(manager);
        role.execTransactionWithRole(TARGET, 0, call, 0, TEST_ROLE, false);
    }

    function test_withdraw() public {
        bytes memory call = abi.encodeWithSignature(
            "withdraw(uint256,address,address)",
            42,
            address(avatar),
            address(avatar)
        );
        vm.prank(manager);
        role.execTransactionWithRole(TARGET, 0, call, 0, TEST_ROLE, false);
    }
}
