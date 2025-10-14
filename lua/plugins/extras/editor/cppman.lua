return {
    "v1nh1shungry/cppman.nvim",
    cmd = "Cppman",
    opts = function()
        return Abalone.lazy.has("snacks.nvim") and {} or { picker = "snacks" }
    end
}
