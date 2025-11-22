local function terminal(cmd)
  local Terminal = require("toggleterm.terminal").Terminal
  Terminal:new({ cmd = cmd, hidden = true }):toggle()
end

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

  return not src
    or not bin
    or src.mtime.sec > bin.mtime.sec
    or (src.mtime.sec == bin.mtime.sec and src.mtime.nsec > bin.mtime.nsec)
end

local function compile_and_run()
  local ft = vim.bo.filetype
  local compile = nil
  local run = nil
  if ft == "python" then
    run = "python %"
  elseif ft == "cpp" then
    if need_compile("./a.out") then
      local is_darwin = vim.loop.os_uname().sysname == "Darwin"
      local extra_args = not is_darwin and " -g3 -fsanitize=address,leak,undefined" or ""
      compile = "g++ --std=c++23 -Wall -Wextra -Wshadow -Wnrvo -DLOCAL" .. extra_args .. " %"
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

local toggleterm = {
  "akinsho/toggleterm.nvim",
  cmd = { "ToggleTerm", "TermExec" },
  opts = {
    open_mapping = [[<c-\>]],
    size = 20,
    hide_numbers = true,
    shade_filetypes = {},
    shade_terminals = false,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = "float",
    close_on_exit = true,
    shell = vim.o.shell,
    auto_scroll = false,
    persist_mode = true,
    on_stdout = function(term, _, data, _)
      if term:is_open() then
        return
      end
      for _, s in pairs(data) do
        local pos, _ = string.find(s, "❯")
        if pos and s:sub(-1) ~= " " then
          local res = s:sub(pos - 3, pos - 2) == "32" and { "Success", "info" } or { "Failed", "error" }
          vim.notify("Job finished: " .. res[1] .. "!", res[2], { title = term.name })
        end
      end
    end,
    float_opts = {
      border = "curved",
      winblend = 0,
    },
    highlights = {
      FloatBorder = {
        link = "FloatBorder",
      },
    },
  },
  keys = {
    {
      "<leader>th",
      function()
        terminal("htop")
      end,
      desc = "Htop",
    },
    {
      "<leader>tu",
      function()
        terminal("ncdu")
      end,
      desc = "NCDU",
    },
    {
      "<leader>tp",
      function()
        terminal("python3")
      end,
      desc = "Python",
    },
    {
      "<leader>cc",
      compile_and_run,
      desc = "Compile and run",
    },
    {
      "<leader>cm",
      function()
        termexec { run = "make -j$(nproc)" }
      end,
      desc = "Make",
    },
    {
      "<leader>cp",
      function()
        termexec { run = "" }
      end,
      desc = "Run previous command",
    },
  },
}

local flatten = {
  "willothy/flatten.nvim",
  priority = 1010,
  opts = {
    hooks = {
      pre_open = function()
        -- Close toggleterm when an external open request is received
        require("toggleterm").toggle(0)
      end,
      block_end = function()
        -- After blocking ends (for a git commit, etc), reopen the terminal
        require("toggleterm").toggle(0)
      end,
    },
    window = {
      open = "vsplit",
    },
  },
}

return {
  toggleterm,
  flatten,
}
