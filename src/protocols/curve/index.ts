import { allow } from "zodiac-roles-sdk/kit"
import { allowErc20Approve } from "../../conditions"
import { c } from "zodiac-roles-sdk"

export const CRVUSD = "0xf939E0A03FB07F59A73314E73794Be0E57ac1b4E"
export const SCRVUSD = "0x0655977FEb2f289A4aB78af67BAB0d17aAb84367"

export const eth = {
  stakeCrvUSD: async () => {
    return [
      ...allowErc20Approve([CRVUSD], [SCRVUSD]),
      allow.mainnet.curve.scrvUSD.deposit(undefined, c.avatar)
    ]
  }
}
