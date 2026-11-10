// paddock's prefix keys (C-a, then a key), as a popup: keys.json opens it on
// ctrl-a, the next key runs its command and closes it. Esc or any other key
// just closes it. The popup lists the keys, like a which-key.
//
// `Tab` goes to the last tab shown, across spaces, from the history the
// tab-history mod keeps in shared "tabs.history" (closed tabs drop out).

import { View, div } from "gpui-kit";
import { v_flex, h_flex } from "gpui-base";
import { run, props, closeOverlay, openOverlay, notify, theme, spaces, panes, agents, focused, layout, shared, hc } from "herdr";

const SIDEBAR_STEP = 40;

const KEYS = [
  ["Tab", "last tab", lastTab],
  [";", "last tab", lastTab],
  ["c", "new tab", () => run("tab.new")],
  ["C", "new space", () => run("space.new")],
  ["n", "next tab", () => run("tab.next")],
  ["p", "previous tab", () => run("tab.prev")],
  ["1-9", "go to tab N", null],
  [",", "rename tab", () => run("tab.rename")],
  ["$", "rename space", () => run("space.rename")],
  ["<", "move tab left", () => moveTab(-1)],
  [">", "move tab right", () => moveTab(1)],
  ["|", "split right", () => run("pane.split", { direction: "right" })],
  ["-", "split down", () => run("pane.split", { direction: "down" })],
  ["h", "focus left", () => run("pane.go", { direction: "left" })],
  ["j", "focus down", () => run("pane.go", { direction: "down" })],
  ["k", "focus up", () => run("pane.go", { direction: "up" })],
  ["l", "focus right", () => run("pane.go", { direction: "right" })],
  ["z", "zoom pane", () => run("pane.zoom")],
  ["x", "close pane", closePane],
  ["f", "fork Claude into a tab", fork],
  ["W", "new worktree", () => worktree("new", 280)],
  ["O", "open worktree", () => worktree("open", 480)],
  ["s", "sidebar: agents", () => spotlight("my-agents")],
  ["w", "sidebar: spaces", focusSpaces],
  ["S", "sidebar: spaces", focusSpaces],
  ["b", "toggle sidebar", () => run("layout.toggle", { id: "sidebar" })],
  ["{", "sidebar narrower", () => resizeSidebar(-SIDEBAR_STEP)],
  ["}", "sidebar wider", () => resizeSidebar(SIDEBAR_STEP)],
  ["a", "next agent needing you", nextAttention],
  ["g", "find tab / space / agent", () => run("mod.open", { name: "picker" })],
  ["/", "search terminal", () => run("terminal.search")],
  ["G", "lazygit", () => run("floats.lazygit")],
  ["d", "hide window", () => run("app.hide")],
  ["?", "all keys", () => run("app.help")],
  ["C-a", "send ctrl-a", sendCtrlA],
];

const ARROWS = { left: "h", down: "j", up: "k", right: "l" };

const same = (a, b) => a?.space === b?.space && a?.tab === b?.tab;
const activeSpace = () => spaces().find((s) => s.id === focused()?.space) ?? spaces().find((s) => s.active);

// The newest tab in the history that still exists and isn't the shown one.
function lastTab() {
  const live = new Set(spaces().flatMap((s) => s.tabs.map((t) => `${s.id} ${t.id}`)));
  const now = focused();
  const page = [...(shared("tabs.history") ?? [])]
    .reverse()
    .find((p) => live.has(`${p.space} ${p.tab}`) && !same(p, now));
  if (!page) return;
  if (page.space !== now?.space) run("space.select", { id: page.space });
  run("tab.select", { id: page.tab });
}

function moveTab(by) {
  const space = activeSpace();
  const i = space?.tabs.findIndex((t) => t.id === focused()?.tab) ?? -1;
  const to = i + by;
  if (i < 0 || to < 0 || to >= space.tabs.length) return;
  run("tab.move", { id: space.tabs[i].id, index: to + 1 });
}

// Asks first while an agent in the pane is busy, as paddock does.
function closePane() {
  const pane = panes().find((p) => p.pane === focused()?.pane);
  if (!pane) return;
  if (pane.status === "working" || pane.status === "blocked") {
    openOverlay({
      mod: "confirm",
      kind: "dialog",
      width: 380,
      height: 160,
      props: { title: "Close pane?", detail: "An agent is running in it.", command: { name: "pane.close", args: { pane: pane.pane } } },
    });
  } else run("pane.close", { pane: pane.pane });
}

// ponytail: --continue forks the newest Claude session in that folder, which is the
// focused one unless two Claude sessions share a folder.
function fork() {
  const pane = panes().find((p) => p.pane === focused()?.pane);
  if (!pane?.cwd || !(pane.program?.key === "claude" || pane.app === "claude-code")) {
    return notify({ title: "Fork: focus a Claude Code pane first", level: "warning", timeout: 4000 });
  }
  run("tab.new", { folder: pane.cwd, argv: ["claude", "--continue", "--fork-session"] });
}

function worktree(action, height) {
  const space = activeSpace();
  if (!space) return;
  openOverlay({
    mod: "worktree",
    kind: "dialog",
    width: action === "new" ? 460 : 560,
    height,
    props: { space: space.id, folder: focused()?.cwd ?? undefined, action },
  });
}

// Gives a sidebar list the keyboard (my-spaces / my-agents, in the paddock layout).
function spotlight(mod) {
  run("layout.show", { id: "sidebar" });
  run(`${mod}.spotlight`);
}

function focusSpaces() {
  run("layout.show", { id: "spaces" });
  spotlight("my-spaces");
}

function findNode(node, id) {
  if (!node || typeof node !== "object") return null;
  if (node.id === id) return node;
  for (const child of node.children ?? []) {
    const found = findNode(child, id);
    if (found) return found;
  }
  return null;
}

function resizeSidebar(by) {
  const node = findNode(layout(), "sidebar");
  const width = node?.size?.px ?? 268;
  const px = Math.max(node?.min ?? 44, Math.min(node?.max ?? 480, width + by));
  run("layout.resize", { id: "sidebar", px });
}

// Blocked agents first, then done ones; starts after the one shown, so
// pressing it again walks through them.
function nextAttention() {
  const all = agents();
  const want = [...all.filter((a) => a.status === "blocked"), ...all.filter((a) => a.status === "done")];
  if (!want.length) return;
  const at = want.findIndex((a) => a.address === focused()?.terminal);
  run("agent.focus", { terminal: want[(at + 1) % want.length].address });
}

function sendCtrlA() {
  const terminal = focused()?.terminal;
  if (terminal) hc(["keys", terminal, "ctrl+a"]);
}

function action(e) {
  if (e.keystroke === "ctrl-a") return sendCtrlA;
  const key = ARROWS[e.key] ?? e.key_char ?? e.key;
  if (/^[1-9]$/.test(key)) return () => run("tab.select", { index: Number(key) });
  return KEYS.find(([k]) => k === key)?.[2] ?? null;
}

export default class Leader extends View {
  init(_props, cx) {
    this.handle = cx.focus_handle();
    this.handle.focus();
    cx.timer.after(100, () => this.handle.focus());
    // GPUI's own Tab binding moves focus to the next tab stop (e.g. the
    // changes panel's commit input) before on_key_down sees the key. A
    // binding scoped to this popup's key context wins over that one.
    cx.bind_keys([{ keystroke: "tab", action: "leader_last", context: "Leader" }]);
  }

  fire(fn) {
    if (this.fired) return;
    this.fired = true;
    closeOverlay(props().overlay);
    fn?.();
  }

  render() {
    const t = theme();
    const row = ([key, label]) =>
      h_flex()
        .w(190)
        .h(22)
        .gap(8)
        .items_center()
        .child(div().w(34).flex_none().text_color(t.accent).font_semibold().child(key))
        .child(div().flex_1().truncate().text_color(t.muted).child(label));
    return v_flex()
      .id("leader")
      .key_context("Leader")
      .on_action("leader_last", () => this.fire(lastTab))
      .track_focus(this.handle)
      .on_key_down((e, cx) => {
        // Modifier presses alone (the shift of `C`) wait for the real key.
        if (["shift", "control", "alt", "platform", "function"].includes(e.key)) return;
        cx.stop_propagation();
        this.fire(action(e));
      })
      .size_full()
      .p(14)
      .gap(10)
      .rounded(10)
      .bg(t.popover)
      .text_size(12)
      .child(
        h_flex()
          .items_center()
          .child(div().flex_1().text_size(13).font_semibold().text_color(t.foreground).child("C-a"))
          .child(div().text_size(11).text_color(t.dim).child("Esc")),
      )
      .child(h_flex().flex_wrap().gap_x(8).children(KEYS.map(row)));
  }
}
