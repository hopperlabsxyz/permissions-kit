import { canonicalTransfer } from "./canonical";
import { CanonicalTarget } from "./canonical/type";
import { stargateTransfer } from "./stargate";
import { StargateTarget } from "./stargate/type";


export const eth = {
  canonical: {
    transfer: async ({ targets }: { targets: CanonicalTarget[] }) => {
      return targets.flatMap(({ toChainIds, bridgeAddresses }) =>
        canonicalTransfer(1, toChainIds, bridgeAddresses)
      );
    },
  },
  stargate: {
    transfer: async ({ targets }: { targets: StargateTarget[] }) => {
      return targets.flatMap(({ tokenAddress: tokenAddresses, toChainIds: dstChainIds }) =>
        stargateTransfer(1, tokenAddresses, dstChainIds)
      );
    },
  }
};

export const base = {
  stargate: {
    transfer: async ({ targets }: { targets: StargateTarget[] }) => {
      return targets.flatMap(({ tokenAddress: tokenAddresses, toChainIds: dstChainIds }) =>
        stargateTransfer(8453, tokenAddresses, dstChainIds)
      );
    },
  },
};
