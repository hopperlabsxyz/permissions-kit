// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.28;

import "@forge-std/Test.sol";
import "@forge-std/console.sol";
import {VmSafe} from "@forge-std/Vm.sol";
import {TestAvatar} from "@test/TestAvatar.sol";
import {IUsdc} from "@test/interfaces/IUsdc.sol";
import {IRoles} from "@test/interfaces/IRoles.sol";
import {ZodiacHelpers} from "@test/ZodiacHelpers.t.sol";

contract BaseTest is ZodiacHelpers {
    struct VaultPermissions {
        bytes[] manageVault;
        bytes[] closeVault;
        bytes[] settleVault;
    }

    mapping(string => VaultPermissions) internal permissions;

    constructor() {
        avatar = deployTestAvatar();
        role = deployRolesModifier(roleFactory, address(avatar), roleOwner);
        console.log("ROLE ADDRESS", address(role));
        console.log("MANAGER", manager);
        console.log("AVATAR", address(avatar));
        console.log("ROLE KEY:");
        console.logBytes32(TEST_ROLE);

        bytes32[] memory roleKeys = new bytes32[](1);
        roleKeys[0] = TEST_ROLE;

        bool[] memory memberOf = new bool[](1);
        memberOf[0] = true;

        vm.prank(roleOwner);
        role.assignRoles(manager, roleKeys, memberOf);
        _loadPermissions("test/data/permissions.json");
    }

    function _loadPermissions(string memory path) internal {
        string memory json = vm.readFile(path);

        // lagoon.manageVault
        bytes[] memory manage = abi.decode(
            vm.parseJson(json, "$.lagoon.manageVault"),
            (bytes[])
        );

        // lagoon.closeVault
        bytes[] memory close = abi.decode(
            vm.parseJson(json, "$.lagoon.closeVault"),
            (bytes[])
        );

        // lagoon.settleVault
        bytes[] memory settle = abi.decode(
            vm.parseJson(json, "$.lagoon.settleVault"),
            (bytes[])
        );

        // Store in storage mapping
        permissions["lagoon"] = VaultPermissions({
            manageVault: manage,
            closeVault: close,
            settleVault: settle
        });
    }
}
