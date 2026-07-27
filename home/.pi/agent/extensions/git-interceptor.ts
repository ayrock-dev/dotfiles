/**
 * Git Interceptor
 *
 * Guards for agent-driven `git` and `gh` bash commands:
 *
 * 1. Interactive-hang prevention — exports no-op editors/pager/browser so
 *    neither CLI can spawn an interactive program that blocks the bash tool:
 *      git: GIT_EDITOR, GIT_SEQUENCE_EDITOR (no-op), GIT_MERGE_AUTOEDIT=no
 *      gh:  GH_EDITOR (no-op), GH_PAGER=cat, GH_BROWSER (no-op)
 *    The exports are harmless when the command is neither git nor gh.
 *
 * 2. Hook-bypass prevention — blocks any command containing `--no-verify` so
 *    the agent cannot circumvent git hooks (pre-commit, commit-msg, etc.).
 *    Fix the underlying hook failure or ask the human instead.
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { isToolCallEventType } from "@earendil-works/pi-coding-agent";

const ENV_PREFIX =
  "export GIT_EDITOR=true GIT_SEQUENCE_EDITOR=true GIT_MERGE_AUTOEDIT=no " +
  "GH_EDITOR=true GH_PAGER=cat GH_BROWSER=true\n";

// Match `git` or `gh` as a command word (won't match "github", "weight", ...).
const GIT_OR_GH_RE = /\b(git|gh)\b/;

const NO_VERIFY_RE = /--no-verify\b/;

const BLOCK_REASON =
  "BLOCKED: --no-verify is not allowed. Git hooks exist for a reason. " +
  "Do not attempt to bypass them. Instead: fix the underlying issue that " +
  "is causing the hook to fail, or ask the user for help.";

export default function (pi: ExtensionAPI) {
  pi.on("tool_call", (event) => {
    if (!isToolCallEventType("bash", event)) return;
    if (!GIT_OR_GH_RE.test(event.input.command)) return;

    if (NO_VERIFY_RE.test(event.input.command)) {
      return { block: true, reason: BLOCK_REASON };
    }

    event.input.command = ENV_PREFIX + event.input.command;
  });
}
