local dap = require 'dap'

vim.fn.sign_define('DapBreakpoint', {
      text = "",
      texthl = "LspDiagnosticsSignError",
      linehl = "",
      numhl = "",
})
vim.fn.sign_define('DapBreakpontRejected', {
      text = "",
      texthl = "LspDiagnosticsSignHint",
      linehl = "",
      numhl = "",
})
vim.fn.sign_define('DapStopped', {
      text = "",
      texthl = "LspDiagnosticsSignInformation",
      linehl = "DiagnosticUnderlineInfo",
      numhl = "LspDiagnosticsSignInformation",
})

dap.defaults.fallback.terminal_win_cmd = '50vsplit new'
