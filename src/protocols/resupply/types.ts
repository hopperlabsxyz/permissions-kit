import { Address } from "@gnosis-guild/eth-sdk";
import ethPools from "./_ethPools.ts"

export type EthPool = typeof ethPools[number]

export type Target = EthPool['address'] | {
  address: EthPool['address'],
  collateralToken?: Address
  loanToken?: Address
}

export type Targets = Target[]

export interface TargetInfo {
  name: string;
  address: Address;
  collateralToken: Address;
  loanToken: Address;
}

