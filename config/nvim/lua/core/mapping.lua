-- Modes
--   "n": normal_mode
--   "i": insert_mode
--   "v": visual_mode
--   "x": visual_block_mode
--   "t": term_mode
--   "c": command_mode
--   "!": insert_command_mode

-- helper functions{{{

---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param opt? table|string
local function map(mode, lhs, rhs, opt)
  -- NOTE: <cmd> are different from ":"
  if not opt or type(opt) == "string" then
    opt = { silent = true, desc = opt }
  end
  vim.keymap.set(mode, lhs, rhs, opt)
end

local function yank()
  if vim.fn.mode() == 'n' then
    vim.cmd('%y')
  else
    vim.cmd('normal! y')
  end
  vim.fn.system('bash ~/dotfiles/config/zsh/autoload/yank', vim.fn.getreg('0'))
  vim.notify("copied to clipboard")
end

local function terminal(cmd)
  local Terminal = require("toggleterm.terminal").Terminal
  Terminal:new({ cmd = cmd, hidden = true }):toggle()
end
--}}}

-- <leader>: normal mode{{{
map("n", "<leader>w", "<cmd>up<cr>", "Save")
map("n", "<leader>q", "<cmd>q<cr>", "Quit")
map("n", "<leader>y", function() yank() end, "copy to clipboard")
map("n", "<leader><space>", ":e #<cr>", "swap buffer")
--}}}

-- <leader>b: buffer{{{
map("n", "<leader>bb", "<cmd>FzfLua buffers<cr>", "Buffers")
map("n", "<leader>b>", "<cmd>BufferLineMoveNext<cr>", "Move right")
map("n", "<leader>b<", "<cmd>BufferLineMovePrev<cr>", "Move left")
map("n", "<leader>bs", "<cmd>so %|lua vim.notify('Buffer sourced.')<cr>", "Source this buffer")
map("n", "<leader>bz", function()
  require("snacks").zen()
end, "Zen mode")
map("n", "<leader>br", "<cmd>%s/.*/mv & &/<cr>", "bulk rename")
map("n", "<leader>bf", "<cmd>FSToggle<cr>", "Flow state reading toggle")
--}}}

-- <leader>c: compile{{{
---@param cmd {compile:string?, run:string}
local function termexec(cmd)
  -- NOTE: open=0 won't open terminal
  vim.cmd.update()
  local c = (cmd.compile and cmd.compile .. " && " or "") .. cmd.run
  vim.cmd('TermExec cmd="' .. c .. '"')
end

---@param fname string
local function need_compile(fname)
  vim.cmd.update()
  local src = vim.loop.fs_stat(vim.fn.expand("%"))
  local bin = vim.loop.fs_stat(fname)
  ---@diagnostic disable-next-line: need-check-nil
  return not bin or src.mtime.sec > bin.mtime.sec or (src.mtime.sec == bin.mtime.sec and src.mtime.nsec > bin.mtime.nsec)
end

local function compile_and_run()
  local ft = vim.bo.filetype
  local compile = nil
  local run = nil
  if ft == "python" then
    run = "python %"
  elseif ft == "cpp" then
    if need_compile("./a.out") then
      compile = "g++ --std=c++23 -O2 -g3 -Wall -Wextra -Wshadow -fsanitize=address,leak,undefined -DLOCAL %"
    end
    run = "./a.out" .. (vim.loop.fs_stat("./in") and " < in" or "")
  elseif ft == "lua" then
    run = "nvim -l %"
  else
    vim.notify(ft .. " filetype not supported")
    return
  end
  termexec { compile = compile, run = run }
end

local function make()
  termexec { run = "make -j$(nproc)" }
end

map("n", "<leader>cc", compile_and_run, "Compile and run")
map("n", "<leader>cm", make, "Make")
map("n", "<leader>cp", function() termexec { run = "" } end, "Previous command")
--}}}

-- <leader>p: plugin{{{
map("n", "<leader>pp", "<cmd>Lazy<cr>", "Plugin manager (Lazy)")
map("n", "<leader>ps", "<cmd>StartupTime<cr>", "Startup time")
--}}}

-- <leader>f: find{{{
map("n", "<C-p>", "<cmd>FzfLua files<cr>", "Find files")
map("n", "<leader>ff", "<cmd>FzfLua live_grep<cr>", "Find Text")
map("n", "<leader>fd", "<cmd>FzfLua files cwd=~/dotfiles<cr>", "Dotfiles")
map("n", "<leader>fc", "<cmd>FzfLua commands<cr>", "Commands")
map("n", "<leader>fh", "<cmd>FzfLua helptags<cr>", "Help")
map("n", "<leader>fl", "<cmd>FzfLua resume<cr>", "Last Search")
map("n", "<leader>fm", "<cmd>FzfLua manpages<cr>", "Man Pages")
map("n", "<leader>fr", "<cmd>FzfLua oldfiles<cr>", "Recent File")
map("n", "<leader>fk", "<cmd>FzfLua keymaps<cr>", "Keymaps")
map("n", "<leader>fp", "<cmd>Telescope projects<cr>", "Projects")
map("n", "<leader>f/", "<cmd>FzfLua grep_curbuf<cr>", "Search in current buffer")
map("n", "<leader>fs", "<cmd>SessionManager load_session<cr>", "Load session")
map("v", "<leader>fw", "<cmd>FzfLua grep_visual<cr>", "grep visual")
map("n", "<leader>fw", "<cmd>FzfLua grep_cword<cr>", "grep cword")
map("n", "<leader>fW", "<cmd>FzfLua grep_cWORD<cr>", "grep cWORD")
--}}}

-- <leader>h: hop{{{
map("n", "<leader>hh", "<cmd>HopChar2MW<cr>", "Hop 2 characters")
map("n", "<leader>hw", "<cmd>HopWord<cr>", "Hop word")
--}}}

-- <leader>g: git{{{
map("n", "]g", "<cmd>Gitsigns next_hunk<cr>", "Next Hunk")
map("n", "[g", "<cmd>Gitsigns prev_hunk<cr>", "Prev Hunk")
map("n", "<leader>gB", "<cmd>Gitsigns toggle_current_line_blame<cr>", "Blame")
map("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", "Preview Hunk")
map("n", "<leader>gS", "<cmd>Gitsigns stage_buffer<cr>", "Stage Buffer")
map("n", "<leader>gR", "<cmd>Gitsigns reset_buffer<cr>", "Reset Buffer")
map({'n', 'v'}, "<leader>gs", ":Gitsigns stage_hunk<cr>", "Stage hunk")
map({'n', 'v'}, "<leader>gr", ":Gitsigns reset_hunk<cr>", "Reset hunk")
map("n", "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<cr>", "Undo staged hunk")
map("n", "<leader>go", "<cmd>FzfLua git_status<cr>", "git status")
map("n", "<leader>gc", "<cmd>FzfLua git_commits<cr>", "Checkout commit")
map({ "n", "v" }, "<leader>gd", ":DiffviewFileHistory %<cr>", "Diff file history")
map("n", "<leader>gg", "<cmd>Neogit<cr>", "Neogit")
map("n", "<leader>gn", "<cmd>NvimTreeRefresh<cr>", "refresh nvim-tree")
--}}}

-- <leader>l: lsp{{{
map("n", "<leader>la", "<cmd>Lspsaga code_action<cr>", "Code Action")
map("n", "<leader>ld", "<cmd>Trouble diagnostics<cr>", "Diagnostics")
map("n", "<leader>li", "<cmd>LspInfo<cr>", "LSP info")
map("n", "<leader>lI", "<cmd>Mason<cr>", "LSP installer Info")
map("n", "<leader>ll", "<cmd>Lspsaga show_line_diagnostics<cr>", "Hover diagnostics")
map("n", "]d", vim.diagnostic.goto_next, "next diagnostic")
map("n", "[d", vim.diagnostic.goto_prev, "prev diagnostic")
map("n", "<leader>lp", "<cmd>Lspsaga peek_definition<cr>", "preview definition")
map("n", "<leader>lo", function()
  require("dropbar.api").pick()
end, "Outline(pick from dropbar)")
map("n", "<leader>lO", "<cmd>SymbolsOutline<cr>", "Outline(SymbolsOutline)")
map("n", "<leader>lq", vim.diagnostic.setloclist, "Quickfix")
map("n", "<leader>ls", "<cmd>FzfLua lsp_document_symbols<cr>", "Document Symbols")
map("n", "<leader>lS", "<cmd>FzfLua lsp_workspace_symbols<cr>", "Workspace Symbols")
map("n", "<leader>lw", "<cmd>FzfLua lsp_workspace_diagnostics<cr>", "Workspace Diagnostics")
map("n", "<leader>ln", "<cmd>Lspsaga finder<cr>", "Lsp finder (definition, reference)")

-- <leader>t: terminal{{{
map("t", "<esc>", [[<C-\><C-n>]])
map("n", [[<c-\>]], "<cmd>ToggleTerm<cr>", "Toggleterm")

map("n", "<leader>tt", function()
  local cmd = "ToggleTerm"
  if vim.bo.filetype ~= "toggleterm" then
    cmd = vim.fn.bufnr() .. cmd
  end
  vim.cmd(cmd)
end, "Float terminal for each buffer")

map("n", [[<leader>tf]], "<cmd>ToggleTerm direction=float<cr>", "Float")
map("n", [[<leader>t-]], "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal")
map("n", [[<leader>t\]], "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical")
map("n", "<leader>th", function() terminal('htop') end, "Htop")
map("n", "<leader>tu", function() terminal('ncdu') end, "NCDU")
map("n", "<leader>tp", function() terminal('python3') end, "Python")
--}}}

-- <leader>: visual mode{{{
map("v", "<leader>y", function() yank() end, "copy to clipboard")
--}}}

-- quickfix
map("n", "]q", "<cmd>cnext<cr>", "quickfix next")
map("n", "[q", "<cmd>cprev<cr>", "quickfix prev")

-- Move text up and down
map("v", "<S-h>", ":m '<-2<cr>gv=gv")
map("v", "<S-l>", ":m '>+1<cr>gv=gv")

-- bufferline
map("n", "H", "<cmd>BufferLineCyclePrev<cr>", "Previous buffer")
map("n", "L", "<cmd>BufferLineCycleNext<cr>", "Next buffer")
map("n", "Q", "<cmd>Bdelete<cr>", "Delete buffer")

-- navigation
map({"n", "v"}, "<C-j>", "4jzz")
map({"n", "v"}, "<C-k>", "4kzz")
map("!", "<C-A>", "<Home>", {})
map("!", "<C-E>", "<End>", {})
map("!", "<Esc>b", "<S-Left>", {})
map("!", "<Esc>f", "<S-Right>", {})
