import { ChainId } from "zodiac-roles-sdk/."
import { allowErc20Approve } from "../../conditions"
import { Address } from "@gnosis-guild/eth-sdk"


const ethPools = [
  {
    name: "crvUSD_WETH",
    address: "0xCF1deb0570c2f7dEe8C07A7e5FA2bd4b2B96520D",
    depositAsset: "0xf939E0A03FB07F59A73314E73794Be0E57ac1b4E"
  }
] as const;

export type EthPool = typeof ethPools[number]

export type Target = EthPool['address'] | {
  address: EthPool['address'],
  depositAsset?: Address
}

export type Targets = Target[]

export interface TargetInfo {
  name: string;
  address: Address;
  depositAsset: Address;
}

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
