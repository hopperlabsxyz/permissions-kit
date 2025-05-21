import { allow } from "zodiac-roles-sdk/kit"
import { allowErc20Approve } from "../../conditions"
import { c, ChainId } from "zodiac-roles-sdk"
import { TargetInfo, Target, Targets } from "./types"
import _ethPools from "./_ethPools"

export const CRVUSD = "0xf939E0A03FB07F59A73314E73794Be0E57ac1b4E"
export const SCRVUSD = "0x0655977FEb2f289A4aB78af67BAB0d17aAb84367"

function depositStableSwapNg(_: ChainId, targetInfo: TargetInfo) {
  const { token0, token1, address: targetAddress, gauge } = targetInfo;
  let permissions = [
    ...allowErc20Approve([token0, token1], [targetAddress]),
    {
      ...allow.mainnet.curve.stableSwapNg["add_liquidity(uint256[],uint256,address)"](undefined, undefined, c.avatar),
      targetAddress
    },
    {
      ...allow.mainnet.curve.stableSwapNg["add_liquidity(uint256[],uint256)"](undefined, undefined),
      targetAddress
    },
    {
      ...allow.mainnet.curve.stableSwapNg["remove_liquidity(uint256,uint256[],address,bool)"](undefined, undefined, c.avatar, undefined),
      targetAddress
    },
    {
      ...allow.mainnet.curve.stableSwapNg["remove_liquidity(uint256,uint256[],address)"](undefined, undefined, c.avatar),
      targetAddress
    },
    {
      ...allow.mainnet.curve.stableSwapNg["remove_liquidity(uint256,uint256[])"](undefined, undefined),
      targetAddress
    }
  ]
  if (gauge) {
    permissions.push(
      ...allowErc20Approve([targetAddress], [gauge]),
      {
        ...allow.mainnet.curve.gauge["deposit(uint256)"](undefined),
        targetAddress: gauge
      },
      {
        ...allow.mainnet.curve.gauge["withdraw(uint256)"](undefined),
        targetAddress: gauge
      },
      {
        ...allow.mainnet.curve.gauge["withdraw(uint256,bool)"](undefined, undefined),
        targetAddress: gauge
      },
      {
        ...allow.mainnet.curve.gauge["claim_rewards()"](),
        targetAddress: gauge
      },
      {
        ...allow.mainnet.curve.gauge["claim_rewards(address)"](),
        targetAddress: gauge
      },
      {
        ...allow.mainnet.curve.gauge["claim_rewards(address,address)"](c.avatar),
        targetAddress: gauge
      },
    )
  }
  return permissions
}

function getTargetInfo(target: Target): TargetInfo {
  if (typeof target === 'string') {
    const targetInfo = _ethPools.find((t) => t.address.toLowerCase() === target.toLowerCase());
    if (targetInfo === undefined) {
      throw new Error("Unknow target");
    }
    return targetInfo;
  }
  return target
}

export const eth = {
  stakeCrvUSD: async () => {
    return [
      ...allowErc20Approve([CRVUSD], [SCRVUSD]),
      allow.mainnet.curve.scrvUSD.deposit(undefined, c.avatar),
      allow.mainnet.curve.scrvUSD["redeem(uint256,address,address)"](undefined, c.avatar, c.avatar),
      allow.mainnet.curve.scrvUSD["redeem(uint256,address,address,uint256)"](undefined, c.avatar, c.avatar, undefined),
      allow.mainnet.curve.scrvUSD["redeem(uint256,address,address,uint256,address[])"](undefined, c.avatar, c.avatar, undefined, undefined)
    ]
  },
  depositStableSwapNg: async ({ targets }: { targets: Targets }) => {
    return targets.flatMap((target) => ([
      ...depositStableSwapNg(1, getTargetInfo(target))
    ]))
  }
}
