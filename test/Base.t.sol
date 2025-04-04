// SPDX-License-Identifier: BUSL-1.1
pragma solidity >= 0.8.28;

import "@forge-std/Test.sol";
import {TestAvatar} from "@test/TestAvatar.sol";
import {Roles} from "@rolesV2/Roles.sol";

address constant MODULE_PROXY_FACTORY = 0x000000000000aDdB49795b0f9bA5BC298cDda236;
interface IModuleProxyFactory {
    function deployModule(address, bytes, uint256) external returns (address);
}

contract BaseTest is Test {
    TestAvatar public avatar;
    Roles public role;

    constructor(){
        deployAvatar();
        deployRolesModifier();
        
    }

    function deployAvatar() internal {
        //instantiate the avatar
        avatar = new TestAvatar();
        //check the balance of the avatar
        assertEq(address(avatar).balance, 0);



    // function deployRolesModifier() internal {
    //     role = IModuleProxyFactory(MODULE_PROXY_FACTORY).deployModule(address(avatar), abi.encode(address(avatar)), 0);
    }
}
