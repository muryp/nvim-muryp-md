vim.cmd([[
set rtp+=.
set rtp+=./plenary.nvim
]])
require('plenary.test_harness').test_directory('lua/test')
