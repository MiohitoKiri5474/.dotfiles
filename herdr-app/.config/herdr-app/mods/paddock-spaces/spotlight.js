// Keyboard spotlight on a sidebar list, as paddock's `C-a s` / `C-a w`.
// The leader sends "<mod>.spotlight" (cursor on the current row), and the
// other list sends "spotlight-first" / "spotlight-last" when j/k run past
// its end. j/k or arrows move, Enter opens, x closes, W/o open a worktree
// dialog, Esc gives the keyboard back to the pane it came from.
// Kept identical in mods/paddock-spaces and mods/paddock-agents.

import { run, focused, nextCommand } from "herdr";

export class Spotlight {
  // above / below: the command handing the spotlight to the list above or below.
  constructor(cx, { above = null, below = null } = {}) {
    this.handle = cx.focus_handle();
    this.above = above;
    this.below = below;
    this.order = [];
    this.cursor = null;
    this.want = null;
    this.back = null;
    // Set while this list holds the keyboard. Handing it back may not redraw
    // the list (focusing the same pane changes no live data), so the cursor
    // goes by this rather than by the focus handle alone.
    this.active = false;
    cx.spawn(async (cx) => {
      for (;;) {
        const c = await nextCommand();
        // "focus": the paddock hub (prefix s / w) or pane.go onto this list.
        if (c !== "focus" && !c.startsWith("spotlight")) continue;
        this.active = true;
        this.back = focused()?.pane ?? this.back;
        this.want = c === "spotlight-first" ? "first" : c === "spotlight-last" ? "last" : "current";
        this.handle.focus();
        cx.notify();
      }
    });
  }

  // From render: the rows' ids in screen order, and the current one's.
  rows(ids, current) {
    this.order = ids;
    const fallback = ids.includes(current) ? current : ids[0];
    if (this.want === "first") this.cursor = ids[0];
    else if (this.want === "last") this.cursor = ids.at(-1);
    else if (this.want || !ids.includes(this.cursor)) this.cursor = fallback;
    this.want = null;
  }

  // Whether row `id` wears the cursor.
  on(id) {
    return this.active && id === this.cursor && this.handle.is_focused();
  }

  // Lets go of the keyboard; to = a command handing the spotlight on.
  leave(to = null) {
    this.active = false;
    if (to) run(to);
    else if (this.back) run("pane.focus", { pane: this.back });
  }

  // actions: { open(id, cx), close(id), worktree(id, "new" | "open") }.
  key(e, cx, actions) {
    const i = this.order.indexOf(this.cursor);
    const id = this.cursor;
    // Named keys by name ("enter" may type "\n"), letters as typed ("W").
    switch (e.key.length === 1 ? (e.key_char ?? e.key) : e.key) {
      case "j":
      case "down":
        if (i + 1 < this.order.length) this.cursor = this.order[i + 1];
        else if (this.below) this.leave(this.below);
        break;
      case "k":
      case "up":
        if (i > 0) this.cursor = this.order[i - 1];
        else if (this.above) this.leave(this.above);
        break;
      case "enter":
        if (!id) break;
        this.active = false;
        actions.open(id, cx);
        break;
      case "x":
        if (id) actions.close(id);
        break;
      case "W":
        if (id) actions.worktree(id, "new");
        break;
      case "o":
        if (id) actions.worktree(id, "open");
        break;
      case "escape":
        this.leave();
        break;
      default:
        return;
    }
    cx.stop_propagation();
    cx.notify();
  }
}
