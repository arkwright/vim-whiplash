" User config via:
"
" let g:WhiplashProjectsDir = '/wherever/the/users/projects/are/located'
" let g:WhiplashConfigDir = 'location/of/whiplash/project/config/files'
" let g:WhiplashCommandName = 'CustomCommandNameToInvokeWhiplash"

let g:WhiplashCurrentProject          = ''
let g:WhiplashCurrentProjectConfigDir = ''
let g:WhiplashCurrentProjectPath      = ''

" Allow the user to specify the directory where project-specific configuration
" files will be stored. Fallback to a default value if nothing is specified.
if exists("g:WhiplashConfigDir") ==# 0   ||   g:WhiplashConfigDir ==# ''
  let g:WhiplashConfigDir = "~/projects/dotfiles/whiplash-config/"
endif

" Allow the user to specify the command name which will invoke Whiplash.
" Fallback to a default value if nothing is specified.
if exists("g:WhiplashCommandName") ==# 0   ||   g:WhiplashCommandName ==# ''
  let g:WhiplashCommandName = "Whiplash"
endif

" Dynamically create the Whiplash invocation command, unless an identically
" named command already exists.
if exists(":" . g:WhiplashCommandName) ==# 0
  execute "command! -complete=custom,s:WhiplashProjectNameAutocomplete -nargs=? " . g:WhiplashCommandName . " call s:WhiplashUseProject (<f-args>)"
endif

" Create a convenient command for invoking the WhiplashCD() function.
if exists(":WhiplashCD") ==# 0
  execute "command! WhiplashCD call s:WhiplashCD()"
endif

" Create a convenient command for invoking the WhiplashCopyFile() function.
if exists(":WhiplashCopyFile") ==# 0
  execute "command! -nargs=? WhiplashCopyFile call s:WhiplashCopyFile(<f-args>)"
endif

" Create a convenient command for invoking the WhiplashEchoProjectName() function.
if exists(":WhiplashEchoProjectName") ==# 0
  execute "command! WhiplashEchoProjectName call s:WhiplashEchoProjectName()"
endif

"""
" The main Whiplash invocation function.
" If called with a string argument, switches the Whiplash current project to the specified project.
" If called without an argument, outputs Whiplash status information.
"
" @param   string    a:1    The name of the project to switch to.
"""
function! s:WhiplashUseProject(...)
  " If an argument was not passed, simply output information about the
  " current Whiplash state.
  if a:0 !=# 1
    echo "Current Project : " . g:WhiplashCurrentProject
    echo "Project Path    : " . g:WhiplashCurrentProjectPath
    echo "Vim Working Dir : " . getcwd()
    return
  endif

  " The project name is the value of the first and only argument.
  let l:projectName = s:trim(a:1)

  " Remove quotation marks from the beginning and end of the project name,
  " which can be accidentally added if Whiplash is invoked like so:
  " Whiplash 'projectname'
  let l:projectName = s:trim(l:projectName, '"')
  let l:projectName = s:trim(l:projectName, "'")

  " Remove trailing slashes from the project name, which can be accidentally
  " added if Whiplash is invoked like so:
  " Whiplash projectname/
  let l:projectName = s:trim(l:projectName, '/')
  let l:projectName = s:trim(l:projectName, '\\')

  " Set current project and its associated filesystem path.
  let g:WhiplashCurrentProject = l:projectName
  let g:WhiplashCurrentProjectConfigDir = g:WhiplashConfigDir . l:projectName . '/'
  let g:WhiplashCurrentProjectPath = g:WhiplashProjectsDir . l:projectName . '/'

  " Ensure that the project actually exists before trying to run its scripts
  " Resolve any symlinks that may be encountered
  if getftype(expand(g:WhiplashCurrentProjectPath)) == 'link'
    let l:simplified = resolve(expand(g:WhiplashCurrentProjectPath))
    if getftype(l:simplified) != 'dir'
      echoerr "Project '" . g:WhiplashCurrentProjectPath . "' does not exist or is not a directory!"
      return
    endif
  elseif getftype(expand(g:WhiplashCurrentProjectPath)) != 'dir'
    echoerr "Project '" . g:WhiplashCurrentProjectPath . "' does not exist or is not a directory!!"
    return
  endif

  " Determine if a configuration file for the new project exists.
  " expand() is necessary to convert tilde (~) into the user's $HOME
  " directory, and other fancy wildcard replacement magic.
  " filereadable() checks if the specified file exists.
  let l:globalPreConfigFilePath = expand(g:WhiplashConfigDir . "pre.vim")
  let l:globalPostConfigFilePath = expand(g:WhiplashConfigDir . "post.vim")
  let l:projectConfigFilePath = expand(g:WhiplashConfigDir . l:projectName . "/config.vim")

  let l:globalPreConfigFileExists = filereadable(l:globalPreConfigFilePath)
  let l:globalPostConfigFileExists = filereadable(l:globalPostConfigFilePath)
  let l:projectConfigFileExists = filereadable(l:projectConfigFilePath)

  " Run the global pre-config Vimscript file if it exists.
  if l:globalPreConfigFileExists
    execute "source" l:globalPreConfigFilePath
  endif

  " Run the project config Vimscript file if it exists.
  if l:projectConfigFileExists
    execute "source" l:projectConfigFilePath
  endif

  " Run the global post-config Vimscript file if it exists.
  if l:globalPostConfigFileExists
    execute "source" l:globalPostConfigFilePath
  endif
endfunction

"""
" Sets the Vim current directory to be the Whiplash project directory.
"""
function! s:WhiplashCD()
  " If no projct has been selected, do nothing.
  if g:WhiplashCurrentProject ==# ''
    return
  endif

  " Simply calling this throws an error:
  " cd g:WhiplashProjectProjectsDir
  "
  " fnamescape() is for safety when treating strings as file paths.
  execute "cd" fnameescape(g:WhiplashProjectsDir . g:WhiplashCurrentProject . "/")
endfunction

"""
" Copies a file at the specified path within the Whiplash
" project-specific config directory into the corresponding path
" within the project directory.
"
" @param    string    a:1    The path of the file to copy, relative
"                            to the root of both the project-specific
"                            config, and project, directories, e.g.,
"                            'somedir/somefile.txt'.
"""
function! s:WhiplashCopyFile(...)
  " If no path is given, throw an error and do nothing.
  if a:0 ==# 0
    echoe ":WhiplashCopyFile command requires a relative file path argument!"
    return
  endif

  " The project name is the value of the first and only argument.
  let l:filePath = a:1

  " Remove leading/trailing whitespace, quotes, and slashes.
  let l:filePath = s:trim(l:filePath)
  let l:filePath = s:trim(l:filePath, '"')
  let l:filePath = s:trim(l:filePath, "'")
  let l:filePath = s:trim(l:filePath, '/')
  let l:filePath = s:trim(l:filePath, '\')

  " fnamescape() is for safety when treating strings as file paths.
  let l:sourceFilePath    = fnameescape(expand(g:WhiplashCurrentProjectConfigDir . l:filePath))
  let l:destFilePath      = fnameescape(expand(g:WhiplashCurrentProjectPath . l:filePath))
  let l:destDirectoryPath = fnameescape(expand(s:dirname(g:WhiplashCurrentProjectPath . l:filePath)))

  " Throw an error if the source file cannot be found.
  if !filereadable(l:sourceFilePath)
    echoe 'WhiplashCopyFile cannot read this file to copy: ' . l:sourceFilePath
    return
  end

  " Create the destination directory, and intermediate directories,
  " if they do not exist.
  if !isdirectory(l:destDirectoryPath)
    call mkdir(l:destDirectoryPath, 'p')
  endif

  " Copy the file.
  let l:sourceFileContents = readfile(l:sourceFilePath, 'b')
  call writefile(l:sourceFileContents, l:destFilePath, 'b')

  " Check all buffers against the file stored on disk, and prompt the user
  " to reload the file if a conflict has occurred.
  checktime
endfunction

"""
" Echos the name of the current project.
"""
function! s:WhiplashEchoProjectName()
  echo g:WhiplashCurrentProject
endfunction

"""
" Returns a newline-separated string of Whiplash project directory names.
"
" @return   string    A newline-separated string of Whiplash project directory names.
"""
function! s:WhiplashGetProjectNamesString()
  " trim the leading path component from each project's name
  let l:trimlen = strlen(expand(g:WhiplashProjectsDir))
  return join(
        \map(
        \ filter(globpath(g:WhiplashProjectsDir, '*', 0, 1), 'isdirectory(v:val)'),
        \ 'strpart(v:val, l:trimlen)'),
        \"\n")
endfunction

"""
" Returns a newline-separated string of Whiplash project directory
" autocompletion suggestions.
"
" Vim executes this function when the user presses <tab> while entering
" an argument for the Whiplash invocation command.
"
" @param    string    ArgLead    The leading portion of the argument currently
"                                being completed on.
" @param    string    CmdLine    The entire command line.
" @param    integer   CursorPos  The cursor position within the command line
"                                (byte index)
"
" @return   string               A newline-separated string of project
"                                directory autocompletion suggestions.
"""
function! s:WhiplashProjectNameAutocomplete(ArgLead, CmdLine, CursorPos)
  let l:projectNames = s:WhiplashGetProjectNamesString()

  return l:projectNames
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Utility functions from: https://github.com/arkwright/vimscript-utility-belt
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""
" Given a string containing the path of a file or directory,
" returns the parent directory's path.
"
" @param    string    path    A file or directory path.
"
" @return   string            The parent directory's path.
"""
function! s:dirname(path)
  return fnamemodify(a:path, ':h')
endfunction

"""
" Trims the specified character from the beginning and the end of the
" specified string. Trims all repeats of the specified character.
" Returns the resulting string.
"
" If called without a characters argument, trims whitespace.
"
" @param    string    str     The string to be trimmed.
" @param    string    char    The character to remove from the string.
"
" @return   string            The result.
"""
function! s:trim(str, ...)
  let l:char = '\s'

  if a:0 ==# 1
    let l:char = a:1
  endif

  " \m   sets Vim's nomagic option for this regex. This ensures portability of the regex.
  " ^    matches the beginning of the string.
  " *    matches as many as possible of the preceding character
  " \(   begins a subexpression
  " .    matches any character
  " \{-} matches the previous character as few times as possible
  " \)   ends a subexpression
  " *    matches as many as possible of the preceding character
  " $    matches the end of the string
  let l:regex = '\m^' . l:char . '*\(.\{-}\)' . l:char . '*$'

  " \1   replaces the string with the first subexpression in the match
  let l:result = substitute(a:str, l:regex, '\1', '')

  return l:result
endfunction
