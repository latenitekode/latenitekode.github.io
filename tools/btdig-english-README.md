# BTDig English UI userscript

A client-side English UI layer for the current BTDig website.

## Why this exists

`en.btdig.com` historically served English, but in July 2026 it began serving Korean and the English choice disappeared from the language selector. The public `btdig/dhtcrawler2` repository does not contain the current production frontend; its old `src/www` frontend is already English. There is therefore no public production locale file to patch upstream today.

## What it does

- translates buttons, labels, placeholders, menus, sorting and pagination controls
- translates short result metadata such as file/date/size wording
- handles UI inserted dynamically after page load
- leaves normal torrent-result links, search terms and magnet URLs alone
- caches translations locally so the same UI string is not repeatedly requested

## Install

1. Install Tampermonkey or Violentmonkey.
2. Open `tools/btdig-english.user.js` from the `btdig-english` branch as a raw file.
3. Approve installation.
4. Visit BTDig normally; the UI is translated automatically.

## Privacy

Only short Korean UI strings selected by the script are sent to Google Translate's public translation endpoint. Search-box text, ordinary result/torrent titles and magnet URLs are intentionally excluded.

## Upstream status

The correct upstream fix is for BTDig to restore `en` in its current production frontend and map `en.btdig.com` explicitly to English. GitHub currently reports that issue creation is restricted in `btdig/dhtcrawler2`; the connected GitHub integration also receives HTTP 403 when attempting to comment on or create issues there.
