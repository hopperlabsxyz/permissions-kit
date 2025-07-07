import { kit as ethkit } from "../../dist/eth";
import { kit as basekit } from "../../dist/base";
import { c } from "zodiac-roles-sdk";
import { PermissionsByChain } from "./applyUpdates";

export const SUPPORTED_CHAINS = [1, 8453] as const;

export const CONFIG = {
  MANAGER: "0xA5d55E7A556fbA22974479497E6bf7e097D81b5e",
  TEST_ROLE: "0x544553542d524f4c450000000000000000000000000000000000000000000000",
  AVATAR: "0x5615dEB798BB3E4dFa0139dFa1b3D433Cc23b72f",
  ROLES_ADDRESS: "0xc128B1307128e8A692c98DD48cd7Ff155521A093",
} as const;

// Tested permission definitions
export async function createPermissions(): Promise<PermissionsByChain> {
  return {
    [1]: {
      lagoon: {
        manageVault: await ethkit.lagoon.manageVault({
          targets: [{
            vault: '0x07ed467acd4ffd13023046968b0859781cb90d9b',
            rates: { managementRate: c.eq(42), performanceRate: c.eq(42) },
            canClaimSharesOnBehalf: true,
            lifespan: c.lt(86400)
          }]
        }),
        settleVault: await ethkit.lagoon.settleVault({
          targets: ['0x07ed467acd4ffd13023046968b0859781cb90d9b']
        }),
        closeVault: await ethkit.lagoon.closeVault({
          targets: ['0x07ed467acd4ffd13023046968b0859781cb90d9b']
        }),
        depositAndWithdrawFromVault: await ethkit.lagoon.depositAndWithdrawFromVault({
          targets: ['0x07ed467acd4ffd13023046968b0859781cb90d9b']
        })
      },
      resupply: {
        deposit: await ethkit.resupply.deposit({
          targets: ["0xCF1deb0570c2f7dEe8C07A7e5FA2bd4b2B96520D"],
        }),
        borrow: await ethkit.resupply.borrow({
          targets: ["0xCF1deb0570c2f7dEe8C07A7e5FA2bd4b2B96520D"],
        }),
        depositAndBorrow: await ethkit.resupply.depositAndBorrow({
          targets: ["0xCF1deb0570c2f7dEe8C07A7e5FA2bd4b2B96520D"],
        }),
      },
      curve: {
        stakeCrvUSD: await ethkit.curve.stakeCrvUSD(),
        depositStableSwapNg: await ethkit.curve.depositStableSwapNg({
          targets: ["0xc522a6606bba746d7960404f22a3db936b6f4f50", "0xc73B0328Bd40Ea35Aad34d0fDC1dBE64C4f9c59F"],
        }),
      },
      convex: {
        deposit: await ethkit.convex.deposit({ targets: [440] }),
      },
      lido: {
        deposit: await ethkit.lido.deposit(),
      },
      etherfi: {
        deposit: await ethkit.etherfi.deposit({ targets: ['ETH', 'WETH'] })
      },
      se7enseas: {
        depositBoringVault: await ethkit.se7enseas.depositBoringVault({
          targets: [{
            vault: {
              boringVault: '0x294eecec65A0142e84AEdfD8eB2FBEA8c9a9fbad',
              teller: "0xe97365b41B340352d3d32CA2C7230330F19A1e73",
              assets: ['ETH', '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2'],
            }
          }]
        })
      },
      bridge: {
        canonical: {
          transfer: await ethkit.bridge.canonical.transfer({
            targets: [{ toChainIds: [130] }],
          }),
        },
        stargate: {
          transfer: await ethkit.bridge.stargate.transfer({
            targets: [{
              tokenAddress: "0x66a1E37c9b0eAddca17d3662D6c05F4DECf3e110",
              toChainIds: [1],
            }],
          }),
        },
      },
    },
    [8453]: {
      pendle: {
        depositToken: await basekit.pendle.depositToken({
          targets: ["0x715509Bde846104cF2cCeBF6fdF7eF1BB874Bc45"],
        }),
      },
      bridge: {
        stargate: {
          transfer: await basekit.bridge.stargate.transfer({
            targets: [{
              tokenAddress: "0x35E5dB674D8e93a03d814FA0ADa70731efe8a4b9",
              toChainIds: [10],
            }],
          }),
        },
      },
    },
  } as any as PermissionsByChain;
}

