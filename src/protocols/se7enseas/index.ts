import { allowErc20Approve, oneOf } from "../../conditions";
import { c, ChainId } from "zodiac-roles-sdk";
import { allow } from "zodiac-roles-sdk/kit";
import { Target, TargetInfo, Targets } from "./type";

const ETH = '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE'


function getTargetInfo(target: Target): TargetInfo {
  return {
    boringVault: target.vault.boringVault,
    teller: target.vault.teller,
    assets: target.vault.assets,
  };
}

export function depositBoringVault(_: ChainId, targetInfo: TargetInfo) {
  const isEthAllowed = targetInfo.assets.includes('ETH');
  const assetsAllowedApprove = targetInfo.assets.filter((asset) => asset !== 'ETH')
  const assetsAllowedDeposit = targetInfo.assets.map((asset) => asset === 'ETH' ? ETH : asset)
  return [
    // deposit flow
    ...allowErc20Approve(assetsAllowedApprove, [targetInfo.boringVault]),
    {
      ...allow.mainnet.se7enseas.teller.deposit(oneOf(assetsAllowedDeposit), undefined, undefined, { send: isEthAllowed }),
      targetAddress: targetInfo.teller
    },
  ]
}

export const eth = {
  depositBoringVault: async ({ targets }: { targets: Targets }) => {
    return targets.flatMap((target) => depositBoringVault(1, getTargetInfo(target)));
  },
};
