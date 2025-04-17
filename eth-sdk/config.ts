import { defineConfig } from '@gnosis-guild/eth-sdk';

export default defineConfig({
  contracts: {
    mainnet: {
      dai: '0x6b175474e89094c44da98b954eedeac495271d0f',
      usdc: '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48',
      lagoon: {
        vault: '0x16648324d68B86E341051767e749F9F074714228', // implementation
      },
      curve: {
        crvUSD: "0xf939E0A03FB07F59A73314E73794Be0E57ac1b4E",
        scrvUSD: "0x0655977FEb2f289A4aB78af67BAB0d17aAb84367"
      },
      resupply: {
        pair: "0xCF1deb0570c2f7dEe8C07A7e5FA2bd4b2B96520D",
      }
    },
  },
})
