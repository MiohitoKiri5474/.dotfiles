// paddock's floats: `C-a G` shows lazygit in a box over the window, and again
// hides it with lazygit still running, so showing it brings back the same
// state. Each space has its own. Quitting lazygit ends it (and its box); the
// next `C-a G` starts a new one in the focused terminal's folder.
//
// Lives in an invisible floating block of the layout so it outlives the
// leader popup (a closed popup's tasks are cancelled) and keeps its state.
// The leader sends "floats.lazygit".

import { View, div } from "gpui-kit";
import { focused, terminals, hc, nextCommand, openOverlay, closeOverlay } from "herdr";

const PROGRAMS = { lazygit: ["lazygit"] };

export default class Floats extends View {
  init(_props, cx) {
    this.floats = {}; // "<space> <name>" -> { terminal, overlay | null }
    cx.spawn(async (cx) => {
      for (;;) {
        const name = await nextCommand();
        if (PROGRAMS[name]) await this.toggle(name);
        cx.notify();
      }
    });
  }

  async toggle(name) {
    const space = focused()?.space;
    if (!space) return;
    const key = `${space} ${name}`;
    const f = this.floats[key];
    if (f && terminals().some((t) => t.address === f.terminal && t.state === "live")) {
      if (f.overlay) {
        closeOverlay(f.overlay);
        f.overlay = null;
      } else f.overlay = show(f.terminal);
      return;
    }
    const args = ["run", "--bg", "--json", "--no-parent", "--rm"];
    const cwd = focused()?.cwd;
    if (cwd) args.push("--cwd", cwd);
    const r = await hc([...args, "--", ...PROGRAMS[name]]);
    if (r.code !== 0) return;
    const { address } = JSON.parse(r.stdout);
    this.floats[key] = { terminal: address, overlay: show(address) };
  }

  render() {
    return div();
  }
}

// Modal, so only `C-a G` or quitting the program closes it: a click beside it
// would hide it without this mod knowing.
function show(terminal) {
  return openOverlay({ kind: "dialog", modal: true, width: 0.8, height: 0.8, layout: { type: "block", content: { terminal } } });
}
