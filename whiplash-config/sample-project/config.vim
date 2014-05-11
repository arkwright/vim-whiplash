"""
" Put your project-specific Vimscript configuration here!
" 
" Don't forget to set `g:WhiplashConfigDir` in your `.vimrc` first!
"
" Remember that this file will not be executed unless it is located in a
" folder with the same name as the project name which you provide to
" Whiplash when invoking the :Whiplash command.
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
" COPY FILES
"
" You can tell Whiplash to automatically copy any file from your
" Whiplash project config directory into the main project directory by
" using this command. This is great for specifying your preferred
" version of a specific file when working in a team environment.
"
" Intermediate directories will be created. Existing files of the same
" name in the main project directory will be overwritten.
"
" Some interesting examples of usage are below.
"""

" WhiplashCopyFile somefile.txt
" WhiplashCopyFile .agignore
" WhiplashCopyFile .gitignore
" WhiplashCopyFile deeply/nested/file.txt



"""
" IGNORE FILES
"
" Often you will want Vim to ignore certain files in a project. `:set
" wildignore` is Vim's built-in way of doing this.
"
" Command-T/ctrlp and other plugins use the `wildignore` option when
" filtering the results they display to you. A decent `wildignore` can
" speed up these plugins when working with projects containing large
" numbers of files.
"
" The `set wildignore=` line clears your current `wildignore` setting so
" that you are starting from scratch when configuring `wildignore` for
" this project.
"""

" set wildignore=
" set wildignore+=some/dir/you/want/to/ignore/
" set wildignore+=ignore_all_files_under_this_dir/**
