function reload()
    package.loaded.config = nil
    package.loaded.options = nil
    package.loaded.binds = nil
    require "config"
end

require "options"
require "binds"

