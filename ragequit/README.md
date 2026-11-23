# Rage Quit Button: Apex Legends Edition

> **My aim was questionable. My exit strategy was immaculate.**
>
> Update: now I can queue for the next match with the very same broken mouse.

A well-commented **Logitech G HUB Lua** controller for the Logitech G102 LIGHTSYNC. The primary left mouse button was broken, so we taught Lua to perform two Apex Legends menu chores for us.

**Blog:** https://latenitekode.github.io/ragequit/

## Download

**[Get the complete, updated ragequit.lua](./ragequit.lua)**

## Two actions

| Trigger | Action |
| --- | --- |
| **Right-click (Lua button 2)** | Escape -> Tab -> Enter -> move to YES -> hold left-click once |
| **DPI button (candidate Lua button 6)** | Move to READY -> hold left-click once -> ignore repeat DPI triggers for 4 seconds |

**READY changing to CANCEL means you entered matchmaking.** That is success, not an error. Clicking that button again can cancel the queue. The Lua cooldown helps prevent accidental double triggers, but does not inspect the game to determine whether matchmaking is active.

**DPI compatibility note:** Not every G102 / G HUB configuration exposes the DPI switch as Lua mouse button 6. Inspect G HUB's scripting console to identify the actual event, and change the assigned trigger if necessary.

## Setup

1. Open **Logitech G HUB** and select your G102's correct profile.
2. **Disable On-Board Memory Mode** so the software script can run.
3. Open **Lua Scripting**, paste the entire [ragequit.lua](./ragequit.lua) file, save it, and activate it.
4. Keep G HUB running. This advanced Lua behavior is not stored on the mouse itself.
5. Set `ENABLE_FINAL_CLICK = false` first to test cursor positioning; turn it on only after confirming the targets.
6. Verify that the DPI button logs button 6 (or configure it to generate a detected event). Do **not** also map that button to a separate left-click macro, which may cause an additional click outside Lua's control.

## Configuration reference

All values are explained with comments directly in the Lua script.

| Setting | Default | Purpose |
| --- | --- | --- |
| `LOBBY_TRIGGER` | `2` | Literal right mouse button |
| `READY_TRIGGER` | `6` | DPI button, if exposed as Lua event 6 |
| `ENABLE_LOBBY` | `true` | Enable Return to Lobby |
| `ENABLE_READY` | `true` | Enable the READY action |
| `ENABLE_FINAL_CLICK` | `true` | Allow the simulated confirmation click |
| `MOUSE_HOLD_MS` | `150` | Duration of a **single** left-click |
| `READY_COOLDOWN_MS` | `4000` | Ignore repeated READY triggers for 4 seconds |
| `YES_X, YES_Y` | `29800, 44750` | Leave Match YES button |
| `READY_X, READY_Y` | `32768, 58700` | Main lobby READY button |

The coordinates are **Logitech normalized values (0–65535)**, calibrated using a **1920x1080 primary display**. They are not pixel positions, and multi-monitor setups may need adjustment.

Lua's correct Escape key name is `"escape"`, not `"esc"`. Keyboard keys are held for `KEY_HOLD_MS = 100` rather than tapped instantaneously.


## Why our first Lua scripts did not work

This is the **actual troubleshooting history** for the Logitech G102 LIGHTSYNC / G HUB / Apex Legends setup. The early failures *looked* like Apex was ignoring Lua, but the evidence pointed to bugs in our scripts and configuration, not a confirmed game-level Lua block.

| Symptom | What we learned | Working fix |
| --- | --- | --- |
| Literal right-click only opened the Windows context menu, and nothing ran. | We initially used mouse button **3**. The G HUB output console showed **`MOUSE_BUTTON_PRESSED | Button: 2`** for the physical right-click. The ordinary context menu appearing is expected because Lua doesn't automatically suppress the original click. | Use `LOBBY_TRIGGER = 2`. Read the **actual button ID** from the Lua console instead of assuming it. |
| Console printed **`TRIGGER DETECTED`** but Escape had no effect even outside Apex. | Our early scripts used **`"esc"`** as the key name. Separately, a Caps Lock Lua test changed the Caps Lock state, proving G HUB Lua could send at least some keyboard input to Windows. | Use **`"escape"`** with `PressKey`, `Sleep(100)`, and `ReleaseKey`. After this correction, Escape worked in Apex. |
| Escape worked but Tab, Enter, and the rest did not. | The diagnostic version was intentionally configured with `TEST_ONLY_ESCAPE = true` and a `return` immediately after Escape. | The released version executes the **full** Escape -> Tab -> Enter sequence with no test-mode early return. |
| Cursor reached YES but nothing was clicked. | An earlier test had `ENABLE_FINAL_CLICK = false`; when clicking was later enabled, a very quick simulated click was not reliably registering. | Set `ENABLE_FINAL_CLICK = true` after testing. Use **`PressMouseButton(1) -> Sleep(150) -> ReleaseMouseButton(1)`** for one held click. |
| The cursor missed the confirmation button. | Our first YES coordinates were incorrect for the user's actual game menu. | Use the calibrated Logitech **normalized** coordinates: YES `(29800, 44750)`, READY `(32768, 58700)`, on the original 1920x1080 display. These are *not pixel coordinates*. |
| Clicking READY seemed to cancel matchmaking. | **READY -> CANCEL** is the normal visual result when matchmaking starts. Another click can then cancel it. Duplicate Lua triggers or a second G HUB button assignment could cause unwanted clicks. | Perform one 150ms held click; apply `READY_COOLDOWN_MS = 4000` via `GetRunningTime()`, recording `lastReadyTime` **before** the click. The cooldown is not actual game-state detection. |

### Did Apex actually reject our first Lua inputs?

**We cannot conclude that.** `OutputLogMessage("MACRO TRIGGERED")` only confirms that Lua received the mouse event and entered the handler. It does **not** confirm the game received simulated input. We established that Lua could toggle Caps Lock in Windows and that correcting the key name from `"esc"` to **`"escape"` made Escape work in Apex**. The other failures involved a wrong trigger number, intentional test switches, unsuitable cursor coordinates, and too-short clicks. These are sufficient explanations without inventing an anti-cheat rejection.

**Separate fact:** In this particular setup, Apex displayed a launch warning when AutoHotkey was running. Therefore this project uses Logitech G HUB Lua, not AutoHotkey. That does not guarantee future compatibility or game-rule compliance.

### AI modification caution (read before asking an AI to edit)

Do **not** rewrite the working script from memory or silently "simplify" its working input handling. Preserve these tested details:

- **Right-click is G HUB Lua mouse button `2`**, not `3`. DPI = candidate `6` **only if G HUB actually detects it**. Button numbering must be verified from the Lua output log.
- **Escape key name is `"escape"`**, never `"esc"`. Use `PressKey -> Sleep -> ReleaseKey` with a **100ms key hold**.
- Use a **single 150ms held left-click** rather than replacing it with a fast `PressAndReleaseMouseButton(1)`. Keep `ENABLE_FINAL_CLICK = true` in the final working version unless the user wants cursor-only testing.
- Preserve the sequential waits (`MENU_DELAY = 350`, `TAB_DELAY = 200`, `CONFIRM_DELAY = 800`, `YES_SETTLE_MS = 500`, `READY_SETTLE_MS = 500`) and coordinates unless specifically recalibrating.
- Preserve READY's **4-second cooldown** and its timestamp update **before** clicking. Do not mistake READY -> CANCEL for a failure; check for duplicate G HUB assignments.
- Keep **all user-adjustable settings explained as inline Lua comments**. Always provide the **entire revised script**, not changed lines alone.
- Do not claim an event log proves Windows or Apex received a simulated key. Don't claim the automation is anti-cheat-safe. The right-click trigger is also ADS and risks accidental leaving.

### Copy-paste prompt for an AI assistant

If asking another AI to add a feature or repair the macro, provide the current [ragequit.lua](./ragequit.lua) as the reference, then paste this prompt:

```text
You are modifying a WORKING Logitech G HUB Lua script for the
Logitech G102 LIGHTSYNC in Apex Legends (1920x1080 primary screen).
Return a COMPLETE copy-paste-ready OnEvent Lua script, with
practical inline comments. Do not return only snippets.

Preserve TWO actions:
1) Right-click (G HUB Lua arg=2) -> PressKey("escape"), hold
   100ms, release -> wait 350ms -> "tab" 100ms -> wait 200ms
   -> "enter" 100ms -> wait 800ms -> MoveMouseTo(29800,44750)
   -> wait 500ms -> PressMouseButton(1), hold 150ms, release.
2) DPI (candidate Lua arg=6; verify event in output console)
   -> MoveMouseTo(32768,58700) -> wait 500ms -> ONE held
   left-click lasting 150ms -> 4000ms READY trigger cooldown
   using GetRunningTime(), storing lastReadyTime BEFORE clicking.

Critical prior mistakes: right-click is button 2 (NOT 3);
use "escape" (NOT "esc"); do NOT leave an Escape-only test
return or ENABLE_FINAL_CLICK=false in the final version.
Do NOT replace held clicks with instant clicks, or confuse
normalized 0..65535 coordinates with pixels. Preserve timings.

An output log showing MACRO TRIGGERED does not prove the game
received a key. Do not use AutoHotkey, invent APIs, or claim
anti-cheat safety. Warn that right-click is also ADS.
Explain every adjustment, and preserve all existing behavior
unless I explicitly request a change.
```

## Safety warnings

**The default right-click trigger is also the ADS button in Apex.** That means any right-click while the script is active can run the entire Return to Lobby sequence, including during gameplay. Disable the script during actual matches or change the trigger to a dedicated button.

This script does **not** visually detect the game state, so pressing it on the wrong menu can click something unintended. Its cooldown prevents duplicate Lua triggers for a short interval, **not** every possible duplicate click or network-related queue cancellation.

A personal automation experiment; not affiliated with EA, Respawn, Logitech, or Apex Legends. Follow the game's rules and use carefully.

## Credits

Made by **sha6a6**. No AutoHotkey required. 

**Motto:** Sometimes the fastest movement tech is leaving. The second fastest is clicking READY again.
