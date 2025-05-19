import { allow } from "zodiac-roles-sdk/kit"
import { allowErc20Approve } from "../../conditions"
import { contracts } from "../../../eth-sdk/config"
import { Permission } from "zodiac-roles-sdk/.";

const DEPOSIT_ADAPTER = "0xcfC6d9Bd7411962Bfe7145451A7EF71A24b6A7A2"
const WETH = contracts.mainnet.weth;

type Target = 'WETH' | 'ETH'

function deposit(target: Target) {
  if (target === 'ETH') {
    return [
      {
        ...allow.mainnet.etherfi.depositAdapter.depositETHForWeETH(undefined, { send: true }),
        targetAddress: "0xcfC6d9Bd7411962Bfe7145451A7EF71A24b6A7A2"
      },
    ] as Permission[]
  }
  else if (target === 'WETH') {
    return [
      ...allowErc20Approve([WETH], [DEPOSIT_ADAPTER]),
      {
        ...allow.mainnet.etherfi.depositAdapter.depositWETHForWeETH(undefined, undefined),
        targetAddress: "0xcfC6d9Bd7411962Bfe7145451A7EF71A24b6A7A2"
      }]
  }
  throw new Error(`Unsupported target: ${target}`)
}

export const eth = {
  deposit: async ({ targets }: { targets: Target[] }) => {
    return targets.flatMap((target) => deposit(target))
  },
}
