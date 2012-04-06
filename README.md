# Capistrano Progressbar

Capistrano plugin that integrates Progressbar tasks into capistrano deployment script.

## Installation

    gem install capistrano-progressbar
    # or add it to Gemfile
    gem 'capistrano-progressbar'
## Usage

    # Set the variable in the deploy file
    require 'capistrano-progressbar'
    set :task_count, '14'   #the task count to be executed
## Banner

Put the banner file into `config/banner` file,if the file is not existed the default banner will be used.
You can get more banners at [Text Ascii Art Generator](http://patorjk.com/software/taag/)
    
## Alias

Put the alias command into `~/.bashrc` or `.rvmrc`

    alias deploy='bundle exec cap deploy -l "./log/capistrano.log"'
    
Then you can use `deploy` to execute `cap deploy` with fire the progressbar at the terminal

## Screenshot
![Fire](http://i.imgur.com/GF6QE.jpg)
## License
MIT: http://rem.mit-license.org
