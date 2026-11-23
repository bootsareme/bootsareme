vim.opt.number = true             -- set number
vim.opt.relativenumber = true     -- set relativenumber
vim.opt.autoindent = true         -- set autoindent
vim.opt.cindent = true            -- set cindent (smart indentation for C)
vim.opt.tabstop = 8               -- set tabstop=8
vim.opt.shiftwidth = 8            -- set shiftwidth=8
vim.opt.softtabstop = 8           -- Keeps spacing consistent with 8-char tabs
vim.opt.expandtab = false         -- set noexpandtab (Forces real \t characters)
vim.opt.cursorline = true         -- Visually highlights the line you are editing
vim.opt.scrolloff = 8             -- Keeps 8 lines of context visible above/below cursor
vim.opt.wrap = false              -- no wrapping
vim.opt.ignorecase = true         -- Case-insensitive search...
vim.opt.smartcase = true          -- ...unless you explicitly type a capital letter
vim.opt.hlsearch = false          -- Stops text from staying highlighted after search
vim.opt.mouse = "a"               -- Enable the mouse fully inside tmux
vim.opt.clipboard = "unnamedplus" -- Syncs Vim yank/paste with your system clipboard
vim.opt.list = true
vim.opt.listchars = { tab = "  ", trail = "·" } -- trailing whitespace detector

-- Right-click to copy visual selection to system clipboard
vim.keymap.set("v", "<RightMouse>", '"+y', { silent = true }) 

vim.api.nvim_create_autocmd("FileType", {
  pattern = "c",
  callback = function(args)
    vim.treesitter.start(args.buf, "c")
  end,
})

-- Jump to the last known cursor position when opening a file
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- open binaries in readable assembly format
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = { "*.o", "*.ko", "*.elf", "*.out" },
  callback = function()
    local file = vim.fn.expand("%:p")
    vim.bo.modifiable = true
    vim.cmd("silent %!objdump -x -d -C " .. vim.fn.shellescape(file))
    vim.bo.filetype = "asm"
    vim.bo.buftype = "nofile"
    vim.bo.modifiable = false
  end,
})

vim.lsp.config('clangd', {
  cmd = { 'clangd', '--background-index', '--header-insertion=never' },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
  root_markers = { 'compile_commands.json', '.clangd', '.git' },
})
vim.lsp.enable('clangd')

vim.diagnostic.config({
  underline = true,
  virtual_lines = true, -- displays error next line
  virtual_text = false,
  severity_sort = true, -- Shows errors before warnings if a line has both
})

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", {
      undercurl = true,
      sp = "#ff5555", -- Bright red squiggle
    })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", {
      undercurl = true,
      sp = "#f1fa8c", -- Yellow squiggle
    })
  end,
})

vim.cmd.colorscheme("zaibatsu")
vim.cmd.syntax("on") -- Enable classic, fast, built-in highlighting
vim.cmd.filetype("plugin indent on") -- CRUCIAL: Tells Neovim to detect .c/.h files!
