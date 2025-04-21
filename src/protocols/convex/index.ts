import { c, ChainId } from "zodiac-roles-sdk"
import { allowErc20Approve } from "../../conditions"
import { Target, TargetInfo, Targets } from "./types.ts"
import _ethPools from "./_ethPools.ts"
import { allow } from "zodiac-roles-sdk/kit"


const BOOSTER = "0xf403c135812408bfbe8713b5a23a04b3d48aae31"


function deposit(_: ChainId, targetInfo: TargetInfo) {
  return [
    ...allowErc20Approve([targetInfo.lpToken], [BOOSTER]),
    allow.mainnet.convex.booster.depositAll(targetInfo.poolId, undefined),
    allow.mainnet.convex.booster.deposit(targetInfo.poolId, undefined, undefined),
  ]
}

function withdraw(_: ChainId, targetInfo: TargetInfo) {
  return [
    ...allowErc20Approve([targetInfo.lpToken], [BOOSTER]),
    allow.mainnet.convex.booster.withdrawAll(targetInfo.poolId),
    allow.mainnet.convex.booster.withdrawTo(targetInfo.poolId, undefined, c.avatar),
    allow.mainnet.convex.booster.withdraw(targetInfo.poolId, undefined),
    // TODO: start test those
    allow.mainnet.convex.baseRewardPool["getReward(address,bool)"](c.avatar, undefined),
    allow.mainnet.convex.baseRewardPool["getReward()"](),
    allow.mainnet.convex.baseRewardPool.withdraw(undefined, undefined),
    allow.mainnet.convex.baseRewardPool.withdrawAllAndUnwrap(undefined),
    allow.mainnet.convex.baseRewardPool.withdrawAll(undefined),
    allow.mainnet.convex.baseRewardPool.withdrawAndUnwrap(undefined, undefined),
    // TODO: end
  ]
}

function getTargetInfo(target: Target): TargetInfo {
  if (typeof target === 'number') {
    const targetInfo = _ethPools.find((t) => t.poolId === target);
    if (targetInfo === undefined) {
      throw new Error("Unknow target");
    }
    return targetInfo;
  }
  return target;
}

export const eth = {
  deposit: async ({ targets }: { targets: Targets }) => {
    return targets.flatMap((target) => {
      const info = getTargetInfo(target)
      return ([
        ...deposit(1, info),
        ...withdraw(1, info),
      ])
    })
  }
}
