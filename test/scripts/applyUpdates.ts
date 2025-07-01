import { Address } from "@gnosis-guild/eth-sdk";
import {
  applyMembers,
  applyTargets,
  ChainId,
  Permission,
  processPermissions,
  Role,
  Target,
} from "zodiac-roles-sdk";
import { CONFIG, createPermissions, SUPPORTED_CHAINS } from "./config";

interface ApplyUpdates {
  chainId: ChainId;
  address: Address;
  owner: Address;
  role: Role;
  members: Address[];
  targets: Target[];
}

type ProtocolPermissions = Record<string, Permission[]>;
type BridgePermissions = Record<string, ProtocolPermissions>;
type ChainPermissions = Record<string, ProtocolPermissions> & {
  bridge?: BridgePermissions;
};

export type PermissionsByChain = Record<ChainId, ChainPermissions>;

const currentRole: Role = {
  key: CONFIG.TEST_ROLE,
  members: [CONFIG.MANAGER],
  targets: [],
  annotations: [],
  lastUpdate: 0,
};
async function applyUpdates({
  chainId,
  address,
  role,
  members,
  targets,
}: ApplyUpdates) {
  const comments: string[] = [];
  const logCall = (log: string) => comments.push(log);
  let calls: { to: `0x${string}`; data: `0x${string}` }[] = [];

  if (members?.length) {
    const memberCalls = await applyMembers(role.key, members, {
      chainId,
      address,
      mode: "replace",
      currentMembers: role.members,
      log: logCall,
    });
    calls.push(...memberCalls.map((data) => ({ to: address, data })));
  }

  if (targets?.length) {
    const targetCalls = await applyTargets(role.key, targets, {
      chainId,
      address,
      mode: "replace",
      currentTargets: role.targets,
      log: logCall,
    });
    calls.push(...targetCalls.map((data) => ({ to: address, data })));
  }

  return calls;
}

async function getCallsFromPermissions(permissions: Permission[], chainId: ChainId): Promise<string[]> {
  const { targets } = processPermissions(permissions);

  const calls = await applyUpdates({
    chainId,
    address: CONFIG.ROLES_ADDRESS,
    owner: CONFIG.AVATAR,
    role: currentRole,
    members: [CONFIG.MANAGER],
    targets,
  });

  return calls.map((call) => call.data);
}

function getPermissionsForChain(permissions: PermissionsByChain, chainId: ChainId): ChainPermissions {
  if (!(chainId in permissions)) {
    throw new Error(`Chain id ${chainId} not supported`);
  }
  return permissions[chainId];
}

async function generatePermissions(
  protocolPermissions: ProtocolPermissions,
  chainId: ChainId
): Promise<Record<string, string[]>> {
  const result: Record<string, string[]> = {};

  const actions = Object.keys(protocolPermissions);

  await Promise.all(
    actions.map(async (action) => {
      result[action] = await getCallsFromPermissions(
        protocolPermissions[action],
        chainId
      );
    })
  );

  return result;
}

async function generateForChain(chainId: ChainId, allPermissions: PermissionsByChain) {
  const chainPermissions = getPermissionsForChain(allPermissions, chainId);

  const result: Record<string, Record<string, string[]>> = {};

  const protocols = Object.keys(chainPermissions);

  for (const protocol of protocols) {
    if (protocol === 'bridge') {
      // Special handling for bridge - it has nested protocols
      const bridgeProtocols = chainPermissions.bridge!;
      const bridgeResult: Record<string, Record<string, string[]>> = {};

      for (const bridgeProtocol of Object.keys(bridgeProtocols)) {
        bridgeResult[bridgeProtocol] = await generatePermissions(
          bridgeProtocols[bridgeProtocol],
          chainId
        );
      }

      result.bridge = bridgeResult as any;
    } else {
      // Regular protocol processing
      result[protocol] = await generatePermissions(
        chainPermissions[protocol] as ProtocolPermissions,
        chainId
      );
    }
  }
  await Bun.write(
    `test/permissions/${chainId}.json`,
    JSON.stringify(result, null, 2)
  );
}

async function main() {
  try {
    const permissions = await createPermissions();
    await Promise.all(
      SUPPORTED_CHAINS.map(chainId => generateForChain(chainId, permissions))
    );

    console.log("All permission files generated successfully!");
  } catch (error) {
    console.error("Error generating permissions:", error);
    process.exit(1);
  }
}

await main();
