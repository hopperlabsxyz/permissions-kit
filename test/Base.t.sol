// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.28;

import "@forge-std/Test.sol";
import "@forge-std/console.sol";
import {VmSafe} from "@forge-std/Vm.sol";
import {TestAvatar} from "@test/TestAvatar.sol";

address constant MODULE_PROXY_FACTORY = 0x000000000000aDdB49795b0f9bA5BC298cDda236;
address constant ROLE_MASTER_COPY = 0x9646fDAD06d3e24444381f44362a3B0eB343D337;

interface IModuleProxyFactory {
    function deployModule(
        address masterCopy,
        bytes calldata initializer,
        uint256 salt
    ) external returns (address);
}

interface IRoles {
    function setUp(bytes memory initParams) external;

    function avatar() external returns (address);
}

function deployRolesModifier(
    IModuleProxyFactory factory,
    address avatar,
    address owner
) returns (IRoles) {
    bytes memory initParams = abi.encodeWithSelector(
        IRoles.setUp.selector,
        abi.encode(owner, address(avatar), address(avatar))
    );
    IRoles role = IRoles(factory.deployModule(ROLE_MASTER_COPY, initParams, 0));
    return role;
}

function deployTestAvatar() returns (TestAvatar) {
    return new TestAvatar();
}

contract BaseTest is Test {
    TestAvatar public avatar;

    IRoles public role;

    IModuleProxyFactory public roleFactory =
        IModuleProxyFactory(MODULE_PROXY_FACTORY);

    VmSafe.Wallet public roleOwner = vm.createWallet("roleOwner");
    VmSafe.Wallet public roleMember = vm.createWallet("roleMember");

    constructor() {
        avatar = deployTestAvatar();
        role = deployRolesModifier(
            roleFactory,
            address(avatar),
            roleOwner.addr
        );
        assertEq(role.avatar(), address(avatar), "role setup failed");
    }
}
