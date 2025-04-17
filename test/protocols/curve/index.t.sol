// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.28;

import {BaseTest, IUsdc} from "@test/Base.t.sol";
import {TestAvatar} from "@test/TestAvatar.sol";
import {Vault} from "@test/interfaces/IVault.sol";
import {IResupplyPair} from "@test/interfaces/IResupplyPair.sol";
import {YearnV3Vault} from "@test/interfaces/YearnV3Vault.sol";
import "@forge-std/Test.sol";

address constant CRVUSD = 0xf939E0A03FB07F59A73314E73794Be0E57ac1b4E;
address constant SCRVUSD = 0x0655977FEb2f289A4aB78af67BAB0d17aAb84367;

contract CurveTest is BaseTest {
    bytes[] stakeCrvUSD;

    constructor() {
        _loadPermissions("test/data/permissions.json");
    }

    function _loadPermissions(string memory path) internal {
        string memory json = vm.readFile(path);

        stakeCrvUSD = abi.decode(
            vm.parseJson(json, "$.curve.stakeCrvUSD"),
            (bytes[])
        );
    }
}

contract StakeCrvUSD is CurveTest {
    function setUp() public {
        applyPermissionsOnRole(stakeCrvUSD);
    }

    function test_approve() public {
        bytes memory call = abi.encodeWithSelector(
            IUsdc(CRVUSD).approve.selector,
            SCRVUSD,
            42
        );
        vm.prank(manager);
        role.execTransactionWithRole(CRVUSD, 0, call, 0, TEST_ROLE, false);
    }

    function test_deposit() public {
        bytes memory call = abi.encodeWithSelector(
            YearnV3Vault(SCRVUSD).deposit.selector,
            42,
            avatar
        );
        vm.prank(manager);
        role.execTransactionWithRole(SCRVUSD, 0, call, 0, TEST_ROLE, false);
    }
}
