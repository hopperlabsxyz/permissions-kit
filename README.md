# Permissions Kit

**Permissions for Zodiac Roles Modifier covering interactions with DeFi protocols** inspired by ![Karpatkey's Defi-kit SDK](https://github.com/karpatkey/defi-kit).

The Permissions Kit is a TypeScript SDK that provides pre-configured permissions for interacting with various DeFi protocols through [Zodiac Roles Modifier](https://docs.roles.gnosisguild.org/). It enables safe and controlled access to protocols like Curve, Convex, Lido, Pendle, and more across Ethereum and other EVM networks.

## Features

- **DeFi Interactions**: Pre-configured permissions for major DeFi protocols
- **Multi-Chain Support**: Ethereum mainnet and Base network are currently supported
- **Zodiac Roles Integration**: Built on top of Zodiac Roles SDK
- **TypeScript First**: Full TypeScript support with comprehensive type definitions

## Installation

```bash
npm install @hopperlabsxyz/permissions-kit
# or
yarn add @hopperlabsxyz/permissions-kit
# or
bun add @hopperlabsxyz/permissions-kit
```

> **Note:** We recommend using the permissions-kit alongside the [Zodiac Starter Kit](https://docs.roles.gnosisguild.org/sdk/getting-started) for enhanced functionality and streamlined development.

### Ethereum Mainnet
- **Lagoon**: Vault management, deposits, withdrawals, and settlement
- **Curve**: Stable swap interactions and liquidity provision
- **Convex**: Staking and reward claiming
- **Lido**: ETH staking and unstaking (stETH, wstETH)
- **EtherFi**: ETH and WETH deposit for weETH
- **Resupply**: Liquidity pair management
- **Se7enseas**: Boring Vault interactions
- **Bridge**: Canonical L1/L2 bridging

### Base Network
- **Pendle**: Deposit and remove liquidity 
- **Bridge**: Stargate cross-chain bridging

### Basic Usage

#### Ethereum network protocols

```typescript
import { kit } from "@hopperlabsxyz/permissions-kit/eth";

const permissions = await kit.lido.deposit();
```

#### Base network protocols

```typescript
import { kit } from "@hopperlabsxyz/permissions-kit/base";

const pendlePermissions = await kit.pendle.deposit({
  targets: ["0xMarketAddress"]
});
```

## Development

### Prerequisites

- [Bun](https://bun.sh) v1.2.4 or higher
- [Foundry](https://book.getfoundry.sh/getting-started/installation) for Solidity testing
- Alchemy API key for testing

### Setup

1. Clone the repository:
```bash
git clone git@github.com:hopperlabsxyz/permissions-kit.git
cd permissions-kit
```

2. Install dependencies:
```bash
bun install
```

3. Set up environment variables:
```bash
cp .env.example .env
# Edit .env and add your ALCHEMY_API_KEY
```

4. Generate SDK contracts:
```bash
bun run setup
```

### Building

```bash
bun run build
```

This generates both CommonJS and ES Module builds in the `dist/` directory.

### Testing

Run the test suite:
```bash
bun run test
```

The tests use Foundry for Solidity-based integration testing with forked networks.

### Generating Permissions

To build and generate new permissions:
```bash
bun run generate
```

This command builds the kits and executes the `test/scripts/applyUpdates.ts` script, which updates the permission calls in `test/permissions/[chainId].json` based on the configuration in `test/scripts/config.ts`. These permission calls are then used across different test suites. Run this command before `bun run test` whenever you add new protocols or permissions to the test suite. See the section below for more informations.

## Contributing

### Adding a New Protocol

1. Create a new directory under `src/protocols/`:
```bash
mkdir src/protocols/your-protocol
```

2. Implement the protocol interface:
```typescript
// src/protocols/your-protocol/index.ts
export const eth = {
  yourAction: async ({ targets }: { targets: string[] }) => {
    // Implementation
  }
};
```

3. Add the protocol to the main exports:
```typescript
// src/protocols/index.ts
import * as yourProtocol from "./your-protocol";

export const eth = {
  // ... existing protocols
  yourProtocol: yourProtocol.eth,
};
```

4. Configure the permissions you want to test:

```typescript
// test/scripts/config.ts
export async function createPermissions(): Promise<PermissionsByChain> {
  return {
    [1]: {
      // ... other eth permissions
      yourProtocol: {
        yourAction: await ethkit.yourProtocol.yourAction({
          targets: ['0x...']
        }),
      },
    },
    [8453]: {
      // ... base permissions
    },
  } as any as PermissionsByChain;
}
```

5. Generate the permissions' calls

```bash
bun run generate
```


6. Add corresponding solidity test files:

```solidity
// test/protocols/your-protocol/index.t.sol
// Your Foundry tests (other test files should guide you on loading permissions you want to test)
```

### Running Specific Tests

```bash
# Run tests for a specific protocol
forge test --match-contract YourProtocolTest

# Run tests with verbose output
forge test -vvv
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For questions and support:
- Open an issue on [GitHub](https://github.com/hopperlabsxyz/permissions-kit/issues)
- Join our [Discord](https://discord.gg/) (soon)

---

## Disclaimer ⚠️

This SDK is provided on a best-effort basis by the Lagoon team to facilitate integration with Zodiac Roles Modifier. While we strive to ensure the accuracy, reliability, and security of this software, it is provided “as is” without any guarantees or warranties of any kind, express or implied.

Lagoon and its contributors accept no responsibility or liability for any loss, damage, or other consequences resulting from the use, misuse, or inability to use this SDK. It is the responsibility of the integrator to perform appropriate testing, due diligence, and security assessments before deploying or relying on this software in production environments.

By using this SDK, you acknowledge and agree to assume all associated risks.
