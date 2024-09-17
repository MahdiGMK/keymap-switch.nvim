---@class DefaultConfig
---@field keymap string
---@field iminsert integer
---@field imsearch integer
---@field format fun(keymap_name:string):string
local config = {
  iminsert = 0,
  imsearch = -1,
  format = function(keymap_name) return keymap_name end,
}

local function switch_n() vim.o.iminsert = bit.bxor(vim.o.iminsert, 1) end

local key = vim.api.nvim_replace_termcodes('<c-^>', true, true, true)
local function switch_ic() vim.api.nvim_feedkeys(key, 'n', false) end

---@class Config
---@field keymap string
---@field format fun(keymap_name:string):string

---@class KeymapSwitch
---@field setup fun(opts:Config) Setup keymap-switch.nvim
---@field condition fun():boolean Status line condition
---@field provider fun():string Status line provider
local M = {}

function M.setup(opts)
  vim.validate({
    keymap = { opts.keymap, 'string' },
    format = {
      opts.format,
      function(v) return v == nil or type(v) == 'function' end,
      "'format' must be a function with 1 string argument",
    },
  })

  config.keymap = opts.keymap
  config.format = opts.format or config.format

  vim.o.keymap = config.keymap
  vim.o.iminsert = config.iminsert
  vim.o.imsearch = config.imsearch

  vim.keymap.set({ 'i', 'c' }, '<plug>(keymap-switch)', switch_ic)
  vim.keymap.set('n', '<plug>(keymap-switch)', switch_n)
end

function M.condition()
  return vim.b.keymap_name
    and (
      vim.o.imsearch ~= -1 and vim.fn.mode() == 'c' and vim.o.imsearch == 1
      or vim.o.iminsert == 1
    )
end

function M.provider() return config.format(M.condition() and vim.b.keymap_name or 'en') end

return M
