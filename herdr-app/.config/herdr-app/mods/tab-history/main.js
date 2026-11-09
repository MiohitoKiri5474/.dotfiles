// Remembers the tabs shown, oldest first, in shared "tabs.history" as
// [{ space, tab }], so the leader's `Tab` can go back to the last one, like
// paddock's `C-a Tab`. Lives in an invisible floating block of the layout:
// render() runs on every focus change. Closed tabs drop out of the list, so
// after closing the current tab `Tab` still toggles between the two before it.

import { View, div } from "gpui-kit";
import { focused, spaces, shared, setShared } from "herdr";

const KEY = "tabs.history";
const LIMIT = 32;

const same = (a, b) => a?.space === b?.space && a?.tab === b?.tab;

// The history with closed tabs left out and repeats squashed.
export function liveHistory() {
  const tabs = new Set(spaces().flatMap((s) => s.tabs.map((t) => `${s.id} ${t.id}`)));
  const out = [];
  for (const page of shared(KEY) ?? []) {
    if (!tabs.has(`${page.space} ${page.tab}`) || same(out.at(-1), page)) continue;
    out.push(page);
  }
  return out;
}

export default class TabHistory extends View {
  render() {
    const f = focused();
    const before = shared(KEY) ?? [];
    const now = liveHistory();
    if (f?.space && f?.tab && !same(now.at(-1), f)) now.push({ space: f.space, tab: f.tab });
    const kept = now.slice(-LIMIT);
    if (JSON.stringify(kept) !== JSON.stringify(before)) setShared(KEY, kept);
    return div();
  }
}
