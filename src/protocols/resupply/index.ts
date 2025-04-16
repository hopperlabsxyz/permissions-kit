import { ChainId } from "zodiac-roles-sdk/."
import { allowErc20Approve } from "../../conditions"
import { Target, TargetInfo, Targets } from "./types";
import ethPools from "./_ethPools.ts"

function depositCrvUSD(_: ChainId, targetInfo: TargetInfo) {
  return [
    ...allowErc20Approve([targetInfo.depositAsset], [targetInfo.address]),
  ]
}

function getTargetInfo(target: Target): TargetInfo {
  if (typeof target === 'string') {
    const res = ethPools.find((t) => t.address === target);
    if (res === undefined) {
      throw new Error("Unknown target");
    }
    return res;
  }
  if (target.depositAsset === undefined) {
    throw new Error("Missing depositAsset");
  }
  return {
    name: 'Unknown',
    address: target.address,
    depositAsset: target.depositAsset
  }
}

export const eth = {
  depositAndBorrow: async ({ targets }: { targets: Targets }) => {
    return targets.flatMap((target) => depositCrvUSD(1, getTargetInfo(target)))
  },
}
