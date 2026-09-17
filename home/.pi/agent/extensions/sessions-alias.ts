import {
  type ExtensionAPI,
  SessionManager,
  SessionSelectorComponent,
} from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  pi.registerCommand("sessions", {
    description: "Alias for /resume",
    handler: async (_args, ctx) => {
      if (ctx.mode !== "tui") {
        ctx.ui.notify(
          "The session selector is only available in TUI mode",
          "warning",
        );
        return;
      }

      const sessionManager = ctx.sessionManager;
      const selectedSession = await ctx.ui.custom<string | undefined>(
        (tui, _theme, keybindings, done) =>
          new SessionSelectorComponent(
            (onProgress) =>
              SessionManager.list(
                sessionManager.getCwd(),
                sessionManager.getSessionDir(),
                onProgress,
              ),
            (onProgress) => SessionManager.listAll(onProgress),
            done,
            () => done(undefined),
            () => {
              done(undefined);
              ctx.shutdown();
            },
            () => tui.requestRender(),
            {
              renameSession: async (sessionPath, nextName) => {
                const name = (nextName ?? "").trim();
                if (!name) return;

                SessionManager.open(sessionPath).appendSessionInfo(name);
              },
              showRenameHint: true,
              keybindings,
            },
            sessionManager.getSessionFile(),
          ),
      );

      if (selectedSession) await ctx.switchSession(selectedSession);
    },
  });
}
