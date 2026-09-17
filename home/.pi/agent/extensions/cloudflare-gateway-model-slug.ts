/**
 * Cloudflare AI Gateway model-slug compat layer
 *
 * Cloudflare's Workers AI catalog lists third-party Anthropic models with a
 * dotted version (`claude-fable-5.1`), but the Anthropic upstream behind the
 * gateway's `/anthropic` passthrough route expects the kebab-style slug
 * (`claude-fable-5-1`). Sending the dotted id trips Cloudflare's proxy routing
 * and returns an error block instead of a completion.
 *
 * This rewrites the outgoing payload's `model` field to its slug, and only for
 * requests on the gateway's Anthropic route (`cloudflare-ai-gateway` +
 * `anthropic-messages`). The gateway's OpenAI (`gpt-5.1`) and Workers AI
 * (`workers-ai/@cf/...`) routes keep their ids verbatim.
 *
 * The payload model is required to match the active model id: that is the only
 * evidence tying a payload to a known provider/api pair, and rewriting a
 * payload of unknown origin could corrupt a legitimate dotted id.
 */

import type {
  BeforeProviderRequestEvent,
  ExtensionAPI,
} from "@earendil-works/pi-coding-agent";

type ProviderPayload = BeforeProviderRequestEvent["payload"];

const GATEWAY_PROVIDER = "cloudflare-ai-gateway";
const ANTHROPIC_API = "anthropic-messages";

function slugify(value: string): string {
  return value
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "");
}

type ModelPayload = { model: string };

function isModelPayload(payload: ProviderPayload): payload is ModelPayload {
  return (
    typeof payload === "object" &&
    payload !== null &&
    "model" in payload &&
    typeof payload.model === "string"
  );
}

export default function cloudflareGatewayModelSlugExtension(pi: ExtensionAPI) {
  pi.on("before_provider_request", (event, ctx) => {
    const model = ctx.model;
    if (model?.provider !== GATEWAY_PROVIDER) return;
    if (model.api !== ANTHROPIC_API) return;

    const payload = event.payload;
    if (!isModelPayload(payload) || payload.model !== model.id) return;

    const slug = slugify(payload.model);
    if (slug === payload.model) return;

    return { ...payload, model: slug };
  });
}
