# Paddock

Paddock is the Herdr (main) window with the keyboard habits of a tmux setup
added. Press `⌃A` in a terminal and a key sheet drops from the top; the next key
runs its action. That action can be a new tab, a split, a pane move, a Claude
fork, a worktree, or lazygit floating over the window. The spaces and agents
lists in the sidebar take the keyboard (j/k, Enter, Esc). The spaces list also
shows each branch's GitHub PR and its check result. A strip at the right end of
the status bar reads `⌃A  paddock`, and paddock's short notices appear there.

![Paddock](preview.png)

## What you see

- **The window** looks like Herdr (main): a 268px sidebar, then the tab bar,
  the panes and the right panels. There is one change at the bottom: the 28px
  status row is split. On the left is the shipped `workspace-status`. On the
  right is a 260px paddock strip: `chrome` background, a top border in
  `border`, 11.8px text, right-aligned, 12px horizontal padding. It shows
  `⌃A  paddock` in `dim`. It shows a notice in `foreground` for 4 s, then the
  text goes back.
- **The prefix sheet** is a popup at the top of the window, 40px down,
  600×500. It has a `popover` background, 16px padding, and 12.5px text. Its
  header reads `⌃A  then` (semibold) with `Esc cancels` on the right (11px,
  `dim`). Below the header are two columns of 22px rows. Each row shows the key
  in `accent`, semibold, 34px wide, and then what it does in `muted`. There are
  35 entries, in this order: `c` new tab, `C` new space, `n`/`p` next/previous
  tab, `tab` and `;` last space and tab, `1-9` go to tab N, `,` rename tab, `$` rename
  space, `<`/`>` move tab left/right, `|`/`-` split side by side / top and
  bottom, `h j k l` focus left/down/up/right, `z` zoom split, `x` close split (asks if an agent runs),
  `f` fork Claude into a tab, `W`/`O` new/open worktree, `s`/`w` (and `S`) focus
  agents/spaces list, `b` show or hide sidebar, `{`/`}` sidebar
  narrower/wider, `a` next session needing you, `g` find a space, tab or
  agent, `/` search the history, `G` lazygit float, `d` hide the window,
  `?` all keys, `⌃A` send ⌃A to the program.
- **The lazygit float** is a modal dialog of 80%×80% holding one live
  terminal.
- **The sidebar lists** look like the shipped Spaces and Agents lists, with
  two additions. The row under the keyboard cursor gets a 1px `accent` border.
  A space whose branch has a PR shows `#N` and a mark after its branch:
  - `✓` when all checks passed;
  - `✗` when any check failed;
  - `•` when checks are pending or mixed;
  - nothing extra when there are no checks;
  - `merged` or `closed` when the PR is merged or closed.

  The `#N` and mark are in `blocked` for `✗`, in `ansi2` for `✓`, and in `dim`
  otherwise.

## How it behaves

- **The `⌃A` sheet** opens from a terminal only (`keys.json` `terminal`
  section). The next key closes the sheet and runs its action. Bare modifier
  presses are ignored. An unknown key just closes the sheet. Arrow keys act
  like `h j k l`, and `1`–`9` select tab N.
- **Direct keys work without the prefix:**
  - in terminals: `⌃⌥C` new tab, `⌃\` / `⌃-` split right/down, `⌃H/J/K/L`
    focus left/down/up/right;
  - anywhere: `⌘⇧,` / `⌘⇧.` move tab, `⌘⌥,` / `⌘⌥.` sidebar −/+40px (44–480),
    `⌘⇧A` next session needing you, `⌘;` last tab, `⌘⇧F` fork, `⌘⇧N` / `⌘⇧O`
    worktrees, `⌘⌥S` / `⌘⌥W` focus agents/spaces, `⌘⇧G` lazygit.
- **Agent status** is drawn by the shipped agents/spaces code and is left
  unchanged. "Next session needing you" cycles through `blocked` agents first,
  then `done` ones, starting after the focused agent and wrapping around. With
  none, the strip says `no session needs you`.
- **Last tab** goes back to the space and tab shown before the current one.
  This is tracked while the strip renders. Before any switch, it says
  `no last tab`.
- **Fork** needs a focused Claude Code pane (program `claude` or app
  `claude-code`). It opens a new tab in that pane's folder running
  `claude --continue --fork-session`. Otherwise the strip says
  `fork: focus a Claude Code pane first`.
- **New/Open worktree** opens the shipped `worktree` dialog with
  `{space, folder, action}`. `new` is 460×280, `open` is 560×480.
- **Focus spaces/agents** shows the sidebar (and, for spaces, the spaces
  block). After 120 ms it sends the clone `focus`; the cursor starts on the
  current row.
  - `j`/`↓` and `k`/`↑` move the cursor. Past the last space, `j` moves into
    the agents list; above the first agent, `k` moves back into spaces.
  - Enter selects the space and focuses its pane, or focuses the agent's pane.
  - `x` closes the space, or the agent's pane after a confirm dialog.
  - `W` / `o` open the new/open worktree dialog for that row.
  - `Esc` returns to the pane that had the keyboard. The cursor shows only
    while the list holds the keyboard.
- **`⌃A x`** closes the focused pane at once, or asks first ("Close pane?")
  when its agent is `working` or `blocked`.
- **`⌃A ⌃A`** sends one ⌃A to the focused terminal (`hc keys <t> ctrl+a`).
- **The lazygit float**:
  - `G` toggles one float per space. If none is running, it starts
    `hc run --bg --json --no-parent --rm --cwd <focused pane's folder> [--on <machine>] -- lazygit`
    and shows it.
  - `G` again hides it and refocuses the pane underneath. The terminal keeps
    running, and the next `G` shows the same lazygit.
  - Quitting lazygit removes the terminal, so the next `G` starts a new one.
- **The PR mark** comes from `gh pr view --json number,state,statusCheckRollup`
  in each space's place.
  - Only branches other than `main`/`master` are checked.
  - The first check is 5 s after start, then every 60 s, one place at a time.
  - Nothing is checked while the window isn't active.
  - Without `gh`, or with no PR, there is no mark.

## Built from

- **Layout** `layouts/paddock.json`: `layout.clone {name:"main", as:"paddock"}`,
  then three changes:
  - block `spaces` content `{mod:"paddock-spaces"}`;
  - block `agents` content `{mod:"paddock-agents"}`;
  - `status` becomes
    `{"id":"status","type":"row","size":{"px":28},"resizable":false,"children":[{"id":"status-main","type":"block","content":{"mod":"workspace-status"}},{"id":"paddock","type":"block","size":{"px":260},"content":{"mod":"paddock"}}]}`.
- **`mods/paddock`** (`{"place":"none"}`) is the hub. A `nextCommand()` loop
  handles these commands:
  - `move_tab_left|right`: `tab.move {id, index}`, kept within 1..tab count;
  - `sidebar_narrower|wider`: `layout.show` + `layout.resize {id:"sidebar", px}`;
  - `next_attention`: `agent.focus {terminal}`;
  - `last_page`: `space.select` + `tab.select`;
  - `fork`: `tab.new {folder, argv}`;
  - `new_worktree|open_worktree`: `openOverlay({mod:"worktree", kind:"dialog", props})`;
  - `focus_agents|focus_spaces`: `layout.show sidebar`, then
    `run("<clone>.focus")`;
  - `float_<key>`: `FLOATS = {G:["lazygit"]}`; add entries for more floats.

  Float state is kept in `shared("paddock.floats")`, keyed `"<space>:<key>"`,
  holding `{terminal, overlay, back, boot}`. The overlay is
  `openOverlay({kind:"dialog", modal:true, width:0.8, height:0.8, layout:{type:"column", children:[{type:"block", content:{terminal}}]}})`.
  Errors from any command show in the strip as `paddock: <message>`.
- **`mods/paddock-prefix`** is set up by `mod.json`:
  `{"place":"none","overlay":{"kind":"popup","at":"top","offset":40,"width":600,"height":470}}`.
  It is opened by `mod.open:paddock-prefix`. A `KEYS` table of
  `[key, label, [command, args]]` draws the sheet and dispatches keys. Keys
  are matched on `key_char` first (so `<`, `|` and `{` work on any layout),
  then on `keystroke` for `ctrl-a` and the arrows. `Tab` never reaches
  `on_key_down` (the window takes it to move focus), so `keys.json` binds it
  in `"mod:paddock-prefix": {"tab": "paddock-prefix.key_tab"}` and the popup's
  `nextCommand()` loop runs it.
- **`mods/paddock-spaces`, `mods/paddock-agents`**: `mod.clone` of the shipped
  `spaces` and `agents` (0.1.14), with `"focusable": true`. Both share an
  identical `spotlight.js`: a `Spotlight` class holding the focus handle, the
  rows in screen order, the cursor and the pane to return to. Its
  `nextCommand()` loop takes `"focus"`, `"spotlight"`, `"spotlight-first"` and
  `"spotlight-last"` (the last two hand the keyboard between the lists). The
  root gets `.track_focus(spot.handle).on_key_down(...)` with `open`, `close`
  and `worktree` actions. The agents clone defaults its sort to "Grouped by
  space". The spaces clone adds `refreshPrs` and a `pr` argument to `gitTail`.
- **Hub commands** also include `close_pane` (confirm via the shipped
  `confirm` dialog with `{title, detail, command}`) and `send_ctrl_a`.
- **Look**: `themes/solarized.json` (Solarized dark) set as `settings.json`
  `theme`, with `font_size: 16`.
- **`keys.json`**: the entries listed under How it behaves. The `terminal`
  section holds `ctrl-a`, `ctrl-alt-c`, `ctrl-\`, `ctrl--` and `ctrl-h/j/k/l`.
  The `global` section holds the `cmd-…` ones as `paddock.<command>`.
- **Programs**: `lazygit`, `gh`, `claude`, and `hc`, which Herdr runs.

## Watch out

- `<mod>.<command>` reaches shown copies only. That is why the hub lives in
  the always-visible status row and not as an overlay. Every `paddock.*` key
  does nothing in any other layout.
- Command names can't contain `:`, because `paddock.float:G` parses as an
  argument. Use `float_G`.
- `pane.focus` can't target an overlay terminal ("no such pane"). Click the
  float once before typing.
- A mod reload wipes instance fields, so float state lives in `shared`.
  `shared` survives an app restart but overlay ids don't. Each float records
  `globalThis.paddockBoot` and is trusted only when that value matches.
- `hc` reports Claude as app `claude-code`, not program key `claude`. Accept
  either one.
- Binding `ctrl-a/h/j/k/l` takes start-of-line, Backspace, newline, kill-line
  and clear away from programs. `⌃A ⌃A` sends a literal `⌃A`.
- `--continue` forks the newest Claude session in the folder. That is the
  wrong session if two Claude sessions share a folder.
- The clones and the layout don't follow Herdr's updates to `spaces`, `agents`
  or `main`.

## Done when

- `herdr-app check` passes for `mods/paddock`, `mods/paddock-prefix`,
  `mods/paddock-spaces` and `mods/paddock-agents`, and `herdr-app status`
  shows `"errors": []` with the `paddock` layout shown.
- The status bar ends in `⌃A  paddock`.
- `herdr-app do paddock.sidebar_wider` widens the sidebar by 40px, and
  `sidebar_narrower` reverses it.
- With no blocked or done agents, `paddock.next_attention` shows
  `no session needs you`.
- `paddock.float_G` opens lazygit in an 80% modal. Running it again hides the
  float, and a third time shows the same terminal address.
- In a terminal, `⌃A` shows the sheet. `⌃A c` opens a tab, and `⌃A Esc` does
  nothing.
- `⌃A w`, then `j` and Enter, selects the next space. `Esc` returns to the
  terminal.
- A space on a branch with an open PR shows `#N` and a mark within about a
  minute.
