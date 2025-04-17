import { Address } from "@gnosis-guild/eth-sdk";
import _ethPools from "./_ethPools";

type EthPool = (typeof _ethPools)[number];

export interface TargetInfo {
  poolId: number;
  lpToken: Address;
}

export type Target = EthPool['poolId'] | TargetInfo;

export type Targets = Target[];
