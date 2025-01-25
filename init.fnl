(set vim.g.mapleader " ")
(local lazypath (.. (vim.fn.stdpath :data) "/lazy/lazy.nvim"))
(local nfnlpath (.. (vim.fn.stdpath :data) "/lazy/nfnl"))
;; (when vim.env.PROF
;;   (local snacks (.. (vim.fn.stdpath :data) "/lazy/snacks.nvim"))
;;   (vim.opt.rtp:append snacks)
;;   (let [(_ profiler) (pcall require "snacks")]
;;     (profiler.startup {:startup [{:event "VeryLazy"}]})))
(when (not (vim.uv.fs_stat lazypath))
  (local repo "https://github.com/folke/lazy.nvim.git")
  (vim.fn.system {"git" "clone" "--filter=blob:none" repo "--branch=stable" lazypath}))
(when (not (vim.uv.fs_stat nfnlpath))
  (local repo "https://github.com/Olical/nfnl.git")
  (vim.fn.system {"git" "clone" repo lazypath}))
(vim.opt.rtp:prepend nfnlpath)
(vim.opt.rtp:prepend lazypath)
(local lazy_config (require "configs.lazy"))
(let [(_ lazyevent) (pcall require "lazy.core.handler.event")]
  (set lazyevent.mappings.LazyFile {:id "LazyFile" :event "BufReadPost" "BufWrite" "BufNewFile"}))
(let [(_ lazy) (pcall require "lazy")]
  (lazy.setup [{:url "https://github.com/Olical/nfnl" :ft "fennel"}
               {:import "plugins"}] lazy_config))
(require "options")
(vim.schedule (lambda []
                 (require "mappings")
                 (require "configs.init_funcs")))
(require "autocmds")
nil
