import { defineConfig } from "@gnosis-guild/eth-sdk";

export default defineConfig({
  contracts: {
    mainnet: {
      dai: "0x6b175474e89094c44da98b954eedeac495271d0f",
      usdc: "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48",
      lagoon: {
        vault: "0x16648324d68B86E341051767e749F9F074714228", // implementation
      },
      morpho: {
        morphoBlue: "0xBBBBBbbBBb9cC5e90e3b3Af64bdAF62C37EEFFCb",
        metaMorpho: "0x4881Ef0BF6d2365D3dd6499ccd7532bcdBCE0658",
      },
    },
  },
});
