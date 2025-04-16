// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.28;

import {BaseTest, IUsdc} from "@test/Base.t.sol";
import {TestAvatar} from "@test/TestAvatar.sol";
import {Vault} from "@test/interfaces/IVault.sol";
import "@forge-std/Test.sol";

contract ResupplyTest is BaseTest {
    bytes[] depositAndBorrow;

    constructor() {
        _loadPermissions("test/data/permissions.json");
    }

    function _loadPermissions(string memory path) internal {
        string memory json = vm.readFile(path);

        depositAndBorrow = abi.decode(
            vm.parseJson(json, "$.resupply.depositAndBorrow"),
            (bytes[])
        );
    }
}

contract DepositAndBorrowTest is ResupplyTest {
    function setUp() public {
        applyPermissionsOnRole(depositAndBorrow);
    }
}
