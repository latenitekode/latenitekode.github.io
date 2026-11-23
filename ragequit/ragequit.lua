-- ============================================================
-- APEX LEGENDS - RETURN TO LOBBY / RAGEQUIT BUTTON
-- Logitech G102 LIGHTSYNC | Logitech G HUB Lua
-- Screen: 1920 x 1080 (primary display)
-- Made by sha6a6 | 2026-11-23
-- ============================================================
--
-- HOW IT WORKS:
-- Right-click -> Escape -> Tab -> Enter -> Move to YES -> Click.
--
-- IMPORTANT:
-- With TRIGGER_BUTTON = 2, EVERY RIGHT-CLICK while this
-- G HUB profile/script is active triggers the macro.
-- Do NOT leave it active while aiming down sights in a match.
-- Prefer a dedicated button or disable the script during play.
--
-- This script uses G HUB's own Lua API, NOT AutoHotkey.
-- It requires G HUB running with the correct active profile.
-- ============================================================

-- ================== USER SETTINGS ==========================

-- G HUB Lua mouse buttons (these are NOT Windows button IDs):
-- 1 = Left
-- 2 = Right (current trigger)
-- 3 = Middle / wheel click
-- 4 = Back side button
-- 5 = Forward side button
local TRIGGER_BUTTON = 2

-- Final action:
-- true  = click YES after moving there
-- false = only MOVE to YES (safer while testing coordinates)
local ENABLE_FINAL_CLICK = true

-- Hold every keyboard key this many milliseconds.
-- Correct G HUB name for ESC is "escape", NOT "esc".
local KEY_HOLD_MS = 100

-- Wait times, in MILLISECONDS (1000 = 1 second).
-- Increase if a menu transition is missed.
local MENU_DELAY = 350       -- After Escape
local TAB_DELAY = 200        -- After Tab
local CONFIRM_DELAY = 800    -- After Enter; wait for YES dialog
local CURSOR_SETTLE_MS = 500 -- After moving cursor to YES

-- How long to hold the simulated left click.
-- A 150 ms hold worked better than an instantaneous click.
local MOUSE_HOLD_MS = 150

-- Logitech normalized coordinates: range 0 .. 65535.
-- Based on the YES button in a 1920x1080 game view.
-- Larger X moves right; larger Y moves down.
-- These may need adjustment for another resolution/monitor.
local YES_X = 29800
local YES_Y = 44750

-- ================= HELPER FUNCTIONS ========================

-- Press, HOLD, then release a keyboard key.
local function TapKey(key)
    PressKey(key)
    Sleep(KEY_HOLD_MS)
    ReleaseKey(key)
end

-- Press, HOLD, then release the LEFT mouse button.
-- This held click is the fix for the YES button not registering.
local function ClickLeft()
    OutputLogMessage("LEFT CLICK PRESSED\n")
    PressMouseButton(1)
    Sleep(MOUSE_HOLD_MS)
    ReleaseMouseButton(1)
    OutputLogMessage("LEFT CLICK RELEASED\n")
end

-- ==================== MAIN SCRIPT ==========================

function OnEvent(event, arg)
    -- Do nothing on any event other than the configured press.
    if event == "MOUSE_BUTTON_PRESSED"
        and arg == TRIGGER_BUTTON then

        OutputLogMessage("RAGEQUIT MACRO TRIGGERED\n")

        -- 1) Open Apex pause menu.
        TapKey("escape")
        OutputLogMessage("ESCAPE SENT\n")
        Sleep(MENU_DELAY)

        -- 2) Move selection to Leave Match.
        TapKey("tab")
        OutputLogMessage("TAB SENT\n")
        Sleep(TAB_DELAY)

        -- 3) Open the leave confirmation dialog.
        TapKey("enter")
        OutputLogMessage("ENTER SENT\n")
        Sleep(CONFIRM_DELAY)

        -- 4) Put the cursor over the YES button.
        MoveMouseTo(YES_X, YES_Y)
        OutputLogMessage("CURSOR MOVED TO YES\n")
        Sleep(CURSOR_SETTLE_MS)

        -- 5) Actually confirm leaving (optional setting).
        if ENABLE_FINAL_CLICK then
            ClickLeft()
            OutputLogMessage("YES CLICK ATTEMPTED\n")
        else
            OutputLogMessage("FINAL CLICK DISABLED\n")
        end

        OutputLogMessage("MACRO FINISHED\n")
    end
end
