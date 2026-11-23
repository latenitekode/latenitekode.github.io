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

## Safety warnings

**The default right-click trigger is also the ADS button in Apex.** That means any right-click while the script is active can run the entire Return to Lobby sequence, including during gameplay. Disable the script during actual matches or change the trigger to a dedicated button.

This script does **not** visually detect the game state, so pressing it on the wrong menu can click something unintended. Its cooldown prevents duplicate Lua triggers for a short interval, **not** every possible duplicate click or network-related queue cancellation.

A personal automation experiment; not affiliated with EA, Respawn, Logitech, or Apex Legends. Follow the game's rules and use carefully.

## Credits

Made by **sha6a6**. No AutoHotkey required. 

**Motto:** Sometimes the fastest movement tech is leaving. The second fastest is clicking READY again.
