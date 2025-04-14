import { allow } from "zodiac-roles-sdk/kit"
import { allowErc20Approve } from "../../conditions";
import { c, ChainId, Permission } from "zodiac-roles-sdk";
import { Rates, Target, TargetInfo, Targets } from "./types";
import ethVaults from "./_ethVaults.ts"

function getTargetInfo(target: Target): TargetInfo {
  if (typeof target === 'string') {
    const res = ethVaults.find((t) => t.address === target);
    if (res === undefined) {
      throw new Error("Unknown target");
    }
    return res;
  }
  else if (typeof target.vault === 'string') {
    const res = ethVaults.find((t) => t.address === target.vault);
    if (res === undefined) {
      throw new Error("Unknown target");
    }
    return {
      address: res.address,
      asset: res.asset,
      rates: target.rates,
      canClaimSharesOnBehalf: target.canClaimSharesOnBehalf
    };
  }
  return {
    address: target.vault.address,
    asset: target.vault.asset,
    rates: target.rates,
    canClaimSharesOnBehalf: target.canClaimSharesOnBehalf
  };
}

function settleVault(
  _: ChainId,
  targetInfo: TargetInfo,
) {
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
  ]
}

function closeVault(
  _: ChainId,
  targetInfo: TargetInfo,
) {
  return [
    ...allowErc20Approve([targetInfo.asset], [targetInfo.address]), // manage approval for redemption from safe to vault
    {
      ...allow.mainnet.lagoon.vault.close(),
      targetAddress: targetInfo.address,
    },
    {
      ...allow.mainnet.lagoon.vault.initiateClosing(),
      targetAddress: targetInfo.address
    },
  ]
}

function manageVault(
  chainId: ChainId,
  targetInfo: TargetInfo,
) {
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
        }),
      ),
      targetAddress: targetInfo.address
    });
  }
  if (targetInfo.canClaimSharesOnBehalf) {
    permissions.push({
      ...allow.mainnet.lagoon.vault.claimSharesOnBehalf(),
      targetAddress: targetInfo.address
    });
  }
  return permissions;
}

export const eth = {
  manageVault: async ({ targets }: { targets: Targets }) => {
    return targets.flatMap((target) => manageVault(1, getTargetInfo(target)))
  },
  closeVault: async ({ targets }: { targets: Targets }) => {
    return targets.flatMap((target) => closeVault(1, getTargetInfo(target)))
  },
  settleVault: async ({ targets }: { targets: Targets }) => {
    return targets.flatMap((target) => settleVault(1, getTargetInfo(target)))
  },
}
