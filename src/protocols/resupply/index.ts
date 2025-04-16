import { c, ChainId } from "zodiac-roles-sdk";
import { allowErc20Approve } from "../../conditions";
import { Target, TargetInfo, Targets } from "./types";
import ethPools from "./_ethPools.ts";
import { allow } from "zodiac-roles-sdk/kit";

function getTargetInfo(target: Target): TargetInfo {
  if (typeof target === "string") {
    const res = ethPools.find((t) => t.address === target);
    if (res === undefined) {
      throw new Error("Unknown target");
    }
    return res;
  }
  if (target.collateralToken === undefined) {
    throw new Error("Missing collateralToken");
  }
  if (target.loanToken === undefined) {
    throw new Error("Missing loanToken");
  }
  return {
    name: "Unknown",
    address: target.address,
    collateralToken: target.collateralToken,
    loanToken: target.loanToken
  };
}

function depositCrvUSD(_: ChainId, targetInfo: TargetInfo) {
  return [
    ...allowErc20Approve([targetInfo.collateralToken], [targetInfo.address]),
    {
      ...allow.mainnet.resupply.pair.addCollateral(undefined, c.avatar),
      targetAddress: targetInfo.address,
    },
    {
      ...allow.mainnet.resupply.pair.removeCollateral(undefined, c.avatar),
      targetAddress: targetInfo.address,
    },
  ];
}

function borrow(_: ChainId, targetInfo: TargetInfo) {
  return [
    ...allowErc20Approve([targetInfo.loanToken], [targetInfo.address]),
    {
      ...allow.mainnet.resupply.pair.borrow(undefined, undefined, c.avatar),
      targetAddress: targetInfo.address,
    },
    {
      ...allow.mainnet.resupply.pair.repay(undefined, c.avatar),
      targetAddress: targetInfo.address,
    },
  ];
}


export const eth = {
  deposit: async ({ targets }: { targets: Targets }) => {
    return targets.flatMap((target) => depositCrvUSD(1, getTargetInfo(target)));
  },
  borrow: async ({ targets }: { targets: Targets }) => {
    return targets.flatMap((target) => borrow(1, getTargetInfo(target)));
  },
  depositAndBorrow: async ({ targets }: { targets: Targets }) => {
    return targets.flatMap((target) => [
      ...depositCrvUSD(1, getTargetInfo(target)),
      ...borrow(1, getTargetInfo(target))
    ]);
  },
};
