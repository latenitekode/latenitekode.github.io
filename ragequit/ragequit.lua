-- ============================================================
-- APEX LEGENDS - LOBBY CONTROLLER
-- Logitech G102 LIGHTSYNC | Logitech G HUB Lua
-- Made by sha6a6 | Version 2: Return to Lobby + READY
-- Game screen: 1920 x 1080 (primary monitor)
-- ============================================================
--
-- ACTION 1: RIGHT CLICK = Return to Lobby
-- ACTION 2: DPI BUTTON = Click READY (with cooldown)
--
-- WARNING: RIGHT CLICK is also Apex's normal ADS button.
-- With this script active it triggers the EXIT sequence every
-- time. Disable during gameplay or rebind it.
--
-- Requires Logitech G HUB running with this profile active.
-- Turn off on-board memory mode.
-- ============================================================

-- ================= BUTTON SETTINGS =========================
-- G HUB Lua mouse button numbers:
-- 1 = Left-click
-- 2 = Right-click (this is NOT 3)
-- 3 = Middle / scroll-wheel click
-- 4 = Back side button
-- 5 = Forward side button
-- 6 = POSSIBLE DPI button (verify the Lua console detects 6;
--     some G102 DPI buttons are handled by firmware/G HUB)
local LOBBY_TRIGGER = 2
local READY_TRIGGER = 6

-- Toggle the two actions separately.
local ENABLE_LOBBY = true
local ENABLE_READY = true

-- Set false to test cursor positioning without clicking.
-- Set true to click YES and READY after testing.
local ENABLE_FINAL_CLICK = true

-- ================= TIMING SETTINGS =========================
-- All numbers below are MILLISECONDS; 1000 ms = 1 second.
local KEY_HOLD_MS = 100     -- How long each keyboard key is held
local MOUSE_HOLD_MS = 150   -- How long the left mouse button is held

-- READY -> CANCEL is the normal matchmaking transition.
-- A second click on CANCEL can cancel matchmaking.
-- Ignore DPI repeats for 4 seconds after a READY trigger.
local READY_COOLDOWN_MS = 4000
local lastReadyTime = -READY_COOLDOWN_MS

local MENU_DELAY = 350       -- Wait after Escape
local TAB_DELAY = 200        -- Wait after Tab
local CONFIRM_DELAY = 800    -- Wait for YES/NO popup
local YES_SETTLE_MS = 500    -- Wait after moving cursor to YES
local READY_SETTLE_MS = 500  -- Wait after moving to READY

-- ================= CURSOR SETTINGS =========================
-- Normalized Logitech coordinates: 0 to 65535, NOT pixels.
-- Increasing X moves RIGHT; increasing Y moves DOWN.
-- Calibrated using a 1920x1080 game view.
-- A second monitor or different UI layout may need adjustment.

local YES_X = 29800
local YES_Y = 44750

local READY_X = 32768
local READY_Y = 58700

-- ================= HELPER FUNCTIONS ========================

-- Press, hold, then release a named key.
-- IMPORTANT: For Escape use "escape", NOT "esc"!
local function TapKey(key)
    PressKey(key)
    Sleep(KEY_HOLD_MS)
    ReleaseKey(key)
end

-- Press and hold the LEFT mouse button for 150 ms.
-- This single held click registers more reliably than a tap.
local function SingleClick()
    PressMouseButton(1)
    Sleep(MOUSE_HOLD_MS)
    ReleaseMouseButton(1)
    OutputLogMessage("SINGLE CLICK COMPLETED\n")
end

-- ================= RETURN TO LOBBY =========================

local function ReturnToLobby()
    OutputLogMessage("RETURN TO LOBBY STARTED\n")

    -- 1. Escape opens pause menu.
    TapKey("escape")
    Sleep(MENU_DELAY)

    -- 2. Tab selects Leave Match.
    TapKey("tab")
    Sleep(TAB_DELAY)

    -- 3. Enter opens confirmation dialog.
    TapKey("enter")
    Sleep(CONFIRM_DELAY)

    -- 4. Move cursor over YES.
    MoveMouseTo(YES_X, YES_Y)
    Sleep(YES_SETTLE_MS)

    -- 5. Confirm once with held left-click.
    if ENABLE_FINAL_CLICK then
        SingleClick()
    else
        OutputLogMessage("FINAL CLICK DISABLED\n")
    end

    OutputLogMessage("RETURN TO LOBBY FINISHED\n")
end

-- ================= READY BUTTON ============================

local function ClickReady()
    local now = GetRunningTime()

    -- Duplicate protection: ignore triggers within 4 seconds.
    -- NOTE: This cannot prevent another G HUB assignment
    -- from ALSO sending a click. Check DPI assignments.
    if (now - lastReadyTime) < READY_COOLDOWN_MS then
        OutputLogMessage("READY IGNORED: COOLDOWN ACTIVE\n")
        return
    end

    -- Begin cooldown BEFORE cursor movement or click.
    lastReadyTime = now
    OutputLogMessage("READY MACRO TRIGGERED\n")

    -- Move to READY and wait for Apex to recognize position.
    MoveMouseTo(READY_X, READY_Y)
    Sleep(READY_SETTLE_MS)

    -- Click EXACTLY ONCE. READY changing to CANCEL is normal.
    if ENABLE_FINAL_CLICK then
        SingleClick()
    else
        OutputLogMessage("FINAL CLICK DISABLED\n")
    end

    OutputLogMessage("READY ACTION FINISHED\n")
end

-- ================= MAIN HANDLER ============================

function OnEvent(event, arg)
    if event == "PROFILE_ACTIVATED" then
        OutputLogMessage("APEX LOBBY CONTROLLER LOADED\n")
        return
    end

    -- Handle only button PRESS, not RELEASE.
    if event ~= "MOUSE_BUTTON_PRESSED" then
        return
    end

    -- Helps discover whether DPI reports button 6.
    OutputLogMessage("BUTTON PRESSED: %s\n", tostring(arg))

    -- Independent actions (each exits after execution).
    if ENABLE_LOBBY and arg == LOBBY_TRIGGER then
        ReturnToLobby()
        return
    end

    if ENABLE_READY and arg == READY_TRIGGER then
        ClickReady()
        return
    end
end
