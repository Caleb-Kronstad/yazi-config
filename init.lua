local pane_id = nil

local function setup_pane()
    if os.getenv("WEZTERM_PANE") == nil or os.getenv("YAZI_LEVEL")then
        return
    end
    local handle = io.popen("wezterm cli split-pane --bottom --percent 30 -- bash")
    if handle then
        pane_id = handle:read("*l")
        handle:close()
        os.execute("wezterm cli activate-pane --pane-id " .. os.getenv("WEZTERM_PANE"))
    end
end

setup_pane()

ps.sub("cd", function()
    if pane_id then
        local cwd = tostring(cx.active.current.cwd)
        os.execute(
            string.format(
                'wezterm cli send-text --pane-id %s --no-paste " cd %q\n" &',
                pane_id,
                cwd
            )
        )
    end
end)