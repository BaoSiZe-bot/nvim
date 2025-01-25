(let [autocmd vim.api.nvim_create_autocmd]
  (autocmd ["InsertLeave" "TextChanged"]
           {:pattern ["*"] :command "silent! wall" :nested true})
  (autocmd ["UIEnter" "BufReadPost" "BufNewFile"]
           {:group (vim.api.nvim_create_augroup "NvFilePost" {:clear true})
            :callback (lambda [args] (local file (vim.api.nvim_buf_get_name args.buf))
                        (local buftype (vim.api.nvim_get_option_value "buftype" {:buf args.buf}))
                        (when (and (not vim.g.ui_entered) (= args.event "UIEnter")) 
                          (set vim.g.ui_entered true))
                        (when (and (not (= file "")) (not (= buftype "nofile")) vim.g.ui_entered)
                          (vim.api.nvim_exec_autocmds "User" {:pattern "FilePost" :modeline false})
                          (vim.api.nvim_del_augroup_by_name "NvFilePost")
                          (vim.schedule (lambda []
                                           (vim.api.nvim_exec_autocmds "FileType" {})
                                           (when vim.g.editorconfig
                                             (let [(_ editorconf) (pcall require "editorconfig")]
                                               (editorconf.config args.buf)))))))}))
nil
