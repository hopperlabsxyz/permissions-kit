// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.28;

import "@forge-std/Test.sol";
import "@forge-std/console.sol";
import {VmSafe} from "@forge-std/Vm.sol";
import {TestAvatar} from "@test/TestAvatar.sol";
import {IUsdc} from "@test/interfaces/IUsdc.sol";
import {IRoles} from "@test/interfaces/IRoles.sol";

address constant MODULE_PROXY_FACTORY = 0x000000000000aDdB49795b0f9bA5BC298cDda236;
address constant ROLE_MASTER_COPY = 0x9646fDAD06d3e24444381f44362a3B0eB343D337;
IUsdc constant USDC = IUsdc(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
address constant SPECTRA = 0x64FCC3A02eeEba05Ef701b7eed066c6ebD5d4E51;

interface IModuleProxyFactory {
    function deployModule(
        address masterCopy,
        bytes calldata initializer,
        uint256 salt
    ) external returns (address);
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
    bytes32 constant TEST_ROLE = "TEST-ROLE";

    TestAvatar public avatar;

    IRoles public role;

    IModuleProxyFactory public roleFactory =
        IModuleProxyFactory(MODULE_PROXY_FACTORY);

    VmSafe.Wallet public roleOwner = vm.createWallet("roleOwner");
    VmSafe.Wallet public manager = vm.createWallet("manager");

    constructor() {
        avatar = deployTestAvatar();
        role = deployRolesModifier(
            roleFactory,
            address(avatar),
            roleOwner.addr
        );

        bytes32[] memory roleKeys = new bytes32[](1);
        roleKeys[0] = TEST_ROLE;

        bool[] memory memberOf = new bool[](1);
        memberOf[0] = true;

        vm.prank(roleOwner.addr);
        role.assignRoles(manager.addr, roleKeys, memberOf);
    }
    function testParseRolesFromJson() public{
        string memory path = "test/data/permissions.json";
        string memory jsonRaw = vm.readFile(path);

        // Parse JSON array into `bytes[]`
        bytes[] memory txs = abi.decode(vm.parseJson(jsonRaw), (bytes[]));

        for (uint i = 0; i < txs.length; i++) {
            console.log("\ni: ", i);
            bytes memory txBytes = txs[i];

            //assign roles
            vm.prank(roleOwner.addr);
            address(role).call(txBytes);
        }
    }
}
