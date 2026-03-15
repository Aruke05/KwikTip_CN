#!/usr/bin/env bash
# monitor_sources.sh — Daily check for KwikTip source updates
#
# Monitors YouTube RSS feeds and web pages for changes relevant to KwikTip tip content.
# Run via system cron; results appended to tools/.monitor/updates.md
#
# Setup (one-time):
#   chmod +x tools/monitor_sources.sh
#   crontab -e
#   Add: 0 9 * * * /home/postblink/Dev\ Projects/KwikTip/tools/monitor_sources.sh
#
# Read updates:
#   cat tools/.monitor/updates.md

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATE_DIR="$SCRIPT_DIR/.monitor/state"
REPORT="$SCRIPT_DIR/.monitor/updates.md"

mkdir -p "$STATE_DIR"

TIMESTAMP=$(date -u +"%Y-%m-%d %H:%M UTC")
NEW_ITEMS=0

# ── Helpers ──────────────────────────────────────────────────────────────────

log() { echo "[$(date +%H:%M:%S)] $*" >&2; }

append() { printf '%s\n' "$1" >> "$REPORT"; }

# ── YouTube RSS ──────────────────────────────────────────────────────────────
# YouTube exposes a plain-XML Atom feed per channel — no JS required.
# Feed URL: https://www.youtube.com/feeds/videos.xml?channel_id=CHANNEL_ID

check_youtube() {
    local name="$1"
    local channel_id="$2"
    local url="https://www.youtube.com/feeds/videos.xml?channel_id=${channel_id}"
    local state="$STATE_DIR/yt_${name}.xml"
    local tmp="$STATE_DIR/yt_${name}.tmp"

    log "Checking YouTube: $name"
    if ! curl -sf --max-time 15 "$url" -o "$tmp"; then
        log "WARN: Failed to fetch YouTube feed for $name"
        return
    fi

    if [[ -f "$state" ]]; then
        # Compare video IDs line by line; new ones are in tmp but not in state
        while IFS= read -r vid_id; do
            [[ -z "$vid_id" ]] && continue
            if ! grep -qF "$vid_id" "$state"; then
                local title published
                title=$(grep -A 20 "$vid_id" "$tmp" | grep -oP '(?<=<title>)[^<]+' | head -1)
                published=$(grep -A 20 "$vid_id" "$tmp" | grep -oP '(?<=<published>)[^<]+' | head -1)
                append "- **[YouTube/$name]** [${title}](https://youtu.be/${vid_id}) — ${published:0:10}"
                NEW_ITEMS=$((NEW_ITEMS + 1))
            fi
        done < <(grep -oP '(?<=<yt:videoId>)[^<]+' "$tmp")
    else
        append "- **[YouTube/$name]** Initial snapshot taken (${TIMESTAMP})"
    fi

    mv "$tmp" "$state"
}

# ── Web page hash check ───────────────────────────────────────────────────────
# Strips <script> and <style> blocks before hashing to reduce noise from
# analytics, ads, and nonces that change on every request.

check_page() {
    local name="$1"
    local url="$2"
    local slug
    slug=$(printf '%s' "$name" | tr '/ ' '__')
    local state="$STATE_DIR/page_${slug}.hash"
    local tmp="$STATE_DIR/page_${slug}.tmp"

    log "Checking page: $name"

    local http_code
    http_code=$(curl -s --max-time 20 -o "$tmp" -w "%{http_code}" "$url")

    if [[ "$http_code" == "404" ]]; then
        # Page not yet published — skip silently; will be picked up once it appears
        rm -f "$tmp"
        return
    elif [[ "$http_code" != "200" ]]; then
        log "WARN: HTTP $http_code for $name"
        rm -f "$tmp"
        return
    fi

    # Strip volatile blocks then hash
    local new_hash
    new_hash=$(
        sed 's/<script[^>]*>.*<\/script>//g; s/<style[^>]*>.*<\/style>//g' "$tmp" \
        | md5sum | cut -d' ' -f1
    )

    if [[ -f "$state" ]]; then
        local old_hash
        old_hash=$(cat "$state")
        if [[ "$new_hash" != "$old_hash" ]]; then
            append "- **[Web/$name]** Content changed — <${url}>"
            NEW_ITEMS=$((NEW_ITEMS + 1))
        fi
    else
        append "- **[Web/$name]** Initial snapshot taken (${TIMESTAMP})"
    fi

    printf '%s' "$new_hash" > "$state"
    rm -f "$tmp"
}

# ── Run ───────────────────────────────────────────────────────────────────────

append ""
append "## ${TIMESTAMP}"

# YouTube channels
# Tactyks: author of method.gg dungeon guides; YouTube is upstream of the written text
check_youtube "Tactyks" "UC_0qsnA6yJ_DzEvKsm-XdvQ"

# Quazii: NOTE — quit WoW in January 2026 (addon plagiarism drama).
# Keeping entry here in case he returns; comment out if noise becomes a problem.
# check_youtube "Quazii" "UCXEvcv2LXzaaWJCKDPGQs8g"

# method.gg — M+ dungeon guides (written by Tactyks)
check_page "method/windrunner-spire"           "https://www.method.gg/guides/dungeons/windrunner-spire"
check_page "method/magisters-terrace"          "https://www.method.gg/guides/dungeons/magisters-terrace"
check_page "method/maisara-caverns"            "https://www.method.gg/guides/dungeons/maisara-caverns"
check_page "method/nexus-point-xenas"          "https://www.method.gg/guides/dungeons/nexus-point-xenas"
check_page "method/algethar-academy"           "https://www.method.gg/guides/dungeons/algethar-academy"
check_page "method/pit-of-saron"               "https://www.method.gg/guides/dungeons/pit-of-saron"
check_page "method/seat-of-the-triumvirate"    "https://www.method.gg/guides/dungeons/seat-of-the-triumvirate"
check_page "method/skyreach"                   "https://www.method.gg/guides/dungeons/skyreach"

# Icy Veins — non-M+ dungeons (primary source for Murder Row, DoN, TBV, VA)
# Individual pages not yet published as of March 2026; 404s are skipped silently
# and will auto-detect when Icy Veins eventually publishes them.
check_page "icyveins/murder-row"               "https://www.icy-veins.com/wow/murder-row-dungeon-guide"
check_page "icyveins/den-of-nalorakk"          "https://www.icy-veins.com/wow/den-of-nalorakk-dungeon-guide"
check_page "icyveins/blinding-vale"            "https://www.icy-veins.com/wow/the-blinding-vale-dungeon-guide"
check_page "icyveins/voidscar-arena"           "https://www.icy-veins.com/wow/voidscar-arena-dungeon-guide"

if [[ $NEW_ITEMS -eq 0 ]]; then
    append "  _(no changes detected)_"
fi

log "Done. $NEW_ITEMS new item(s) detected."
