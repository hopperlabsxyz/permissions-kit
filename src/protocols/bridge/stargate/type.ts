import { Address } from "@gnosis-guild/eth-sdk";

export const chainIdToEndpointId = {
  1: 30101, // mainnet
  10: 30111, // optimism
  100: 30145, // gnosis
  137: 30109, // polygon
  42161: 30110, // arbitrum
  43114: 30106, // avalance
  56: 30102, // bnb
  8453: 30184, // base
  146: 30332, // sonic
  130: 30320 // unichain
} as const;

export const oftAdapters = {
  1: {
    ['0x66a1e37c9b0eaddca17d3662d6c05f4decf3e110']: "0xd2ee2776f34ef4e7325745b06e6d464b08d4be0e", // usr
    ['0xa1290d69c65a6fe4df752f95823fae25cb99e5a7']: "0x85d456b2dff1fd8245387c0bfb64dfb700e98ef3", // rseth
    ['0xcd5fe23c85820f7b72d0926fc9b05b43e359b7ee']: "0xcd2eb13d6831d4602d80e5db9230a57596cdca63" // weeeth
  },
  8453: {
    // [simpleOftAdapter]: "0x35E5dB674D8e93a03d814FA0ADa70731efe8a4b9"
    ['0x35E5dB674D8e93a03d814FA0ADa70731efe8a4b9']: "0x1a44076050125825900e736c501f859c50fE728c", // usr
  }
} as const;

export type SupportedChainId = keyof typeof chainIdToEndpointId

export interface StargateTarget {
  tokenAddress: Address;
  toChainIds: SupportedChainId[];
  oftAdapter?: Address,
  customEndpointIds?: number[]
}
