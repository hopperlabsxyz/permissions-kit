import { Address } from "@gnosis-guild/eth-sdk";
import ethVaults from "./_ethVaults.ts"

type EthVault = (typeof ethVaults)[number];
type EthTarget = EthVault['address']

export interface UnknownTarget {
  address: Address;
  asset: Address;
}

export type Target = EthTarget

export type Targets = (Target | UnknownTarget)[]