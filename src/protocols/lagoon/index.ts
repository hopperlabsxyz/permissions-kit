import { allow } from "zodiac-roles-sdk/kit";
import { allowErc20Approve } from "../../conditions";
import { c, ChainId, Permission } from "zodiac-roles-sdk";
import { TargetInfo, EthTargets, AvaxTargets, Vaults, Target } from "./types";
import ethVaults from "./_ethVaults";
import avaxVaults from "./_avaxVaults";

function getTargetInfo(target: Target, vaults: Vaults): TargetInfo {
  if (typeof target === "string") {
    const res = vaults.find((t) => t.address === target);
    if (res === undefined) {
      throw new Error("Unknown target");
    }
    return res;
  } else if (typeof target.vault === "string") {
    const res = vaults.find((t) => t.address === target.vault);
    if (res === undefined) {
      throw new Error("Unknown target");
    }
    return {
      address: res.address,
      asset: res.asset,
      rates: target.rates,
      canClaimSharesOnBehalf: target.canClaimSharesOnBehalf,
      lifespan: target.lifespan,
    };
  }
  return {
    address: target.vault.address,
    asset: target.vault.asset,
    rates: target.rates,
    canClaimSharesOnBehalf: target.canClaimSharesOnBehalf,
    lifespan: target.lifespan,
  };
}

function settleVault(_: ChainId, targetInfo: TargetInfo) {
  return [
    ...allowErc20Approve([targetInfo.asset], [targetInfo.address]), // manage approval for redemption from safe to vault
    {
      ...allow.mainnet.lagoon.vault.settleDeposit(undefined),
      targetAddress: targetInfo.address,
    },
    {
      ...allow.mainnet.lagoon.vault.settleRedeem(undefined),
      targetAddress: targetInfo.address,
    },
  ];
}

function closeVault(_: ChainId, targetInfo: TargetInfo) {
  return [
    ...allowErc20Approve([targetInfo.asset], [targetInfo.address]), // manage approval for redemption from safe to vault
    {
      ...allow.mainnet.lagoon.vault.close(),
      targetAddress: targetInfo.address,
    },
    {
      ...allow.mainnet.lagoon.vault.initiateClosing(),
      targetAddress: targetInfo.address,
    },
  ];
}

function manageVault(chainId: ChainId, targetInfo: TargetInfo) {
  const permissions: Permission[] = [
    ...settleVault(chainId, targetInfo),
    ...closeVault(chainId, targetInfo),
  ];

  if (targetInfo.rates) {
    permissions.push({
      ...allow.mainnet.lagoon.vault.updateRates(
        c.matches({
          managementRate: targetInfo.rates.managementRate,
          performanceRate: targetInfo.rates.performanceRate,
        })
      ),
      targetAddress: targetInfo.address,
    });
  }
  if (targetInfo.canClaimSharesOnBehalf) {
    permissions.push({
      ...allow.mainnet.lagoon.vault.claimSharesOnBehalf(),
      targetAddress: targetInfo.address,
    });
  }

  if (targetInfo.lifespan) {
    permissions.push(
      //update Total Assets lifespan -> to enable sync vault
      {
        ...allow.mainnet.lagoon.vault.updateTotalAssetsLifespan(
          targetInfo.lifespan
        ),
        targetAddress: targetInfo.address,
      },
      // allow expire total assets (to deactivate sync vault mannually if needed )
      {
        ...allow.mainnet.lagoon.vault.expireTotalAssets(),
        targetAddress: targetInfo.address,
      }
    );
  }

  return permissions;
}

function depositAndWithdrawFromVault(_: ChainId, targetInfo: TargetInfo) {
  const { address: targetAddress } = targetInfo;
  return [
    ...allowErc20Approve([targetInfo.asset], [targetInfo.address]),
    {
      ...allow.mainnet.lagoon.vault["requestDeposit(uint256,address,address)"](
        undefined,
        c.avatar,
        c.avatar,
        { send: true }
      ),
      targetAddress,
    },
    {
      ...allow.mainnet.lagoon.vault.syncDeposit(
        undefined,
        c.avatar,
        undefined,
        { send: true }
      ),
      targetAddress,
    },
    {
      ...allow.mainnet.lagoon.vault[
        "requestDeposit(uint256,address,address,address)"
      ](undefined, c.avatar, c.avatar, undefined, { send: true }),
      targetAddress,
    },
    {
      ...allow.mainnet.lagoon.vault.requestRedeem(
        undefined,
        c.avatar,
        c.avatar
      ),
      targetAddress,
    },
    {
      ...allow.mainnet.lagoon.vault.claimSharesAndRequestRedeem(undefined),
      targetAddress,
    },
    {
      ...allow.mainnet.lagoon.vault["deposit(uint256,address)"](
        undefined,
        c.avatar
      ),
      targetAddress,
    },
    {
      ...allow.mainnet.lagoon.vault["deposit(uint256,address,address)"](
        undefined,
        c.avatar,
        c.avatar
      ),
      targetAddress,
    },
    {
      ...allow.mainnet.lagoon.vault["mint(uint256,address,address)"](
        undefined,
        c.avatar,
        c.avatar
      ),
      targetAddress,
    },
    {
      ...allow.mainnet.lagoon.vault["mint(uint256,address)"](
        undefined,
        c.avatar
      ),
      targetAddress,
    },
    {
      ...allow.mainnet.lagoon.vault.redeem(undefined, c.avatar, c.avatar),
      targetAddress,
    },
    {
      ...allow.mainnet.lagoon.vault.withdraw(undefined, c.avatar, c.avatar),
      targetAddress,
    },
  ];
}

export const eth = {
  manageVault: async ({ targets }: { targets: EthTargets }) => {
    return targets.flatMap((target) => manageVault(1, getTargetInfo(target, ethVaults)));
  },
  closeVault: async ({ targets }: { targets: EthTargets }) => {
    return targets.flatMap((target) => closeVault(1, getTargetInfo(target, ethVaults)));
  },
  settleVault: async ({ targets }: { targets: EthTargets }) => {
    return targets.flatMap((target) => settleVault(1, getTargetInfo(target, ethVaults)));
  },
  depositAndWithdrawFromVault: async ({ targets }: { targets: EthTargets }) => {
    return targets.flatMap((target) =>
      depositAndWithdrawFromVault(1, getTargetInfo(target, ethVaults))
    );
  },
};

export const avax = {
  manageVault: async ({ targets }: { targets: AvaxTargets }) => {
    return targets.flatMap((target) => manageVault(43114, getTargetInfo(target, avaxVaults)));
  },
  closeVault: async ({ targets }: { targets: AvaxTargets }) => {
    return targets.flatMap((target) => closeVault(43114, getTargetInfo(target, avaxVaults)));
  },
  settleVault: async ({ targets }: { targets: AvaxTargets }) => {
    return targets.flatMap((target) => settleVault(43114, getTargetInfo(target, avaxVaults)));
  },
  depositAndWithdrawFromVault: async ({ targets }: { targets: AvaxTargets }) => {
    return targets.flatMap((target) =>
      depositAndWithdrawFromVault(43114, getTargetInfo(target, avaxVaults))
    );
  },
};
