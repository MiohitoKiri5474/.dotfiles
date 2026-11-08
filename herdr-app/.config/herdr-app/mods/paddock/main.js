// paddock's extra actions, kept in the status row so they always have a shown copy.
// Reached by the prefix popup (paddock-prefix) and keys.json as "paddock.<command>":
// move_tab_left|right, sidebar_narrower|wider, next_attention, last_page, fork,
// new_worktree, open_worktree, focus_agents, focus_spaces, float_<key>.
// Draws a small strip: the prefix hint, or the last notice.

import { View, div } from "gpui-kit";
import { h_flex } from "gpui-base";
import { spaces, agents, panes, focused, terminals, layout, run, hc, theme, openOverlay, closeOverlay, nextCommand, shared, setShared } from "herdr";

// Floats: prefix + key shows or hides this program over the window, one per space.
const FLOATS = { G: ["lazygit"] };
const SIDEBAR_STEP = 20; // px per press; paddock moved 2 columns
const SIDEBAR_MIN = 44;
const SIDEBAR_MAX = 480;
const NOTICE_MS = 4000;
const RECENT_MAX = 20; // tabs remembered for last_page

function find(node, id) {
  if (node?.id === id) return node;
  for (const child of node?.children ?? []) {
    const found = find(child, id);
    if (found) return found;
  }
  return null;
}

const ATTENTION = ["blocked", "done"];

export default class Paddock extends View {
  init(_props, cx) {
    // {space, tab} shown, newest first; closed ones skipped on use. In shared so a restart keeps it.
    this.recent = shared("paddock.recent") ?? [];
    this.notice = null;
    // Survives mod reloads, not app restarts: tells a float overlay id from a dead one.
    globalThis.paddockBoot ??= Date.now();
    cx.spawn(async (cx) => {
      for (;;) {
        const c = await nextCommand();
        try { await this.handle(c, cx); } catch (e) { this.say(`paddock: ${e.message ?? e}`, cx); }
        cx.notify();
      }
    });
  }

  say(text, cx) {
    this.notice = text;
    cx.timer.after(NOTICE_MS, (cx) => { if (this.notice === text) { this.notice = null; cx.notify(); } });
    cx.notify();
  }

  async handle(c, cx) {
    if (c.startsWith("float_")) return this.toggleFloat(c.slice(6), cx);
    switch (c) {
      case "move_tab_left": return this.moveTab(-1);
      case "move_tab_right": return this.moveTab(1);
      case "sidebar_narrower": return this.resizeSidebar(-SIDEBAR_STEP);
      case "sidebar_wider": return this.resizeSidebar(SIDEBAR_STEP);
      case "next_attention": return this.nextAttention(cx);
      case "last_page": return this.lastPage(cx);
      case "fork": return this.fork(cx);
      case "new_worktree": return this.worktree("new");
      case "open_worktree": return this.worktree("open");
      case "focus_agents": return this.focusSidebar("paddock-agents", cx);
      case "focus_spaces": return this.focusSidebar("paddock-spaces", cx);
      default: return this.say(`paddock: unknown command ${c}`, cx);
    }
  }

  currentTab() {
    const f = focused();
    const space = spaces().find((s) => s.id === f?.space) ?? spaces().find((s) => s.active);
    const tab = space?.tabs.find((t) => t.id === f?.tab) ?? space?.tabs.find((t) => t.active);
    return { space, tab };
  }

  moveTab(step) {
    const { space, tab } = this.currentTab();
    if (!tab) return;
    const index = tab.index + step;
    if (index < 1 || index > space.tabs.length) return;
    run("tab.move", { id: tab.id, index });
  }

  resizeSidebar(step) {
    const px = find(layout(), "sidebar")?.size?.px ?? 268;
    run("layout.show", { id: "sidebar" });
    run("layout.resize", { id: "sidebar", px: Math.min(SIDEBAR_MAX, Math.max(SIDEBAR_MIN, px + step)) });
  }

  // The next agent needing you (blocked first, then done) after the focused one, wrapping.
  nextAttention(cx) {
    const all = agents();
    const want = ATTENTION.flatMap((s) => all.filter((a) => a.status === s));
    if (!want.length) return this.say("no session needs you", cx);
    const at = want.findIndex((a) => a.focused);
    run("agent.focus", { terminal: want[(at + 1) % want.length].address });
  }

  lastPage(cx) {
    // Newest tab still open, other than the one shown: closing a tab doesn't break it.
    const all = spaces();
    const live = this.recent.slice(1).find((p) => all.some((s) => s.id === p.space && s.tabs.some((t) => t.id === p.tab)));
    if (!live) return this.say("no last tab", cx);
    run("space.select", { id: live.space });
    run("tab.select", { id: live.tab });
  }

  // ponytail: --continue forks the newest Claude session in that folder, which is the
  // focused one unless two Claude sessions share a folder; paddock knew the exact session id.
  fork(cx) {
    const pane = panes().find((p) => p.focused);
    if (!pane?.cwd || !(pane.program?.key === "claude" || pane.app === "claude-code")) return this.say("fork: focus a Claude Code pane first", cx);
    run("tab.new", { folder: pane.cwd, argv: ["claude", "--continue", "--fork-session"] });
  }

  worktree(action) {
    const { space } = this.currentTab();
    const folder = panes().find((p) => p.focused)?.cwd;
    const size = action === "open" ? { width: 560, height: 480 } : { width: 460, height: 280 };
    openOverlay({ mod: "worktree", kind: "dialog", ...size, props: { space: space?.id, folder, action } });
  }

  focusSidebar(mod, cx) {
    run("layout.show", { id: "sidebar" });
    // A just-shown sidebar needs a frame before its copy can take commands.
    cx.timer.after(120, () => run(`${mod}.focus`));
  }

  async toggleFloat(key, cx) {
    const argv = FLOATS[key];
    const { space } = this.currentTab();
    if (!argv || !space) return;
    const id = `${space.id}:${key}`;
    // Kept in shared so a mod reload doesn't forget an open float.
    const floats = shared("paddock.floats") ?? {};
    const f = floats[id] ?? {};
    const live = (addr) => terminals().some((x) => x.address === addr && x.state === "live");
    if (f.overlay && f.boot === globalThis.paddockBoot && live(f.terminal)) {
      closeOverlay(f.overlay);
      setShared("paddock.floats", { ...floats, [id]: { terminal: f.terminal } });
      if (f.back) run("pane.focus", { pane: f.back });
      return;
    }
    let terminal = f.terminal;
    if (!live(terminal)) {
      const cwd = panes().find((p) => p.focused)?.cwd || space.folder || "~";
      const on = space.machine ? ["--on", space.machine] : [];
      // No herdr.* labels: the float stays out of the tabs.
      const r = await hc(["run", "--bg", "--json", "--no-parent", "--rm", "--cwd", cwd, ...on, "--", ...argv]);
      if (r.code !== 0) return this.say(`float ${key}: ${(r.stderr || r.stdout).trim()}`, cx);
      const addr = JSON.parse(r.stdout).address;
      terminal = space.machine && !addr.includes("/") ? `${space.machine}/${addr}` : addr;
    }
    const back = focused()?.pane ?? null;
    // Modal: only the prefix key (or the program ending) hides it, so its id stays true.
    const overlay = openOverlay({ kind: "dialog", modal: true, width: 0.8, height: 0.8, layout: { type: "column", children: [{ type: "block", content: { terminal } }] } });
    // ponytail: pane.focus can't reach an overlay terminal ("no such pane"); if typing
    // doesn't reach the float, click it once.
    setShared("paddock.floats", { ...floats, [id]: { terminal, overlay, back, boot: globalThis.paddockBoot } });
  }

  render() {
    const f = focused();
    const top = this.recent[0];
    if (f?.tab && (f.space !== top?.space || f.tab !== top?.tab)) {
      const rest = this.recent.filter((p) => p.tab !== f.tab);
      this.recent = [{ space: f.space, tab: f.tab }, ...rest].slice(0, RECENT_MAX);
      setShared("paddock.recent", this.recent);
    }
    const t = theme();
    return h_flex().size_full().px(12).items_center().justify_end().bg(t.chrome).border_t(1).border_color(t.border)
      .text_size(11.8).text_color(this.notice ? t.foreground : t.dim)
      .child(div().truncate().child(this.notice ?? "⌃A  paddock"));
  }
}
