// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.28;

import "@forge-std/Test.sol";

import {VmSafe} from "@forge-std/Vm.sol";
import "@forge-std/console.sol";
import {TestAvatar} from "@test/TestAvatar.sol";

import {ZodiacHelpers} from "@test/ZodiacHelpers.t.sol";
import {IRoles} from "@test/interfaces/IRoles.sol";
import {ISimpleOFTAdapter} from "@test/interfaces/ISimpleOFTAdapter.sol";
import {IUsdc} from "@test/interfaces/IUsdc.sol";

contract BaseTest is ZodiacHelpers {
    constructor(
        uint256 chainId
    ) ZodiacHelpers(chainId) {
        string memory key = vm.envString("ALCHEMY_API_KEY");
        string memory url;

        if (chainId == 1) {
            url = string.concat("https://eth-mainnet.g.alchemy.com/v2/", key);
        } else if (chainId == 8453) {
            url = string.concat("https://base-mainnet.g.alchemy.com/v2/", key);
        }
        vm.createSelectFork(url);

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
    }
}
