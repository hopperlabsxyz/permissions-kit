import { Address } from "@gnosis-guild/eth-sdk";
import { ConditionFunction } from "zodiac-roles-sdk/build/cjs/sdk/src/permissions/authoring/conditions/types";
import { BigNumberish } from "ethers";
import ethVaults from "./_ethVaults.ts"


type EthVault = (typeof ethVaults)[number];

export interface TargetInfo {
  address: Address
  asset: Address;
  rates?: Rates;
  canClaimSharesOnBehalf?: boolean;
}

export interface Rates {
  managementRate: ConditionFunction<BigNumberish>;
  performanceRate: ConditionFunction<BigNumberish>;
}

export interface UnknownVault {
  address: Address;
  asset: Address
}

export type Target = EthVault['address'] | {
  vault: EthVault['address'] | UnknownVault,
  rates?: Rates;
  canClaimSharesOnBehalf?: boolean;
}

export type Targets = Target[]
