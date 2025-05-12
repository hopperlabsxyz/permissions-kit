import { c } from "zodiac-roles-sdk/.";
import { allow } from "zodiac-roles-sdk/kit";
import { allowErc20Approve } from "../../conditions";
import { contracts } from "../../../eth-sdk/config"


export const eth = {
  deposit: async () => [
    ...allowErc20Approve(
      [contracts.mainnet.lido.stEth],
      [contracts.mainnet.lido.wstEth]
    ),
    ...allowErc20Approve(
      [contracts.mainnet.lido.stEth, contracts.mainnet.lido.wstEth],
      [contracts.mainnet.lido.unstEth]
    ),
    allow.mainnet.lido.wstEth.wrap(),
    allow.mainnet.lido.wstEth.unwrap(),
    allow.mainnet.lido.stEth.submit(undefined, { send: true }),
    allow.mainnet.lido.unstEth.requestWithdrawals(undefined, c.avatar),
    allow.mainnet.lido.unstEth.requestWithdrawalsWstETH(undefined, c.avatar),
    allow.mainnet.lido.unstEth.claimWithdrawal(),
    allow.mainnet.lido.unstEth.claimWithdrawals(),
  ],
}
