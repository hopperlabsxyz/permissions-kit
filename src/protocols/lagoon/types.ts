import { Address } from "@gnosis-guild/eth-sdk";
import { ConditionFunction } from "zodiac-roles-sdk/build/cjs/sdk/src/permissions/authoring/conditions/types";
import { BigNumberish } from "ethers";
import ethVaults from "./_ethVaults.ts"
import avaxVaults from "./_avaxVaults.ts"


type EthVault = (typeof ethVaults)[number];
type AvaxVault = (typeof avaxVaults)[number];


export interface TargetInfo {
  address: Address
  asset: Address;
  rates?: Rates;
  canClaimSharesOnBehalf?: boolean;
  lifespan?: ConditionFunction<BigNumberish>; // allow the asset manager to put the vault in sync mode
}

export interface Rates {
  managementRate: ConditionFunction<BigNumberish>;
  performanceRate: ConditionFunction<BigNumberish>;
}

export interface UnknownVault {
  address: Address;
  asset: Address
}

export type EthTarget = EthVault['address'] | {
  vault: EthVault['address'] | UnknownVault,
  rates?: Rates;
  canClaimSharesOnBehalf?: boolean;
  lifespan?: ConditionFunction<BigNumberish>; // allow the asset manager to put the vault in sync mode
}

export type AvaxTarget = AvaxVault['address'] | {
  vault: AvaxVault['address'] | UnknownVault,
  rates?: Rates;
  canClaimSharesOnBehalf?: boolean;
  lifespan?: ConditionFunction<BigNumberish>; // allow the asset manager to put the vault in sync mode
}

export type Target = EthTarget | AvaxTarget
export type EthTargets = EthTarget[]
export type AvaxTargets = AvaxTarget[]
export type Vaults = readonly EthVault[] | readonly AvaxVault[]
