// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.28;

import "@forge-std/Test.sol";
import "@forge-std/console.sol";
import {VmSafe} from "@forge-std/Vm.sol";
import {TestAvatar} from "@test/TestAvatar.sol";
import {IRoles} from "@test/interfaces/IRoles.sol";

interface IModuleProxyFactory {
    function deployModule(
        address masterCopy,
        bytes calldata initializer,
        uint256 salt
    ) external returns (address);
}

contract ZodiacHelpers is Test {

    constructor(uint256 chainId) {
    }

    address constant MODULE_PROXY_FACTORY =
        0x000000000000aDdB49795b0f9bA5BC298cDda236;

    address constant ROLE_MASTER_COPY =
        0x9646fDAD06d3e24444381f44362a3B0eB343D337;

    bytes32 constant TEST_ROLE = "TEST-ROLE";

    address public avatar;

    IRoles public role;

    IModuleProxyFactory public roleFactory =
        IModuleProxyFactory(MODULE_PROXY_FACTORY);

    address public roleOwner = vm.createWallet("roleOwner").addr;
    address public manager = vm.createWallet("manager").addr;

    function applyPermissionsOnRole(
        bytes[] memory _permissions,
        address _role,
        address _owner
    ) internal {
        for (uint i = 0; i < _permissions.length; i++) {
            bytes memory txBytes = _permissions[i];

            //assign roles
            vm.prank(_owner);
            (bool success, ) = _role.call(txBytes);
            require(success, "call failed");
        }
    }

    function applyPermissionsOnRole(bytes[] memory _permissions) internal {
        for (uint i = 0; i < _permissions.length; i++) {
            bytes memory txBytes = _permissions[i];

            //assign roles
            vm.prank(roleOwner);
            (bool success, ) = address(role).call(txBytes);
            require(success, "call failed");
        }
    }

    function deployTestAvatar() internal returns (address) {
        return address(new TestAvatar());
    }

    function parsePermissions(
        string memory path
    ) internal view returns (bytes[] memory) {
        string memory jsonRaw = vm.readFile(path);

        // Parse JSON array into `bytes[]`
        return abi.decode(vm.parseJson(jsonRaw), (bytes[]));
    }

    function deployRolesModifier(
        IModuleProxyFactory _factory,
        address _avatar,
        address _owner
    ) internal returns (IRoles) {
        bytes memory initParams = abi.encodeWithSelector(
            IRoles.setUp.selector,
            abi.encode(_owner, _avatar, avatar)
        );
        return IRoles(_factory.deployModule(ROLE_MASTER_COPY, initParams, 0));
    }
}
