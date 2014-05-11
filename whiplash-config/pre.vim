"""
" Put your global, pre-project-specific Vimscript configuration here!
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
" SYNCHRONIZE VIM CURRENT WORKING DIRECTORY
"
" This is a convenience command which changes Vim's current working
" directory to be the main directory of the project you are switching
" to.
"
" It is uncommented in this file because it is strongly recommended that
" you use it as part of your own Whiplash config. Lots of other Vim
" plugins pay close attention to Vim's current working directory, and
" one of Whiplash's main benefits is that it makes it easy to switch the
" Vim current working directory.
"""

WhiplashCD



"""
" RESET WILDIGNORE
"
" Often you will want Vim to ignore certain files in a project. `:set
" wildignore` is Vim's built-in way of doing this.
"
" But for projects where you *don't* want Vim to ignore any files,
" `wildignore` can be frustrating. If you forget to reset it when
" changing projects, any project-specific `wildignore` settings might
" confound you until you realize that `wildignore` needs to be reset.
"
" This line clears your current `wildignore` setting so that you are
" starting with a nice, blank `wildignore` for each project.
"""

" set wildignore=
