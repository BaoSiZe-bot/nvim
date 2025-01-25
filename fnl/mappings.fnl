(local map vim.keymap.set)
(map ["n" "i" "v"] "<space>ft" (lambda [] ((let [(_ term) (pcall require "snacks.terminal")] term.toggle)) {:desc "Open Terminal"}))
(map ["n" "i" "v"] "<C-s>" "<cmd> w <cr>" {:desc "Save Buffer"})
(map "n" "<C-h>" "<C-w>h" {:desc "Go to Left Window"  :remap true})
(map "n" "<C-j>" "<C-w>j" {:desc "Go to Lower Window" :remap true})
(map "n" "<C-k>" "<C-w>k" {:desc "Go to Upper Window" :remap true})
(map "n" "<C-l>" "<C-w>l" {:desc "Go to Right Window" :remap true})

(map "n" "<C-Up>" "<cmd>resize +2<cr>" {:desc "Increase Window Height" })
(map "n" "<C-Down>" "<cmd>resize -2<cr>" {:desc "Decrease Window Height" })
(map "n" "<C-Left>" "<cmd>vertical resize -2<cr>" {:desc "Decrease Window Width" })
(map "n" "<C-Right>" "<cmd>vertical resize +2<cr>" {:desc "Increase Window Width" })

(map "n" "<A-j>" "<cmd>execute 'move .+' . v:count1<cr>==" {:desc "Move Down" })
(map "n" "<A-k>" "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==" {:desc "Move Up" })
(map "i" "<A-j>" "<esc><cmd>m .+1<cr>==gi" {:desc "Move Down" })
(map "i" "<A-k>" "<esc><cmd>m .-2<cr>==gi" {:desc "Move Up" })
(map "v" "<A-j>" ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv" {:desc "Move Down" })
(map "v" "<A-k>" ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv" {:desc "Move Up" })

(map "n" "<S-h>" "<cmd>bprevious<cr>" {:desc "Prev Buffer" })
(map "n" "<S-l>" "<cmd>bnext<cr>" {:desc "Next Buffer" })
(map "n" "[b" "<cmd>bprevious<cr>" {:desc "Prev Buffer" })
(map "n" "]b" "<cmd>bnext<cr>" {:desc "Next Buffer" })
(map "n" "<leader>bb" "<cmd>e #<cr>" {:desc "Switch to Other Buffer" })
(map "n" "<leader>`" "<cmd>e #<cr>" {:desc "Switch to Other Buffer" })
(map "n" "<space>bd" (lambda [] ((let [(_ snackbuf) (pcall require "snacks")] snackbuf.bufdelete)) {:desc "Delete Buffer"}))
(map "n" "<space>bo" (lambda [] ((let [(_ snackbuf) (pcall require "snacks")] snackbuf.bufdelete.other)) {:desc "Delete Other Buffers"}))
(map "n" "<leader>bD" "<cmd>:bd<cr>" {:desc "Delete Buffer and Window" })

(map ["i" "n" "s"] "<esc>" (lambda [] (vim.cmd "noh") "<esc>") {:expr true :desc "Escape and Clear hlsearch"})

(map "n" "<leader>ur" "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>"
  {:desc "Redraw / Clear hlsearch / Diff Update" })

(map "n" "n" "'Nn'[v:searchforward].'zv'" {:expr true :desc "Next Search Result" })
(map "x" "n" "'Nn'[v:searchforward]" {:expr true :desc "Next Search Result" })
(map "o" "n" "'Nn'[v:searchforward]" {:expr true :desc "Next Search Result" })
(map "n" "N" "'nN'[v:searchforward].'zv'" {:expr true :desc "Prev Search Result" })
(map "x" "N" "'nN'[v:searchforward]" {:expr true :desc "Prev Search Result" })
(map "o" "N" "'nN'[v:searchforward]" {:expr true :desc "Prev Search Result" })

(map "i" "," ",<c-g>u")
(map "i" "." ".<c-g>u")
(map "i" ";" ";<c-g>u")

(map ["i" "x" "n" "s"] "<C-s>" "<cmd>w<cr><esc>" {:desc "Save File" })

(map "n" "<leader>K" "<cmd>norm! K<cr>" {:desc "Keywordprg" })

(map "v" "<" "<gv")
(map "v" ">" ">gv")

(map "n" "gco" "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>" {:desc "Add Comment Below" })
(map "n" "gcO" "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>" {:desc "Add Comment Above" })

(map "n" "<leader>L" "<cmd>Lazy<cr>" {:desc "Lazy" })

(map "n" "<leader>fn" "<cmd>enew<cr>" {:desc "New File" })

(map "n" "<leader>xl" "<cmd>lopen<cr>" {:desc "Location List" })
(map "n" "<leader>xq" "<cmd>copen<cr>" {:desc "Quickfix List" })

(map "n" "[q" vim.cmd.cprev {:desc "Previous Quickfix" })
(map "n" "]q" vim.cmd.cnext {:desc "Next Quickfix" })

(map ["n" "v"] "<leader>cf" (lambda [] (vim.lsp.buf.format)) {:desc "Format"})

(map "n" "<leader>cd" vim.diagnostic.open_float {:desc "Line Diagnostics" })
(map "n" "]d" vim.diagnostic.goto_next {:desc "Next Diagnostic" })
(map "n" "[d" vim.diagnostic.goto_prev {:desc "Prev Diagnostic" })
(map "n" "]e" (lambda [] (vim.diagnostic.goto_next {:severity 1})) {:desc "Next Error" })
(map "n" "[e" (lambda [] (vim.diagnostic.goto_prev {:severity 1})) {:desc "Prev Error" })
(map "n" "]w" (lambda [] (vim.diagnostic.goto_next {:severity 2})) {:desc "Next Warning" })
(map "n" "[w" (lambda [] (vim.diagnostic.goto_prev {:severity 2})) {:desc "Prev Warning" })

(map "n" "<leader>qq" "<cmd>qa<cr>" {:desc "Quit All" })

(map "n" "<leader>ui" vim.show_pos {:desc "Inspect Pos" })
(map "n" "<leader>uI" "<cmd>InspectTree<cr>" {:desc "Inspect Tree" })

(map "t" "<C-/>" "<cmd>close<cr>" {:desc "Hide Terminal" })
(map "t" "<c-_>" "<cmd>close<cr>" {:desc "which_key_ignore" })

(map "n" "<leader>w" "<c-w>" {:desc "Windows" :remap true })
(map "n" "<leader>-" "<C-W>s" {:desc "Split Window Below" :remap true })
(map "n" "<leader>|" "<C-W>v" {:desc "Split Window Right" :remap true })
(map "n" "<leader>wd" "<C-W>c" {:desc "Delete Window" :remap true })

(map "n" "<leader><tab>l" "<cmd>tablast<cr>" {:desc "Last Tab" })
(map "n" "<leader><tab>o" "<cmd>tabonly<cr>" {:desc "Close Other Tabs" })
(map "n" "<leader><tab>f" "<cmd>tabfirst<cr>" {:desc "First Tab" })
(map "n" "<leader><tab><tab>" "<cmd>tabnew<cr>" {:desc "New Tab" })
(map "n" "<leader><tab>]" "<cmd>tabnext<cr>" {:desc "Next Tab" })
(map "n" "<leader><tab>d" "<cmd>tabclose<cr>" {:desc "Close Tab" })
(map "n" "<leader><tab>[" "<cmd>tabprevious<cr>" {:desc "Previous Tab" })

(when (= (vim.fn.has "nvim-0.11") false)
  (map ["i" "s"] "<Tab>" (lambda [] (if (vim.snippet.active {:direction 1}) "<cmd>lua vim.snippet.jump(1)<cr>" "<Tab>")) {:expr true :desc "Jump Next"})
  (map ["i" "s"] "<S-Tab>" (lambda [] (if (vim.snippet.active {:direction -1}) "<cmd>lua vim.snippet.jump(-1)<cr>" "<S-Tab>")) {:expr true :desc "Jump Previous"}))
nil
