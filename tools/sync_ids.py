#!/usr/bin/env python3
"""
sync_ids.py — Sync dungeon IDs from the in-game KwikTip SavedVariable into DungeonData.lua.

HOW THE DATA GETS CAPTURED (no manual /run typing required):
  The addon already logs every dungeon you enter (when debug logging is on):
    /kwik debuglog          -- toggles map/mob ID logging to SavedVariables
Core.lua writes KwikTipCNDB.mapIDLog entries containing:
    { mapID=..., instanceID=..., instanceName="Kings' Rest", subzone=..., ... }
  So to populate a new season's IDs you simply RUN each dungeon once with
  debuglog enabled, then run this script. No in-game /run commands per dungeon.

USAGE:
  # Dry run — show what WOULD change (safe, writes nothing):
  python3 tools/sync_ids.py --savedvar ~/.wine/.../KwikTip.lua

  # Apply the changes to DungeonData.lua:
  python3 tools/sync_ids.py --savedvar ~/.wine/.../KwikTip.lua --apply

  # Point at a specific data file (default: DungeonData.lua next to this script):
  python3 tools/sync_ids.py --savedvar path/to/KwikTip.lua --data path/to/DungeonData.lua --apply

MATCHING:
  Entries are matched by exact (case-insensitive) instanceName from the log
  against the dungeon `name` field in DungeonData.lua. Only fields currently
  set to 0 are filled; existing values are never overwritten.

NOTES:
  - This removes the per-season manual ID lookup entirely. The only human step
    is running each dungeon once (or reading the rotation list to know which
    dungeons to queue). Tip CONTENT still requires reading guides.
  - instanceID values found in the log come from GetInstanceInfo() — the same
    source the addon uses for primary detection, so they are authoritative.
"""

import sys
import os
import re

HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_DATA = os.path.join(HERE, "..", "DungeonData.lua")


def parse_savedvariable(path):
    """Extract mapIDLog entries: list of dicts with mapID, instanceID, instanceName.

    The SavedVariable uses Lua nested tables: mapIDLog = { { ... }, { ... } }.
    We locate the `mapIDLog = {` opener, then brace-match to its closing `}`, then
    parse each top-level `{ ... }` record inside.
    """
    with open(path, "r", encoding="utf-8", errors="replace") as f:
        text = f.read()

    start = text.find("mapIDLog")
    if start < 0:
        return []
    eq = text.find("{", start)
    if eq < 0:
        return []
    # brace-match from the first '{' after mapIDLog
    depth = 0
    end = -1
    for i in range(eq, len(text)):
        if text[i] == "{":
            depth += 1
        elif text[i] == "}":
            depth -= 1
            if depth == 0:
                end = i
                break
    if end < 0:
        return []
    body = text[eq + 1:end]

    records = []
    # Top-level records are balanced {...} blocks (may contain no nested braces here)
    i = 0
    while i < len(body):
        if body[i] == "{":
            depth = 0
            j = i
            while j < len(body):
                if body[j] == "{":
                    depth += 1
                elif body[j] == "}":
                    depth -= 1
                    if depth == 0:
                        block = body[i + 1:j]
                        rec = {}
                        # WoW writes QUOTED keys:  ["mapID"] = 2514
                        # but some fields/logs may use bareword keys:  mapID = 2514
                        # Values may be quoted strings ("Den of Nalorakk") or bare (2514).
                        for key, val in re.findall(
                            r'\[?"?(\w+)"?\]?\s*=\s*("(?:[^"\\]|\\.)*"|\[?[^\],}]+]?)', block
                        ):
                            if val.startswith('"'):
                                val = val[1:-1]
                            else:
                                val = val.strip().strip('"')
                            rec[key] = val
                        if "instanceName" in rec:
                            records.append(rec)
                        i = j + 1
                        break
                j += 1
            else:
                break
        else:
            i += 1
    return records


def build_id_map(records):
    """instanceName -> (instanceID, mapID) using the latest non-zero values."""
    out = {}
    for r in records:
        name = r.get("instanceName", "").strip().strip('"')
        if not name:
            continue
        iid = r.get("instanceID")
        uid = r.get("mapID")
        iid = int(iid) if (iid and iid.isdigit() and int(iid) != 0) else None
        uid = int(uid) if (uid and uid and str(uid).isdigit() and int(uid) != 0) else None
        if name not in out:
            out[name] = {"instanceID": None, "uiMapID": None}
        if iid:
            out[name]["instanceID"] = iid
        if uid:
            out[name]["uiMapID"] = uid
    return out


def fill_data(data_path, id_map, apply):
    with open(data_path, "r", encoding="utf-8") as f:
        lines = f.readlines()

    out = []
    cur_name = None
    in_block = False
    changed = []
    for line in lines:
        # Dungeon entries open with a bare '{' on its own line; name follows.
        if re.match(r"^\s*\{\s*$", line):
            in_block = True
            cur_name = None
        nm = re.search(r'name\s*=\s*"([^"]+)"', line)
        if nm and in_block and cur_name is None:
            cur_name = nm.group(1)

        im = re.match(r"(\s*)instanceID\s*=\s*0\s*,?\s*(.*)", line)
        if im and cur_name:
            key = cur_name.lower()
            match = next((k for k in id_map if k.lower() == key), None)
            if match and id_map[match]["instanceID"]:
                new = '%sinstanceID = %d, -- synced from in-game log (%s)\n' % (
                    im.group(1), id_map[match]["instanceID"], match)
                if apply:
                    line = new
                changed.append((cur_name, "instanceID", id_map[match]["instanceID"], apply))

        um = re.match(r"(\s*)uiMapID\s*=\s*0\s*,?\s*(.*)", line)
        if um and cur_name:
            key = cur_name.lower()
            match = next((k for k in id_map if k.lower() == key), None)
            if match and id_map[match]["uiMapID"]:
                new = '%suiMapID = %d, -- synced from in-game log (%s)\n' % (
                    um.group(1), id_map[match]["uiMapID"], match)
                if apply:
                    line = new
                changed.append((cur_name, "uiMapID", id_map[match]["uiMapID"], apply))

        if re.match(r"\s*\},?\s*$", line) and in_block:
            in_block = False
            cur_name = None

        out.append(line)

    if apply and changed:
        with open(data_path, "w", encoding="utf-8") as f:
            f.writelines(out)
    return changed


def main():
    args = sys.argv[1:]
    savedvar = None
    data = os.path.normpath(DEFAULT_DATA)
    apply = False
    i = 0
    while i < len(args):
        a = args[i]
        if a == "--savedvar":
            savedvar = args[i + 1]; i += 2
        elif a == "--data":
            data = args[i + 1]; i += 2
        elif a == "--apply":
            apply = True; i += 1
        else:
            i += 1

    if not savedvar:
        print("ERROR: --savedvar <path to KwikTip.lua SavedVariable> is required")
        print("Typical location: <WoW>/WTF/Account/<acct>/SavedVariables/KwikTip.lua")
        sys.exit(1)
    if not os.path.exists(savedvar):
        print(f"ERROR: savedvar not found: {savedvar}")
        sys.exit(1)
    if not os.path.exists(data):
        print(f"ERROR: data file not found: {data}")
        sys.exit(1)

    records = parse_savedvariable(savedvar)
    id_map = build_id_map(records)
    if not id_map:
        print("[!] No mapIDLog entries found in SavedVariable. Run the dungeons once with /kwik debuglog on.")
        sys.exit(0)

    print("[*] Captured dungeons from log:")
    for name, ids in sorted(id_map.items()):
        print("    %-28s instanceID=%-6s uiMapID=%s" % (name, ids["instanceID"], ids["uiMapID"]))

    changed = fill_data(data, id_map, apply)
    if not changed:
        print("[done] No dungeons with 0-valued IDs matched the log. Nothing to do.")
    else:
        verb = "WOULD FILL" if not apply else "FILLED"
        print("[%s] %d field(s):" % (verb, len(changed)))
        for name, fld, val, _ in changed:
            print("    %-28s %-10s -> %d" % (name, fld, val))
        if not apply:
            print("\n(re-run with --apply to write changes)")


if __name__ == "__main__":
    main()
