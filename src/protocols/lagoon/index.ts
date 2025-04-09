import { allow } from "zodiac-roles-sdk/kit"
import { allowErc20Approve } from "../../conditions";
import { c, ChainId, Permission } from "zodiac-roles-sdk";
import { Rates, Target, Targets, UnknownTarget } from "./types";
import ethVaults from "./_ethVaults.ts"

function settleDeposit(
  _: ChainId,
  target: UnknownTarget,
) {
  return [
    ...allowErc20Approve([target.asset], [target.address]), // manage approval for redemption from safe to vault
    {
      ...allow.mainnet.lagoon.vault.settleDeposit(undefined),
      targetAddress: target.address,
    },
  ]
}

function settleRedeem(
  _: ChainId,
  target: UnknownTarget,
) {
  return [
    ...allowErc20Approve([target.asset], [target.address]), // manage approval for redemption from safe to vault
    {
      ...allow.mainnet.lagoon.vault.settleDeposit(undefined),
      targetAddress: target.address,
    },
  ]
}

function close(
  _: ChainId,
  target: UnknownTarget,
) {
  return [
    ...allowErc20Approve([target.asset], [target.address]), // manage approval for redemption from safe to vault
    {
      ...allow.mainnet.lagoon.vault.close(),
      targetAddress: target.address,
    },
  ]
}

function manage_vault(
  chainId: ChainId,
  target: UnknownTarget,
  rates: Rates | undefined = undefined,
) {
  const permissions: Permission[] = [
    ...settleDeposit(chainId, target),
    ...settleRedeem(chainId, target),
    ...close(chainId, target)
  ];
  if (rates) {
    permissions.push({
      ...allow.mainnet.lagoon.vault.updateRates(
        c.matches({
          managementRate: rates.managementRate,
          performanceRate: rates.performanceRate,
        }),
      ),
      targetAddress: target.address,
    });
  }
  return permissions;
}

function getTarget(target: Target | UnknownTarget) {
  if (typeof target == 'string') {
    const res = ethVaults.find((t) => t.address === target);
    if (res === undefined) {
      throw new Error("Unknown target");
    }
    return res;
  }
  return target;
}

export const eth = {
  manage_vault: async ({ targets }: { targets: Targets }) => {
    return targets.flatMap((target) => manage_vault(1, getTarget(target)))
  },
  close: async ({ targets }: { targets: Targets }) => {
    return targets.flatMap((target) => close(1, getTarget(target)))
  },
  settleDeposit: async ({ targets }: { targets: Targets }) => {
    return targets.flatMap((target) => settleDeposit(1, getTarget(target)))
  },
  settleRedeem: async ({ targets }: { targets: Targets }) => {
    return targets.flatMap((target) => settleRedeem(1, getTarget(target)))
  }
}
