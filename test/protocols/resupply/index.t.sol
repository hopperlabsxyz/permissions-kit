// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.28;

import {BaseTest, IUsdc} from "@test/Base.t.sol";
import {TestAvatar} from "@test/TestAvatar.sol";
import {Vault} from "@test/interfaces/IVault.sol";
import "@forge-std/Test.sol";

contract LagoonTest is BaseTest {
    struct Permissions {
        bytes[] depositAndBorrow;
    }

    mapping(string => Permissions) internal permissions;

    constructor() {
        _loadPermissions("test/data/permissions.json");
    }

    function _loadPermissions(string memory path) internal {
        string memory json = vm.readFile(path);

        bytes[] memory depositAndBorrow = abi.decode(
            vm.parseJson(json, "$.resupply.depositAndBorrow"),
            (bytes[])
        );

        permissions["resupply"] = Permissions({
            depositAndBorrow: depositAndBorrow
        });
    }
}
