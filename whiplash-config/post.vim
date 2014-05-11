"""
" Put your global, post-project-specific Vimscript configuration here!
"
" Don't forget to set `g:WhiplashConfigDir` in your `.vimrc` first!
"
" Every time you change projects, Whiplash executes these scripts in the
" following order:
"
" pre.vim
" project/config.vim
" post.vim
"
" Some example commands follow.
"""



"""
" SYNCHRONIZING NERDTREE
"
" Many people enjoy the NERDTree plugin. You can force NERDTree to sync
" with the current Whiplash project's root directory by using the
" following command, which is provided by the NERDTree plugin.
"
" I prefer NERDTree to stay synchronized for *every* project, but if you
" only want it to do so for certain projects, you could add the command
" to that project's `config.vim` instead.
"""

" NERDTreeCWD



"""
" CLEAR COMMAND-T/CTRLP CACHE
"
" The Command-T/CtrlP plugins cache their results, which can produce
" incorrect search results unless they are regularly flushed. You can
" make it easier to flush the cache by simply adding their built-in
" flushing commands to your Whiplash config. Now you don't have to
" remember which command flushes the cache; you can just treat Whiplash
" as a 'reset everything' utility.
"""

" CommandTFlush
" CtrlPClearCache
