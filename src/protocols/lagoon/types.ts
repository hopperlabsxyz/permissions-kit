import { Address } from "@gnosis-guild/eth-sdk";
import { ConditionFunction } from "zodiac-roles-sdk/build/cjs/sdk/src/permissions/authoring/conditions/types";
import { BigNumberish } from "ethers";
import ethVaults from "./_ethVaults.ts"


type EthVault = (typeof ethVaults)[number];
type EthTarget = EthVault['address']

export interface UnknownTarget {
  address: Address;
  asset: Address;
}

export interface Rates {
  managementRate: ConditionFunction<BigNumberish>;
  performanceRate: ConditionFunction<BigNumberish>;
}

export type Target = EthTarget

export type Targets = (Target | UnknownTarget)[]
