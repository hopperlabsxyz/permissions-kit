import { Address } from "@gnosis-guild/eth-sdk";

export type FromChainId = 1
export type ToChainId = 130


export interface CanonicalTarget {
  toChainIds: ToChainId[],
  bridgeAddresses?: Address[]
}
