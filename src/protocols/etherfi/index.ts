import { allow } from "zodiac-roles-sdk/kit"
import { allowErc20Approve } from "../../conditions"
import { c, ChainId } from "zodiac-roles-sdk"
import { TargetInfo, Target, Targets } from "./types"

const DEPOSIT_ADAPTER = "0xcfC6d9Bd7411962Bfe7145451A7EF71A24b6A7A2"

export const eth = {
  deposit: async () => {
    return [
      ...allowErc20Approve([WETH], [DEPOSIT_ADAPTER]),
      {
        ...allow.mainnet.etherfi.depositAdapter.depositETHForWeETH(undefined, { send: true }),
        targetAddress: "0xcfC6d9Bd7411962Bfe7145451A7EF71A24b6A7A2"
      }
    ]
  },
}
