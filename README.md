# whiplash.vim

Easy project switcher for Vim.

## Why?

I switch between software projects frequently. Changing projects can be
a pain in Vim. For example, every time I want to work on a different
project, I have to call `:cd` to change my working directory, flush my
Command-T cache, synchronize my NERDTree root directory, and so on.

Enough with the madness!

I just want a simple way to change projects. Whiplash does that. Want to
change projects? It's as easy as:

    :Whiplash project-name

## Installation

Get [Pathogen](https://github.com/tpope/vim-pathogen), and then:

    cd ~/.vim/bundle
    git clone https://github.com/arkwright/vim-whiplash.git

## Usage

To change projects, simply invoke the `:Whiplash` command:

    :Whiplash project-name

Where `project-name` is the directory name of the project you want
Whiplash to switch to.

Of course, none of this will work until you complete the configuration
steps below.

## Configuration

Before you can use Whiplash, you need to tell it a little bit about
yourself.

Add this line to your `.vimrc` file:

    let g:WhiplashProjectsDir = "~/projects/"

Replace `~/projects/` with a path to the directory where you keep your
projects.

By default, you can switch projects using the `:Whiplash` command. If
you want to change the name of the command, add this line to your
`.vimrc` file:

    let g:WhiplashCommandName = "Project"

Replace `Project` with the command name that you prefer. With the
configuration shown above, you can invoke Whiplash to switch projects
like so:

    :Project project-name

The `project-name` part is, of course, the name of the project you want
to switch to.

By default, Whiplash doesn't really do anything. That's because you need
to tell it *what* to do when switching projects. Should the current
working directory be reset? Should NERDTree open? You decide! Whiplash
allows you to specify script Vimscript configuration files which should
be run when switching projects. Don't worry: it's not as complicated as
it sounds.

By default, Whiplash assumes you want to keep your project configuration
Vimscript files in this directory:

    ~/.vim/bundle/vim-whiplash/projects/

If you want to change the directory where the configuration files are
stored, add this line to your `.vimrc` file:

    let g:WhiplashConfigDir = "your/whiplash/configuration/dir"

Replace `your/whiplash/configuration/dir` with a path to the directory
where your configuration files are stored.

When switching projects, you provide Whiplash with a project name. That
project name is used to locate a Vimscript configuration file within
your Whiplash configuration directory. For example, if your project name
is `fubar`, and your Whiplash configuration directory is set to
`~/.vim/bundle/vim-whiplash/projects/`, then Whiplash will attempt to
execute all Vim commands inside these three files:

    ~/.vim/bundle/vim-whiplash/projects/pre.vim
    ~/.vim/bundle/vim-whiplash/projects/fubar/config.vim
    ~/.vim/bundle/vim-whiplash/projects/post.vim

Why three files? To give you more control over the project switching
process. The files are executed in the order listed above: `pre.vim`,
then `fubar/config.vim`, then finally `post.vim`.

`pre.vim` and `post.vim` are *global* configuration files. This means
they are executed *every time* you switch projects. The `config.vim`
file is the *project* configuration file: it is executed *only* when
switching *to* the project it is specified for.

Sample `pre.vim`, `post.vim`, and `projectname/config.vim` files are
provided to get you started. Feel free to modify or delete any of them.

## Configuration Commands

Inside any of the configuration files, you can call the `WhiplashCD`
command. This is equivalent to calling `:cd ~/projects/yourproject`, as
one would do to change the working directory back in the pre-Whiplash
days, when steam-power was still a disruptive innovation.
