// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

library ILiquifier {
    struct PermitInput {
        uint256 value;
        uint256 deadline;
        uint8 v;
        bytes32 r;
        bytes32 s;
    }
}

interface DepositAdapter {
    type SourceOfFunds is uint8;

    event AdapterDeposit(address indexed sender, uint256 amount, SourceOfFunds source, address referral);
    event AdminChanged(address previousAdmin, address newAdmin);
    event BeaconUpgraded(address indexed beacon);
    event Initialized(uint8 version);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event Upgraded(address indexed implementation);

    receive() external payable;

    function depositETHForWeETH(
        address _referral
    ) external payable returns (uint256);

    function depositStETHForWeETHWithPermit(
        uint256 _amount,
        address _referral,
        ILiquifier.PermitInput memory _permit
    ) external returns (uint256);

    function depositWETHForWeETH(uint256 _amount, address _referral) external returns (uint256);

    function depositWstETHForWeETHWithPermit(
        uint256 _amount,
        address _referral,
        ILiquifier.PermitInput memory _permit
    ) external returns (uint256);

    function eETH() external view returns (address);

    function initialize() external;

    function liquidityPool() external view returns (address);

    function liquifier() external view returns (address);

    function owner() external view returns (address);

    function proxiableUUID() external view returns (bytes32);

    function renounceOwnership() external;

    function stETH() external view returns (address);

    function transferOwnership(
        address newOwner
    ) external;

    function upgradeTo(
        address newImplementation
    ) external;

    function upgradeToAndCall(address newImplementation, bytes memory data) external payable;

    function wETH() external view returns (address);

    function weETH() external view returns (address);

    function wstETH() external view returns (address);
}
