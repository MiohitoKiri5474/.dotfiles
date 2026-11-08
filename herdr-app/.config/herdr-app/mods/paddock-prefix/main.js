// paddock's prefix: ctrl-a (keys.json, terminal section) opens this popup, the next key
// runs its action and closes it. Esc or a click outside cancels. The table it shows is the help.
// Actions: an app command [name, args] or a "paddock.<command>" handled by the paddock mod.

import { View, div } from "gpui-kit";
import { v_flex, h_flex } from "gpui-base";
import { run, props, closeOverlay, theme, nextCommand } from "herdr";

const KEYS = [
  ["c", "new tab", ["tab.new"]],
  ["C", "new space", ["space.new"]],
  ["n", "next tab", ["tab.next"]],
  ["p", "previous tab", ["tab.prev"]],
  ["tab", "last space and tab", ["paddock.last_page"]],
  [";", "last space and tab", ["paddock.last_page"]],
  ["1-9", "go to tab N", null],
  [",", "rename tab", ["tab.rename"]],
  ["$", "rename space", ["space.rename"]],
  ["<", "move tab left", ["paddock.move_tab_left"]],
  [">", "move tab right", ["paddock.move_tab_right"]],
  ["|", "split side by side", ["pane.split", { direction: "right" }]],
  ["-", "split top and bottom", ["pane.split", { direction: "down" }]],
  ["h", "focus left", ["pane.go", { direction: "left" }]],
  ["j", "focus down", ["pane.go", { direction: "down" }]],
  ["k", "focus up", ["pane.go", { direction: "up" }]],
  ["l", "focus right", ["pane.go", { direction: "right" }]],
  ["z", "zoom split", ["pane.zoom"]],
  ["x", "close split", ["pane.close"]],
  ["f", "fork Claude into a tab", ["paddock.fork"]],
  ["W", "new worktree", ["paddock.new_worktree"]],
  ["O", "open worktree", ["paddock.open_worktree"]],
  ["s", "focus agents list", ["paddock.focus_agents"]],
  ["w", "focus spaces list", ["paddock.focus_spaces"]],
  ["b", "show or hide sidebar", ["layout.toggle", { id: "sidebar" }]],
  ["{", "sidebar narrower", ["paddock.sidebar_narrower"]],
  ["}", "sidebar wider", ["paddock.sidebar_wider"]],
  ["a", "next session needing you", ["paddock.next_attention"]],
  ["g", "find a space, tab or agent", ["mod.open", { name: "picker" }]],
  ["/", "search the history", ["terminal.search"]],
  ["G", "lazygit float", ["paddock.float_G"]],
  ["d", "detach (close window)", ["window.close"]],
  ["?", "all keys", ["app.help"]],
];
const ARROWS = { left: "h", down: "j", up: "k", right: "l" };
const BY_KEY = Object.fromEntries(KEYS.filter((k) => k[2]).map((k) => [k[0], k[2]]));
const REFOCUS_MS = 300;

export default class PaddockPrefix extends View {
  init(_props, cx) {
    this.handle = cx.focus_handle();
    this.handle.focus();
    cx.timer.after(REFOCUS_MS, () => this.handle.focus());
    // Tab never reaches on_key_down (the window takes it to move focus), so keys.json's
    // "mod:paddock-prefix" section binds it to "paddock-prefix.key_tab" instead.
    cx.spawn(async (cx) => {
      for (;;) {
        const c = await nextCommand();
        if (!c.startsWith("key_")) continue;
        const a = BY_KEY[c.slice(4)];
        closeOverlay(props().overlay);
        if (a) run(a[0], a[1] ?? {});
        cx.notify();
      }
    });
  }

  action(e) {
    const ch = e.key_char;
    if (ch && /^[1-9]$/.test(ch)) return ["tab.select", { index: Number(ch) }];
    if (ch && BY_KEY[ch]) return BY_KEY[ch];
    const k = e.keystroke;
    if (k === "tab" || e.key === "tab" || ch === "\t") return BY_KEY.tab;
    if (ARROWS[k]) return BY_KEY[ARROWS[k]];
    return null;
  }

  key(e, cx) {
    // Bare modifier presses aren't keys yet.
    if (["shift", "control", "alt", "platform", "function"].includes(e.key)) return;
    cx.stop_propagation();
    closeOverlay(props().overlay);
    const a = this.action(e);
    if (a) run(a[0], a[1] ?? {});
  }

  render() {
    const t = theme();
    const cell = ([k, what]) => h_flex().w_1_2().h(22).gap(10).items_center()
      .child(div().w(34).flex_none().text_color(t.accent).font_semibold().child(k))
      .child(div().min_w(0).truncate().text_color(t.muted).child(what));
    return v_flex().id("paddock-prefix").track_focus(this.handle).on_key_down((e, cx) => this.key(e, cx))
      .size_full().p(16).gap(10).bg(t.popover).text_color(t.foreground).text_size(12.5)
      .child(h_flex().justify_between().child(div().font_semibold().child("⌃A  then")).child(div().text_size(11).text_color(t.dim).child("Esc cancels")))
      .child(h_flex().flex_wrap().children(KEYS.map(cell)));
  }
}
