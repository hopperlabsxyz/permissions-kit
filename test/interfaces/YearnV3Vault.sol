// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

interface YearnV3Vault {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event DebtPurchased(address indexed strategy, uint256 amount);
    event DebtUpdated(
        address indexed strategy,
        uint256 current_debt,
        uint256 new_debt
    );
    event Deposit(
        address indexed sender,
        address indexed owner,
        uint256 assets,
        uint256 shares
    );
    event RoleSet(address indexed account, uint256 indexed role);
    event Shutdown();
    event StrategyChanged(
        address indexed strategy,
        uint256 indexed change_type
    );
    event StrategyReported(
        address indexed strategy,
        uint256 gain,
        uint256 loss,
        uint256 current_debt,
        uint256 protocol_fees,
        uint256 total_fees,
        uint256 total_refunds
    );
    event Transfer(
        address indexed sender,
        address indexed receiver,
        uint256 value
    );
    event UpdateAccountant(address indexed accountant);
    event UpdateAutoAllocate(bool auto_allocate);
    event UpdateDefaultQueue(address[] new_default_queue);
    event UpdateDepositLimit(uint256 deposit_limit);
    event UpdateDepositLimitModule(address indexed deposit_limit_module);
    event UpdateFutureRoleManager(address indexed future_role_manager);
    event UpdateMinimumTotalIdle(uint256 minimum_total_idle);
    event UpdateProfitMaxUnlockTime(uint256 profit_max_unlock_time);
    event UpdateRoleManager(address indexed role_manager);
    event UpdateUseDefaultQueue(bool use_default_queue);
    event UpdateWithdrawLimitModule(address indexed withdraw_limit_module);
    event UpdatedMaxDebtForStrategy(
        address indexed sender,
        address indexed strategy,
        uint256 new_debt
    );
    event Withdraw(
        address indexed sender,
        address indexed receiver,
        address indexed owner,
        uint256 assets,
        uint256 shares
    );

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function FACTORY() external view returns (address);

    function accept_role_manager() external;

    function accountant() external view returns (address);

    function add_role(address account, uint256 role) external;

    function add_strategy(address new_strategy) external;

    function add_strategy(address new_strategy, bool add_to_queue) external;

    function allowance(
        address arg0,
        address arg1
    ) external view returns (uint256);

    function apiVersion() external pure returns (string memory);

    function approve(address spender, uint256 amount) external returns (bool);

    function assess_share_of_unrealised_losses(
        address strategy,
        uint256 assets_needed
    ) external view returns (uint256);

    function asset() external view returns (address);

    function auto_allocate() external view returns (bool);

    function balanceOf(address addr) external view returns (uint256);

    function buy_debt(address strategy, uint256 amount) external;

    function convertToAssets(uint256 shares) external view returns (uint256);

    function convertToShares(uint256 assets) external view returns (uint256);

    function decimals() external view returns (uint8);

    function default_queue(uint256 arg0) external view returns (address);

    function deposit(
        uint256 assets,
        address receiver
    ) external returns (uint256);

    function deposit_limit() external view returns (uint256);

    function deposit_limit_module() external view returns (address);

    function force_revoke_strategy(address strategy) external;

    function fullProfitUnlockDate() external view returns (uint256);

    function future_role_manager() external view returns (address);

    function get_default_queue() external view returns (address[] memory);

    function initialize(
        address asset,
        string memory name,
        string memory symbol,
        address role_manager,
        uint256 profit_max_unlock_time
    ) external;

    function isShutdown() external view returns (bool);

    function lastProfitUpdate() external view returns (uint256);

    function maxDeposit(address receiver) external view returns (uint256);

    function maxMint(address receiver) external view returns (uint256);

    function maxRedeem(address owner) external view returns (uint256);

    function maxRedeem(
        address owner,
        uint256 max_loss
    ) external view returns (uint256);

    function maxRedeem(
        address owner,
        uint256 max_loss,
        address[] memory strategies
    ) external view returns (uint256);

    function maxWithdraw(address owner) external view returns (uint256);

    function maxWithdraw(
        address owner,
        uint256 max_loss
    ) external view returns (uint256);

    function maxWithdraw(
        address owner,
        uint256 max_loss,
        address[] memory strategies
    ) external view returns (uint256);

    function minimum_total_idle() external view returns (uint256);

    function mint(uint256 shares, address receiver) external returns (uint256);

    function name() external view returns (string memory);

    function nonces(address arg0) external view returns (uint256);

    function permit(
        address owner,
        address spender,
        uint256 amount,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (bool);

    function previewDeposit(uint256 assets) external view returns (uint256);

    function previewMint(uint256 shares) external view returns (uint256);

    function previewRedeem(uint256 shares) external view returns (uint256);

    function previewWithdraw(uint256 assets) external view returns (uint256);

    function pricePerShare() external view returns (uint256);

    function process_report(
        address strategy
    ) external returns (uint256, uint256);

    function profitMaxUnlockTime() external view returns (uint256);

    function profitUnlockingRate() external view returns (uint256);

    function redeem(
        uint256 shares,
        address receiver,
        address owner
    ) external returns (uint256);

    function redeem(
        uint256 shares,
        address receiver,
        address owner,
        uint256 max_loss
    ) external returns (uint256);

    function redeem(
        uint256 shares,
        address receiver,
        address owner,
        uint256 max_loss,
        address[] memory strategies
    ) external returns (uint256);

    function remove_role(address account, uint256 role) external;

    function revoke_strategy(address strategy) external;

    function role_manager() external view returns (address);

    function roles(address arg0) external view returns (uint256);

    function setName(string memory name) external;

    function setProfitMaxUnlockTime(
        uint256 new_profit_max_unlock_time
    ) external;

    function setSymbol(string memory symbol) external;

    function set_accountant(address new_accountant) external;

    function set_auto_allocate(bool auto_allocate) external;

    function set_default_queue(address[] memory new_default_queue) external;

    function set_deposit_limit(uint256 deposit_limit) external;

    function set_deposit_limit(uint256 deposit_limit, bool) external;

    function set_deposit_limit_module(address deposit_limit_module) external;

    function set_deposit_limit_module(
        address deposit_limit_module,
        bool
    ) external;

    function set_minimum_total_idle(uint256 minimum_total_idle) external;

    function set_role(address account, uint256 role) external;

    function set_use_default_queue(bool use_default_queue) external;

    function set_withdraw_limit_module(address withdraw_limit_module) external;

    function shutdown_vault() external;

    function strategies(
        address arg0
    ) external view returns (uint256, uint256, uint256, uint256);

    function symbol() external view returns (string memory);

    function totalAssets() external view returns (uint256);

    function totalDebt() external view returns (uint256);

    function totalIdle() external view returns (uint256);

    function totalSupply() external view returns (uint256);

    function transfer(address receiver, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address receiver,
        uint256 amount
    ) external returns (bool);

    function transfer_role_manager(address role_manager) external;

    function unlockedShares() external view returns (uint256);

    function update_debt(
        address strategy,
        uint256 target_debt
    ) external returns (uint256);

    function update_debt(
        address strategy,
        uint256 target_debt,
        uint256 max_loss
    ) external returns (uint256);

    function update_max_debt_for_strategy(
        address strategy,
        uint256 new_max_debt
    ) external;

    function use_default_queue() external view returns (bool);

    function withdraw(
        uint256 assets,
        address receiver,
        address owner
    ) external returns (uint256);

    function withdraw(
        uint256 assets,
        address receiver,
        address owner,
        uint256 max_loss
    ) external returns (uint256);

    function withdraw(
        uint256 assets,
        address receiver,
        address owner,
        uint256 max_loss,
        address[] memory strategies
    ) external returns (uint256);

    function withdraw_limit_module() external view returns (address);
}
