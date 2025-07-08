// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.28;

import "@forge-std/Test.sol";
import {BaseTest, IUsdc} from "@test/Base.t.sol";
import {TestAvatar} from "@test/TestAvatar.sol";
import {IResupplyPair} from "@test/interfaces/IResupplyPair.sol";
import {CurveStableSwapNG} from "@test/interfaces/IStableSwapNg.sol";
import {Vault} from "@test/interfaces/IVault.sol";
import {YearnV3Vault} from "@test/interfaces/YearnV3Vault.sol";

address constant CRVUSD = 0xf939E0A03FB07F59A73314E73794Be0E57ac1b4E;
address constant SCRVUSD = 0x0655977FEb2f289A4aB78af67BAB0d17aAb84367;

address constant reUSDsCRV = 0xc522A6606BBA746d7960404F22a3DB936B6F4F50;

contract CurveTest is BaseTest(1) {
    address constant POOL = 0xc73B0328Bd40Ea35Aad34d0fDC1dBE64C4f9c59F;
    address constant GAUGE = 0x92219862F9F40fe27444e45a9554E824e8556A62;

    bytes[] stakeCrvUSD;
    bytes[] depositStableSwapNg;

    constructor() {
        stakeCrvUSD = loadPermissions("$.curve.stakeCrvUSD");
        depositStableSwapNg = loadPermissions("$.curve.depositStableSwapNg");
    }
}

contract DepositStableSwapNg is CurveTest {
    function setUp() public {
        applyPermissionsOnRole(depositStableSwapNg);
    }

    function test_approve() public {
        bytes memory call = abi.encodeWithSelector(
            IUsdc(SCRVUSD).approve.selector,
            reUSDsCRV,
            42
        );
        vm.prank(manager);
        role.execTransactionWithRole(SCRVUSD, 0, call, 0, TEST_ROLE, false);
    }

    function test_approve_on_gauge() public {
        bytes memory call = abi.encodeWithSelector(
            IUsdc(address(0)).approve.selector,
            GAUGE,
            42
        );
        console.log("gauge", GAUGE);
        console.log("pool", POOL);
        vm.prank(manager);
        role.execTransactionWithRole(POOL, 0, call, 0, TEST_ROLE, false);
    }

    function test_add_liquidity() public {
        uint256[] memory arr;
        bytes memory call = abi.encodeWithSignature(
            "add_liquidity(uint256[],uint256,address)",
            arr,
            42,
            avatar
        );
        vm.prank(manager);
        role.execTransactionWithRole(reUSDsCRV, 0, call, 0, TEST_ROLE, false);

        call = abi.encodeWithSignature(
            "add_liquidity(uint256[],uint256)",
            arr,
            42
        );
        vm.prank(manager);
        role.execTransactionWithRole(reUSDsCRV, 0, call, 0, TEST_ROLE, false);
    }

    // function test_add_liquidity_revert() public {
    //     uint256[] memory arr;
    //     bytes memory call = abi.encodeWithSignature(
    //         "add_liquidity(uint256[],uint256,address)",
    //         arr,
    //         42,
    //         address(0xdead)
    //     );
    //     vm.prank(manager);
    //     vm.expectRevert();
    //     role.execTransactionWithRole(reUSDsCRV, 0, call, 0, TEST_ROLE, false);
    // }

    function test_add_liquidity_revert() public {
        uint256[] memory arr;
        bytes memory call = abi.encodeWithSignature(
            "add_liquidity(uint256[],uint256,address)",
            arr,
            42,
            address(0xdead)
        );
        vm.prank(manager);
        vm.expectRevert();
        role.execTransactionWithRole(reUSDsCRV, 0, call, 0, TEST_ROLE, false);
    }

    function test_remove_liquidity() public {
        uint256[] memory arr;
        bytes memory call = abi.encodeWithSignature(
            "remove_liquidity(uint256,uint256[],address,bool)",
            42,
            arr,
            avatar,
            true
        );
        vm.prank(manager);
        role.execTransactionWithRole(reUSDsCRV, 0, call, 0, TEST_ROLE, false);

        call = abi.encodeWithSignature(
            "remove_liquidity(uint256,uint256[],address)",
            42,
            arr,
            avatar
        );
        vm.prank(manager);
        role.execTransactionWithRole(reUSDsCRV, 0, call, 0, TEST_ROLE, false);

        call = abi.encodeWithSignature(
            "remove_liquidity(uint256,uint256[])",
            42,
            arr
        );
        vm.prank(manager);
        role.execTransactionWithRole(reUSDsCRV, 0, call, 0, TEST_ROLE, false);
    }

    function test_remove_liquidity_one_coin() public {
        uint256[] memory arr;
        bytes memory call = abi.encodeWithSignature(
            "remove_liquidity_one_coin(uint256,int128,uint256)",
            42,
            42,
            42
        );
        vm.prank(manager);
        role.execTransactionWithRole(reUSDsCRV, 0, call, 0, TEST_ROLE, false);

        call = abi.encodeWithSignature(
            "remove_liquidity_one_coin(uint256,int128,uint256,address)",
            42,
            42,
            42,
            avatar
        );
        vm.prank(manager);
        role.execTransactionWithRole(reUSDsCRV, 0, call, 0, TEST_ROLE, false);
    }

    function test_remove_liquidity_revert() public {
        uint256[] memory arr;
        bytes memory call = abi.encodeWithSignature(
            "remove_liquidity(uint256,uint256[],address,bool)",
            42,
            arr,
            address(0xdead),
            true
        );
        vm.prank(manager);
        vm.expectRevert();
        role.execTransactionWithRole(reUSDsCRV, 0, call, 0, TEST_ROLE, false);

        call = abi.encodeWithSignature(
            "remove_liquidity(uint256,uint256[],address)",
            42,
            arr,
            address(0xdead)
        );
        vm.prank(manager);
        vm.expectRevert();
        role.execTransactionWithRole(reUSDsCRV, 0, call, 0, TEST_ROLE, false);
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

    function test_deposit_revert() public {
        bytes memory call = abi.encodeWithSelector(
            YearnV3Vault(SCRVUSD).deposit.selector,
            42,
            address(0xdead)
        );
        vm.prank(manager);
        vm.expectRevert();
        role.execTransactionWithRole(SCRVUSD, 0, call, 0, TEST_ROLE, false);
    }

    function test_redeem() public {
        bytes memory call = abi.encodeWithSignature(
            "redeem(uint256,address,address)",
            42,
            avatar,
            avatar
        );
        vm.prank(manager);
        role.execTransactionWithRole(SCRVUSD, 0, call, 0, TEST_ROLE, false);

        call = abi.encodeWithSignature(
            "redeem(uint256,address,address,uint256)",
            42,
            avatar,
            avatar,
            42
        );
        vm.prank(manager);
        role.execTransactionWithRole(SCRVUSD, 0, call, 0, TEST_ROLE, false);

        address[] memory addr;
        call = abi.encodeWithSignature(
            "redeem(uint256,address,address,uint256,address[])",
            42,
            avatar,
            avatar,
            42,
            addr
        );
        vm.prank(manager);
        role.execTransactionWithRole(SCRVUSD, 0, call, 0, TEST_ROLE, false);
    }

    function test_redeem_revert() public {
        bytes memory call = abi.encodeWithSignature(
            "redeem(uint256,address,address)",
            42,
            address(0xdead),
            address(0xdead)
        );
        vm.prank(manager);
        vm.expectRevert();
        role.execTransactionWithRole(SCRVUSD, 0, call, 0, TEST_ROLE, false);

        call = abi.encodeWithSignature(
            "redeem(uint256,address,address,uint256)",
            42,
            address(0xdead),
            address(0xdead),
            42
        );
        vm.prank(manager);
        vm.expectRevert();
        role.execTransactionWithRole(SCRVUSD, 0, call, 0, TEST_ROLE, false);

        address[] memory addr;
        call = abi.encodeWithSignature(
            "redeem(uint256,address,address,uint256,address[])",
            42,
            address(0xdead),
            address(0xdead),
            42,
            addr
        );
        vm.prank(manager);
        vm.expectRevert();
        role.execTransactionWithRole(SCRVUSD, 0, call, 0, TEST_ROLE, false);
    }
}
