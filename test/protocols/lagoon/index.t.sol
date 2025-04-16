// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.28;

import {BaseTest, IUsdc} from "@test/Base.t.sol";
import {TestAvatar} from "@test/TestAvatar.sol";
import {Vault} from "@test/interfaces/IVault.sol";
import "@forge-std/Test.sol";

address constant TARGET = 0x07ed467acD4ffd13023046968b0859781cb90D9B; // 9SETH
address constant ASSET = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; // USDC

contract LagoonTest is BaseTest {
    bytes[] manageVault;
    bytes[] closeVault;
    bytes[] settleVault;

    constructor() {
        _loadPermissions("test/data/permissions.json");
    }

    function _loadPermissions(string memory path) internal {
        string memory json = vm.readFile(path);

        manageVault = abi.decode(
            vm.parseJson(json, "$.lagoon.manageVault"),
            (bytes[])
        );

        closeVault = abi.decode(
            vm.parseJson(json, "$.lagoon.closeVault"),
            (bytes[])
        );

        settleVault = abi.decode(
            vm.parseJson(json, "$.lagoon.settleVault"),
            (bytes[])
        );
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
