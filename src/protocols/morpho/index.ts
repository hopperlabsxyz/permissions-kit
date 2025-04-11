import { allow } from "zodiac-roles-sdk/kit"
import { allowErc20Approve } from "../../conditions";
import { c, ChainId, Permission } from "zodiac-roles-sdk";
import { Target, Targets, UnknownTarget } from "./types";
// import { MarketParams } from "./types";
import { Chain } from "../../types";
import _ethVaults from "./_ethVaults";
// import _baseVaults from "./_baseVaults";
import { NotFoundError } from "../../errors";

// Helper functions
function deposit(
  _: ChainId,
  Target: UnknownTarget,
) {
  return [
    ...allowErc20Approve([Target.asset], [Target.address]),
    {
      ...allow.mainnet.morpho.metaMorpho.deposit(undefined),
      targetAddress: Target.address,
    },
  ]
}

function withdraw(
  _: ChainId,
  Target: UnknownTarget,
) {
  return [
    ...allowErc20Approve([Target.asset], [Target.address]),
    {
      ...allow.mainnet.morpho.metaMorpho.withdraw(undefined),
      targetAddress: Target.address,
    },
  ]
}

// *** MorphoBlue *** //
// function supplyCollateral(
//   _: ChainId,
//   market: MarketParams,
// ) {
//   return [
//     ...allowErc20Approve([market.collateralToken], [market.marketAddress]),
//     {
//       ...allow.mainnet.morpho.market.supplyCollateral(undefined),
//       targetAddress: market.marketAddress,
//     },
//   ]
// }

// function withdrawCollateral(
//   _: ChainId,
//   market: MarketParams,
// ) {
//   return [
//     ...allowErc20Approve([market.collateralToken], [market.marketAddress]),
//     {
//       ...allow.mainnet.morpho.market.withdrawCollateral(undefined),
//       targetAddress: market.marketAddress,
//     },
//   ]
// }

// function borrow(
//   _: ChainId,
//   market: MarketParams,
// ) {
//   return [
//     ...allowErc20Approve([market.borrowToken], [market.marketAddress]),
//     {
//       ...allow.mainnet.morpho.market.borrow(undefined),
//       targetAddress: market.marketAddress,
//     },
//   ]
// }

// function repay(
//   _: ChainId,
//   market: MarketParams,
// ) {
//   return [
//     ...allowErc20Approve([market.borrowToken], [market.marketAddress]),
//     {
//       ...allow.mainnet.morpho.market.repay(undefined),
//       targetAddress: market.marketAddress,
//     },
//   ]
// }

// function supply(
//   _: ChainId,
//   market: MarketParams,
// ) {
//   return [
//     ...allowErc20Approve([market.supplyToken], [market.marketAddress]),
//     {
//       ...allow.mainnet.morpho.market.supply(undefined),
//       targetAddress: market.marketAddress,
//     },
//   ]
// }

// function withdrawSupply(
//   _: ChainId,
//   market: MarketParams,
// ) {
//   return [
//     ...allowErc20Approve([market.supplyToken], [market.marketAddress]),
//     {
//       ...allow.mainnet.morpho.market.withdrawSupply(undefined),
//       targetAddress: market.marketAddress,
//     },
//   ]
// }

// Composite functions
// function manageCollateral(
//   chainId: ChainId,
//   market: MarketParams,
// ) {
//   return [
//     ...supplyCollateral(chainId, market),
//     ...withdrawCollateral(chainId, market),
//   ]
// }

// function manageLoan(
//   chainId: ChainId,
//   market: MarketParams,
// ) {
//   return [
//     ...borrow(chainId, market),
//     ...repay(chainId, market),
//   ]
// }

// function manageSupply(
//   chainId: ChainId,
//   market: MarketParams,
// ) {
//   return [
//     ...supply(chainId, market),
//     ...withdrawSupply(chainId, market),
//   ]
// }

// Utility function to find a vault
function getVault(chain: Chain, target: string): Vault {
  let vaults
  switch (chain) {
    case Chain.eth:
      vaults = _ethVaults
      break
    default:
      throw new Error(`Unsupported chain: ${chain}`)
  }
  
  const targetLower = target.toLowerCase()
  const vault = vaults.find(
    (v) =>
      v.name.toLowerCase() === targetLower ||
      v.address.toLowerCase() === targetLower ||
      v.symbol.toLowerCase() === targetLower
  )
  
  if (!vault) {
    throw new NotFoundError(`Vault not found: ${target}`)
  }
  return vault
}

// Export methods
export const eth = {
  deposit: async ({ targets }: { targets: Targets }) => {
    return targets.flatMap((target) => {
      const vault = getVault(Chain.eth, typeof target === 'string' ? target : target.address)
      return [...deposit(1, vault), ...withdraw(1, vault)]
    })
  },
  
  // borrow: async ({ targets }: { targets: MarketParams[] }) => {
  //   return targets.flatMap((marketParams) => [
  //     ...manageCollateral(1, marketParams),
  //     ...manageLoan(1, marketParams)
  //   ])
  // },
  
  // supply: async ({ targets }: { targets: MarketParams[] }) => {
  //   return targets.flatMap((marketParams) => manageSupply(1, marketParams))
  // }
}

