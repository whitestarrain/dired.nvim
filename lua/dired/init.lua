-- setup dired.
-- Author: X3eRo0
local config = require("dired.config")
local dired = require("dired.dired")

local M = {}

M.open = dired.open_dir
M.quit = dired.quit_buf
M.enter = dired.enter_dir
M.goback = dired.go_back
M.goup = dired.go_up
M.refresh = dired.refresh
M.init = dired.init_dired
M.rename = dired.rename_file
M.create = dired.create_file
M.delete = dired.delete_file
M.delete_range = dired.delete_file_range
M.clip = dired.clip_file
M.clip_range = dired.clip_file_range
M.clip_marked = dired.clip_marked
M.paste = dired.paste_file
M.mark = dired.mark_file
M.mark_range = dired.mark_file_range
M.delete_marked = dired.delete_marked
M.toggle_hidden_files = dired.toggle_hidden_files
M.toggle_sort_order = dired.toggle_sort_order
M.toggle_show_icons = dired.toggle_show_icons
M.toggle_colors = dired.toggle_colors
M.toggle_hide_details = dired.toggle_hide_details

function M.setup(opts)
    -- apply user config
    local errs = config.update(opts)
    require("dired.highlight").setup()
    if #errs == 1 then
        vim.api.nvim_err_writeln("dired.setup: " .. errs[1])
    elseif #errs > 1 then
        vim.api.nvim_err_writeln("dired.setup:")
        for _, err in ipairs(errs) do
            vim.api.nvim_err_writeln("    " .. err)
        end
    end

    if vim.g.dired_loaded then
        return
    end

    if config.get("show_colors") == nil then
        -- default for show-hidden is true
        vim.g.dired_show_colors = true
    else
        vim.g.dired_show_colors = config.get("show_colors")
    end

    -- global variable for show_hidden
    if config.get("show_hidden") == nil then
        -- default for show-hidden is true
        vim.g.dired_show_hidden = true
    else
        vim.g.dired_show_hidden = config.get("show_hidden")
    end

    -- global variable for show_icons
    if config.get("show_icons") == nil then
        -- default for show_icons is false
        vim.g.dired_show_icons = false
    else
        vim.g.dired_show_icons = config.get("show_icons")
    end

    -- global variable for hide_details
    if config.get("hide_details") == nil then
        -- default for show-hidden is true
        vim.g.dired_hide_details = true
    else
        vim.g.dired_hide_details = config.get("hide_details")
    end

    if config.get("show_dot_dirs") == nil then
        -- default for show-hidden is true
        vim.g.dired_show_dot_dirs = true
    else
        vim.g.dired_show_dot_dirs = config.get("show_dot_dirs")
    end

    -- global variable for sort_order
    if config.get("sort_order") == nil then
        -- default for sort_order is sort_by_name
        vim.g.dired_sort_order = true
    else
        vim.g.dired_sort_order = config.get("sort_order")
    end

    vim.cmd([[command! -nargs=? -complete=dir Dired lua require'dired'.open(<q-args>)]])
    vim.cmd([[command! -nargs=? -complete=file DiredRename lua require'dired'.rename(<q-args>)]])
    vim.cmd([[command! -nargs=? -complete=file DiredDelete lua require'dired'.delete(<q-args>)]])
    vim.cmd([[command! -nargs=? -complete=file DiredMark lua require'dired'.mark(<q-args>)]])
    vim.cmd([[command! DiredDeleteRange lua require'dired'.delete_range()]])
    vim.cmd([[command! DiredDeleteMarked lua require'dired'.delete_marked()]])
    vim.cmd([[command! DiredMarkRange lua require'dired'.mark_range()]])
    vim.cmd([[command! DiredGoBack lua require'dired'.goback()]])
    vim.cmd([[command! DiredGoUp lua require'dired'.goup()]])
    vim.cmd([[command! DiredRefresh lua require'dired'.refresh()]])
    vim.cmd([[command! DiredCopy lua require'dired'.clip("copy")]])
    vim.cmd([[command! DiredCopyRange lua require'dired'.clip_range("copy")]])
    vim.cmd([[command! DiredCopyMarked lua require'dired'.clip_marked("copy")]])
    vim.cmd([[command! DiredMove lua require'dired'.clip("move")]])
    vim.cmd([[command! DiredMoveRange lua require'dired'.clip_range("move")]])
    vim.cmd([[command! DiredMoveMarked lua require'dired'.clip_marked("move")]])
    vim.cmd([[command! DiredPaste lua require'dired'.paste()]])
    vim.cmd([[command! DiredEnter lua require'dired'.enter()]])
    vim.cmd([[command! DiredCreate lua require'dired'.create()]])
    vim.cmd([[command! DiredToggleHidden lua require'dired'.toggle_hidden_files()]])
    vim.cmd([[command! DiredToggleSortOrder lua require'dired'.toggle_sort_order()]])
    vim.cmd([[command! DiredToggleColors lua require'dired'.toggle_colors()]])
    vim.cmd([[command! DiredToggleIcons lua require'dired'.toggle_show_icons()]])
    vim.cmd([[command! DiredToggleHideDetails lua require'dired'.toggle_hide_details()]])
    vim.cmd([[command! DiredQuit lua require'dired'.quit()]])

    -- setup keybinds
    local map = vim.api.nvim_set_keymap
    local opt = { unique = true, silent = true, noremap = true }
    map("", "<Plug>(dired_back)", ":DiredGoBack<cr>", opt)
    map("", "<Plug>(dired_up)", ":DiredGoUp<cr>", opt)
    map("", "<Plug>(dired_refresh)", ":DiredRefresh<cr>", opt)
    map("", "<Plug>(dired_enter)", ":DiredEnter<cr>", opt)
    map("", "<Plug>(dired_rename)", ":DiredRename<cr>", opt)
    map("", "<Plug>(dired_delete)", ":DiredDelete<cr>", opt)
    map("", "<Plug>(dired_delete_range)", ":<C-u>DiredDeleteRange<cr>", opt)
    map("", "<Plug>(dired_delete_marked)", ":DiredDeleteMarked<cr>", opt)
    map("", "<Plug>(dired_copy)", ":DiredCopy<cr>", opt)
    map("", "<Plug>(dired_copy_marked)", ":DiredCopyMarked<cr>", opt)
    map("", "<Plug>(dired_copy_range)", ":<C-u>DiredCopyRange<cr>", opt)
    map("", "<Plug>(dired_move)", ":DiredMove<cr>", opt)
    map("", "<Plug>(dired_move_marked)", ":DiredMoveMarked<cr>", opt)
    map("", "<Plug>(dired_move_range)", ":<C-u>DiredMoveRange<cr>", opt)
    map("", "<Plug>(dired_paste)", ":DiredPaste<cr>", opt)
    map("", "<Plug>(dired_mark)", ":DiredMark<cr>", opt)
    map("", "<Plug>(dired_mark_range)", ":<C-u>DiredMarkRange<cr>", opt)
    map("", "<Plug>(dired_create)", ":DiredCreate<cr>", opt)
    map("", "<Plug>(dired_toggle_hidden)", ":DiredToggleHidden<cr>", opt)
    map("", "<Plug>(dired_toggle_sort_order)", ":DiredToggleSortOrder<cr>", opt)
    map("", "<Plug>(dired_toggle_colors)", ":DiredToggleColors<cr>", opt)
    map("", "<Plug>(dired_toggle_icons)", ":DiredToggleIcons<cr>", opt)
    map("", "<Plug>(dired_toggle_hide_details)", ":DiredToggleHideDetails<cr>", opt)
    map("", "<Plug>(dired_quit)", ":DiredQuit<cr>", opt)

    if vim.fn.mapcheck("-", "n") == "" and not vim.fn.hasmapto("<Plug>(dired_back)", "n") then
        map("n", "-", "<Plug>(dired_back)", { silent = true })
    end

    -- set dired keybinds
    -- from https://www.youtube.com/watch?v=ekMIIAqTZ34
    map = function(buffer, mode, lhs, rhs, mapping_opts)
        if type(lhs) == "table" then
            for _, lhs_item in ipairs(lhs) do
                vim.api.nvim_buf_set_keymap(buffer, mode, lhs_item, rhs, mapping_opts)
            end
        else
            vim.api.nvim_buf_set_keymap(buffer, mode, lhs, rhs, mapping_opts)
        end
    end
    opt = { silent = true, noremap = true }

    vim.api.nvim_create_autocmd("FileType", {
        pattern = "dired",
        callback = function()
            map(0, "n", config.get("keybinds").dired_enter, "<Plug>(dired_enter)", opt)
            map(0, "n", config.get("keybinds").dired_back, "<Plug>(dired_back)", opt)
            map(0, "n", config.get("keybinds").dired_up, "<Plug>(dired_up)", opt)
            map(0, "n", config.get("keybinds").dired_refresh, "<Plug>(dired_refresh)", opt)
            map(0, "n", config.get("keybinds").dired_rename, "<Plug>(dired_rename)", opt)
            map(0, "n", config.get("keybinds").dired_create, "<Plug>(dired_create)", opt)
            map(0, "n", config.get("keybinds").dired_delete, "<Plug>(dired_delete)", opt)
            map(0, "v", config.get("keybinds").dired_delete_range, "<Plug>(dired_delete_range)", opt)
            map(0, "n", config.get("keybinds").dired_copy, "<Plug>(dired_copy)", opt)
            map(0, "v", config.get("keybinds").dired_copy_range, "<Plug>(dired_copy_range)", opt)
            map(0, "n", config.get("keybinds").dired_copy_marked, "<Plug>(dired_copy_marked)", opt)
            map(0, "n", config.get("keybinds").dired_move, "<Plug>(dired_move)", opt)
            map(0, "v", config.get("keybinds").dired_move_range, "<Plug>(dired_move_range)", opt)
            map(0, "n", config.get("keybinds").dired_move_marked, "<Plug>(dired_move_marked)", opt)
            map(0, "n", config.get("keybinds").dired_paste, "<Plug>(dired_paste)", opt)
            map(0, "n", config.get("keybinds").dired_mark, "<Plug>(dired_mark)", opt)
            map(0, "v", config.get("keybinds").dired_mark_range, "<Plug>(dired_mark_range)", opt)
            map(0, "n", config.get("keybinds").dired_delete_marked, "<Plug>(dired_delete_marked)", opt)
            map(0, "n", config.get("keybinds").dired_toggle_hidden, "<Plug>(dired_toggle_hidden)", opt)
            map(0, "n", config.get("keybinds").dired_toggle_sort_order, "<Plug>(dired_toggle_sort_order)", opt)
            map(0, "n", config.get("keybinds").dired_toggle_colors, "<Plug>(dired_toggle_colors)", opt)
            map(0, "n", config.get("keybinds").dired_toggle_icons, "<Plug>(dired_toggle_icons)", opt)
            map(0, "n", config.get("keybinds").dired_toggle_hide_details, "<Plug>(dired_toggle_hide_details)", opt)
            map(0, "n", config.get("keybinds").dired_quit, "<Plug>(dired_quit)", opt)
        end,
    })

    local dired_group = vim.api.nvim_create_augroup("dired", { clear = true })

    -- open dired when opening a directory
    vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*",
        command = "if isdirectory(expand('%')) && !&modified && &filetype!='dired' | execute 'lua require(\"dired\").init()' | endif",
        group = dired_group,
    })

    vim.api.nvim_create_autocmd("VimEnter", {
        pattern = "*",
        command = "if exists('#FileExplorer') | execute 'autocmd! FileExplorer *' | endif",
        group = dired_group,
    })

    vim.api.nvim_create_autocmd("VimEnter", {
        pattern = "*",
        command = "if exists('#NERDTreeHijackNetrw') | exe 'au! NERDTreeHijackNetrw *' | endif",
        group = dired_group,
    })

    vim.cmd([[if exists('#FileExplorer') | execute 'autocmd! FileExplorer *' | endif]])
    vim.g.dired_loaded = true
end

return M
