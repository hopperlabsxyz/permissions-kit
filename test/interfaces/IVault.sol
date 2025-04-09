// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

library Roles {
    struct RolesStorage {
        address whitelistManager;
        address feeReceiver;
        address safe;
        address feeRegistry;
        address valuationManager;
    }
}

interface Vault {
    type State is uint8;

    struct InitStruct {
        address underlying;
        string name;
        string symbol;
        address safe;
        address whitelistManager;
        address valuationManager;
        address admin;
        address feeReceiver;
        address feeRegistry;
        address wrappedNativeToken;
        uint16 managementRate;
        uint16 performanceRate;
        bool enableWhitelist;
        uint256 rateUpdateCooldown;
    }

    struct Rates {
        uint16 managementRate;
        uint16 performanceRate;
    }

    error AboveMaxRate(uint256 maxRate);
    error AddressEmptyCode(address target);
    error AddressInsufficientBalance(address account);
    error CantDepositNativeToken();
    error Closed();
    error ERC20InsufficientAllowance(address spender, uint256 allowance, uint256 needed);
    error ERC20InsufficientBalance(address sender, uint256 balance, uint256 needed);
    error ERC20InvalidApprover(address approver);
    error ERC20InvalidReceiver(address receiver);
    error ERC20InvalidSender(address sender);
    error ERC20InvalidSpender(address spender);
    error ERC4626ExceededMaxDeposit(address receiver, uint256 assets, uint256 max);
    error ERC4626ExceededMaxMint(address receiver, uint256 shares, uint256 max);
    error ERC4626ExceededMaxRedeem(address owner, uint256 shares, uint256 max);
    error ERC4626ExceededMaxWithdraw(address owner, uint256 assets, uint256 max);
    error ERC7540InvalidOperator();
    error ERC7540PreviewDepositDisabled();
    error ERC7540PreviewMintDisabled();
    error ERC7540PreviewRedeemDisabled();
    error ERC7540PreviewWithdrawDisabled();
    error EnforcedPause();
    error ExpectedPause();
    error FailedInnerCall();
    error InvalidInitialization();
    error MathOverflowedMulDiv();
    error NewTotalAssetsMissing();
    error NotClosing(State currentState);
    error NotInitializing();
    error NotOpen(State currentState);
    error NotWhitelisted();
    error OnlyOneRequestAllowed();
    error OnlySafe(address safe);
    error OnlyValuationManager(address valuationManager);
    error OnlyWhitelistManager(address whitelistManager);
    error OwnableInvalidOwner(address owner);
    error OwnableUnauthorizedAccount(address account);
    error RequestIdNotClaimable();
    error RequestNotCancelable(uint256 requestId);
    error SafeERC20FailedOperation(address token);
    error WrongNewTotalAssets();

    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Deposit(address indexed sender, address indexed owner, uint256 assets, uint256 shares);
    event DepositRequest(
        address indexed controller, address indexed owner, uint256 indexed requestId, address sender, uint256 assets
    );
    event DepositRequestCanceled(uint256 indexed requestId, address indexed controller);
    event FeeReceiverUpdated(address oldReceiver, address newReceiver);
    event HighWaterMarkUpdated(uint256 oldHighWaterMark, uint256 newHighWaterMark);
    event Initialized(uint64 version);
    event NewTotalAssetsUpdated(uint256 totalAssets);
    event OperatorSet(address indexed controller, address indexed operator, bool approved);
    event OwnershipTransferStarted(address indexed previousOwner, address indexed newOwner);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event Paused(address account);
    event RatesUpdated(Rates oldRates, Rates newRate, uint256 timestamp);
    event RedeemRequest(
        address indexed controller, address indexed owner, uint256 indexed requestId, address sender, uint256 shares
    );
    event Referral(address indexed referral, address indexed owner, uint256 indexed requestId, uint256 assets);
    event SettleDeposit(
        uint40 indexed epochId,
        uint40 indexed settledId,
        uint256 totalAssets,
        uint256 totalSupply,
        uint256 assetsDeposited,
        uint256 sharesMinted
    );
    event SettleRedeem(
        uint40 indexed epochId,
        uint40 indexed settledId,
        uint256 totalAssets,
        uint256 totalSupply,
        uint256 assetsWithdrawed,
        uint256 sharesBurned
    );
    event StateUpdated(State state);
    event TotalAssetsUpdated(uint256 totalAssets);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Unpaused(address account);
    event ValuationManagerUpdated(address oldManager, address newManager);
    event WhitelistDisabled();
    event WhitelistManagerUpdated(address oldManager, address newManager);
    event WhitelistUpdated(address indexed account, bool authorized);
    event Withdraw(
        address indexed sender, address indexed receiver, address indexed owner, uint256 assets, uint256 shares
    );

    function MAX_MANAGEMENT_RATE() external view returns (uint16);
    function MAX_PERFORMANCE_RATE() external view returns (uint16);
    function MAX_PROTOCOL_RATE() external view returns (uint16);
    function acceptOwnership() external;
    function addToWhitelist(address[] memory accounts) external;
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 value) external returns (bool);
    function asset() external view returns (address);
    function balanceOf(address account) external view returns (uint256);
    function cancelRequestDeposit() external;
    function claimSharesAndRequestRedeem(uint256 sharesToRedeem) external returns (uint40 requestId);
    function claimableDepositRequest(uint256 requestId, address controller) external view returns (uint256 assets);
    function claimableRedeemRequest(uint256 requestId, address controller) external view returns (uint256 shares);
    function close(uint256 _newTotalAssets) external;
    function convertToAssets(uint256 shares) external view returns (uint256);
    function convertToAssets(uint256 shares, uint256 requestId) external view returns (uint256);
    function convertToShares(uint256 assets) external view returns (uint256);
    function convertToShares(uint256 assets, uint256 requestId) external view returns (uint256);
    function decimals() external view returns (uint8);
    function deposit(uint256 assets, address receiver, address controller) external returns (uint256);
    function deposit(uint256 assets, address receiver) external returns (uint256);
    function disableWhitelist() external;
    function feeRates() external view returns (Rates memory);
    function getRolesStorage() external pure returns (Roles.RolesStorage memory _rolesStorage);
    function highWaterMark() external view returns (uint256);
    function initialize(InitStruct memory init) external;
    function initiateClosing() external;
    function isOperator(address controller, address operator) external view returns (bool);
    function isWhitelistActivated() external view returns (bool);
    function isWhitelisted(address account) external view returns (bool);
    function lastDepositRequestId(address controller) external view returns (uint40);
    function lastFeeTime() external view returns (uint256);
    function lastRedeemRequestId(address controller) external view returns (uint40);
    function maxDeposit(address controller) external view returns (uint256);
    function maxMint(address controller) external view returns (uint256);
    function maxRedeem(address controller) external view returns (uint256);
    function maxWithdraw(address controller) external view returns (uint256);
    function mint(uint256 shares, address receiver) external returns (uint256);
    function mint(uint256 shares, address receiver, address controller) external returns (uint256);
    function name() external view returns (string memory);
    function owner() external view returns (address);
    function pause() external;
    function paused() external view returns (bool);
    function pendingDepositRequest(uint256 requestId, address controller) external view returns (uint256 assets);
    function pendingOwner() external view returns (address);
    function pendingRedeemRequest(uint256 requestId, address controller) external view returns (uint256 shares);
    function pendingSilo() external view returns (address);
    function previewDeposit(uint256) external pure returns (uint256);
    function previewMint(uint256) external pure returns (uint256);
    function previewRedeem(uint256) external pure returns (uint256);
    function previewWithdraw(uint256) external pure returns (uint256);
    function redeem(uint256 shares, address receiver, address controller) external returns (uint256 assets);
    function renounceOwnership() external;
    function requestDeposit(uint256 assets, address controller, address owner)
        external
        payable
        returns (uint256 requestId);
    function requestDeposit(uint256 assets, address controller, address owner, address referral)
        external
        payable
        returns (uint256 requestId);
    function requestRedeem(uint256 shares, address controller, address owner) external returns (uint256 requestId);
    function revokeFromWhitelist(address[] memory accounts) external;
    function setOperator(address operator, bool approved) external returns (bool success);
    function settleDeposit(uint256 _newTotalAssets) external;
    function settleRedeem(uint256 _newTotalAssets) external;
    function share() external view returns (address);
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
    function symbol() external view returns (string memory);
    function totalAssets() external view returns (uint256);
    function totalSupply() external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function transferOwnership(address newOwner) external;
    function unpause() external;
    function updateFeeReceiver(address _feeReceiver) external;
    function updateNewTotalAssets(uint256 _newTotalAssets) external;
    function updateRates(Rates memory newRates) external;
    function updateValuationManager(address _valuationManager) external;
    function updateWhitelistManager(address _whitelistManager) external;
    function withdraw(uint256 assets, address receiver, address controller) external returns (uint256 shares);
}
