import type { Plugin, tool } from "@opencode-ai/plugin";

// Function to play bell sound
async function playBellSound($: any, sessionTitle?: string) {
  try {
    // @ts-ignore
    const platform = process.platform;

    if (platform === "darwin") {
      // macOS - use system sound with session name
      const sayName = sessionTitle || "task";
      await $`say "opencode ${sayName} done"`;
    } else if (platform === "linux") {
      // Linux - try multiple audio players
      try {
        await $`paplay /usr/share/sounds/alsa/Front_Left.wav`;
      } catch {
        try {
          await $`aplay /usr/share/sounds/alsa/Front_Left.wav`;
        } catch {
          // Fallback to system beep
          await $`printf '\a'`;
        }
      }
    } else if (platform === "win32") {
      // Windows - use system beep
      await $`powershell -c "[console]::beep(800,500)"`;
    } else {
      // Fallback - print bell character
      console.log("\u0007"); // Bell character
    }
  } catch (error) {
    // Silent fallback - don't show errors for sound
    console.log("\u0007"); // Bell character fallback
  }
}

export const NotificationPlugin: Plugin = async ({
  project,
  client,
  $,
  directory,
  worktree,
}) => {
  return {
    event: async ({ event }) => {
      // Send notification on session completion
      if (event.type === "session.idle") {
        const sessionID = event.properties.sessionID;

        // Get session info
        const session = await client.session
          .get({
            path: { id: sessionID },
          })
          .then((data) => data.data);

        // Skip notifications for subagents (sessions with a parent)
        if (session?.parentID) {
          return;
        }

        // Get session title for task context
        const sessionTitle = session?.title;

        // Prepare notification content
        const projectName = project.id.split("/").pop() || "Unknown";
        const shortDir = directory.split("/").pop() || "";

        // Calculate session duration

        const taskContext = sessionTitle || "Unnamed task";
        const title = `OpenCode: ${projectName}`;
        const subtitle = `${shortDir}`;

        // Send cross-platform notification
        // @ts-ignore
        const platform = process.platform;

        try {
          // Play bell sound first
          await playBellSound($, sessionTitle);

          if (platform === "darwin") {
            // macOS
            await $`osascript -e 'display notification "${taskContext}" with title "${title}" subtitle "${subtitle}"'`;
          } else if (platform === "linux") {
            // Linux
            await $`notify-send "${title}" "${taskContext}" --app-name="OpenCode" --hint=string:desktop-entry:opencode`;
          } else if (platform === "win32") {
            // Windows
            const message = `${title}\\n${taskContext}`;
            await $`powershell -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('${message}', 'OpenCode', 'OK', 'Information')"`;
          } else {
            // Fallback - just log to console
            console.log(
              `🎯 OpenCode Session Complete: ${title} - ${taskContext}`,
            );
          }
        } catch (error) {
          // Fallback notification if platform-specific command fails
          console.log(
            `🎯 OpenCode Session Complete: ${title} - ${taskContext}`,
          );
          console.log(`📍 Directory: ${directory}`);
        }
      }
    },
  };
};

// export const CustomToolsPlugin: Plugin = async (ctx) => {
//   return {
//     tool: {
//       mytool: tool({
//         description: "This is a custom tool",
//         args: {
//           foo: tool.schema.string(),
//         },
//         async execute(args, ctx) {
//           return `Hello ${args.foo}!`
//         },
//       }),
//     },
//   }
// }
