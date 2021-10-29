local M = {}

-- Ensure what all pre-requirements are satistied
function M:init ()

    -- Make sure the plugin loader is downloaded and configured
    require 'plugin-loader':init ()

    return self
end

return M
