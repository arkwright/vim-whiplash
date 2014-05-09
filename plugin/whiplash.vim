" User config via:
"
" let g:WhiplashProjectsDir = '/wherever/the/users/projects/are/located'
" let g:WhiplashConfigDir = 'location/of/whiplash/project/config/files'
" let g:WhiplashCommandName = 'CustomCommandNameToInvokeWhiplash"

let g:WhiplashCurrentProject = ""

" Allow the user to specify the directory where project-specific configuration
" files will be stored. Fallback to a default value if nothing is specified.
if exists("g:WhiplashConfigDir") ==# 0   ||   g:WhiplashConfigDir ==# ""
  let g:WhiplashConfigDir = "~/.vim/bundle/vim-whiplash/projects/"
endif

" Allow the user to specify the command name which will invoke Whiplash.
" Fallback to a default value if nothing is specified.
if exists("g:WhiplashCommandName") ==# 0   ||   g:WhiplashCommandName ==# ""
  let g:WhiplashCommandName = "Whiplash"
endif

" Dynamically create the Whiplash invocation command, unless an identically
" named command already exists.
if exists(":" . g:WhiplashCommandName) ==# 0
  execute "command! -complete=custom,WhiplashProjectNameAutocomplete -nargs=1 " . g:WhiplashCommandName . " call WhiplashUseProject (<f-args>)"
endif

" Create a convenient command for invoking the WhiplashCD() function.
if exists(":WhiplashCD") ==# 0
  execute "command! WhiplashCD call WhiplashCD()"
endif

" Accept any number of arguments.
function WhiplashUseProject(...)
  " If an argument was not passed, do nothing.
  if a:0 !=# 1
    return
  endif

  " The project name is the value of the first and only argument.
  let projectName = a:1

  " TODO: Convert this global substitution to a simple strip of leading and trailing quotes.
  " Remove any quotation marks from the project name, which can be
  " accidentally added if Whiplash is invoked like so:
  " Whiplash 'projectname'
  let projectName = substitute(projectName, '"', '', 'g')
  let projectName = substitute(projectName, "'", "", "g")

  " TODO: If user invokes :Whiplash someproject/, strip the trailing slash.
  let g:WhiplashCurrentProject = projectName

  " Determine if a configuration file for the new project exists.
  " expand() is necessary to convert tilde (~) into the user's $HOME
  " directory, and other fancy wildcard replacement magic.
  " filereadable() checks if the specified file exists.
  let globalPreConfigFilePath = expand(g:WhiplashConfigDir . "pre.vim")
  let globalPostConfigFilePath = expand(g:WhiplashConfigDir . "post.vim")
  let projectConfigFilePath = expand(g:WhiplashConfigDir . projectName . "/config.vim")

  let globalPreConfigFileExists = filereadable(globalPreConfigFilePath)
  let globalPostConfigFileExists = filereadable(globalPostConfigFilePath)
  let projectConfigFileExists = filereadable(projectConfigFilePath)

  " Run the global pre-config Vimscript file if it exists.
  if globalPreConfigFileExists
    execute "source" globalPreConfigFilePath
  endif

  " Run the project config Vimscript file if it exists.
  if projectConfigFileExists
    execute "source" projectConfigFilePath
  endif

  " Run the global post-config Vimscript file if it exists.
  if globalPostConfigFileExists
    execute "source" globalPostConfigFilePath
  endif

  " TODO: CHECK IF PROJECT DIRECTORY EXISTS. IF NOT, DON'T RUN WHIPLASH
  " SCRIPTS ABOVE.
endfunction

function WhiplashCD()
  " If no projct has been selected, do nothing.
  if g:WhiplashCurrentProject ==# ""
    return
  endif

  " Simply calling this throws an error:
  " cd g:WhiplashProjectProjectsDir
  "
  " fnamescape() is for safety when treating strings as file paths.
  execute "cd" fnameescape(g:WhiplashProjectsDir . g:WhiplashCurrentProject . "/")
endfunction

" Returns a newline-separated string of Whiplash project directory names.
"
" @return   string
function WhiplashGetProjectNamesString()
  " Gets a newline-separated list of all directory names within the Whiplash projects directory.
  let projectNames = system("ls -FP " . g:WhiplashProjectsDir)

  " Removes trailing / characters from directory names.
  let projectNames = substitute(projectNames, '/', '', 'g')

  return projectNames
endfun

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
function WhiplashProjectNameAutocomplete(ArgLead, CmdLine, CursorPos)
  let projectNames = WhiplashGetProjectNamesString()

  return projectNames
endfun
