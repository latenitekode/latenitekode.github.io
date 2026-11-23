# Rage Quit Button: Apex Legends Edition

> **One click. Five inputs. Zero emotional damage recovered.**

A lovingly over-engineered **Logitech G HUB Lua** macro built for a Logitech G102 LIGHTSYNC with a broken primary left-click. The script automates the Apex Legends *Leave Match* menu sequence.

**Blog page:** https://latenitekode.github.io/ragequit/

## The script

Download [ragequit.lua](./ragequit.lua). It runs:

`Right-click -> Escape -> Tab -> Enter -> move cursor to YES -> hold left click for 150 ms`

The YES location (`YES_X = 29800`, `YES_Y = 44750`) was tuned for a **1920 x 1080 primary display**; multi-monitor configurations may need adjustments.

## Setup

1. Open **Logitech G HUB** and choose the G102's correct profile.
2. Turn **On-Board Memory Mode off**.
3. Open the G HUB Lua scripting editor. Create/activate a script and paste `ragequit.lua`.
4. Keep G HUB running; the G102 cannot store this advanced Lua behavior in its onboard memory.
5. Before testing a final click, set `ENABLE_FINAL_CLICK = false`. Verify where the cursor lands. Only then set it back to `true`.

### Make it your own

The top of the Lua file has fully documented values for the trigger, timings, mouse hold duration, and YES coordinates. G HUB uses mouse button **2** for the actual right-click, not 3. For Escape, use `"escape"`, not `"esc"`.

## Warning (seriously)

The shipped trigger is **right-click**, as requested by the original user. That means **any right-click with this G HUB script active starts the entire leave-match sequence**, including while aiming down sights. Disable the script during gameplay or change the trigger to a dedicated button, preferably with an additional safeguard. Test in a noncompetitive context. Automated in-game actions may be subject to game rules or anti-cheat restrictions; no claim of endorsement, compliance, or immunity from enforcement is made.

This is a personal experiment, not affiliated with EA, Respawn, Logitech, or Apex Legends.

## Credits

Made by **sha6a6**. No AutoHotkey, because Apex refuses to launch with it running on the original setup.

**Motto:** Sometimes the fastest movement tech is leaving.
