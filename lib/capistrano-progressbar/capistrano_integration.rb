require 'capistrano'
require 'capistrano/version'

module CapistranoProgressbar
  class CapistranoIntegration
    def self.load_into(capistrano_config)
      capistrano_config.load do
        # load progressbar
        require 'progressbar'
        # check wether the command is existed
        def shell_command_exists?(command)
          ENV['PATH'].split(File::PATH_SEPARATOR).any?{|d| File.exists? File.join(d, command) }
        end
        # get the banner
        def get_banner
          cap_banner = <<-BANNER
 ######     ###    ########  ####  ######  ######## ########     ###    ##    ##  #######  
##    ##   ## ##   ##     ##  ##  ##    ##    ##    ##     ##   ## ##   ###   ## ##     ## 
##        ##   ##  ##     ##  ##  ##          ##    ##     ##  ##   ##  ####  ## ##     ## 
##       ##     ## ########   ##   ######     ##    ########  ##     ## ## ## ## ##     ## 
##       ######### ##         ##        ##    ##    ##   ##   ######### ##  #### ##     ## 
##    ## ##     ## ##         ##  ##    ##    ##    ##    ##  ##     ## ##   ### ##     ## 
 ######  ##     ## ##        ####  ######     ##    ##     ## ##     ## ##    ##  #######  
 BANNER
          banner = cap_banner.split(/\n/).map(&:chomp)
          banner = File.readlines('./config/banner').map(&:chomp!) if File.exist? './config/banner'
          banner
        end
        # get the current terminal size
        def get_terminal_size
          terminal_size ||= {}
          if ENV["LINES"] && ENV["COLUMNS"]
            terminal_size["lines"] = ENV["LINES"]
            terminal_size["columns"] = ENV["COLUMNS"]
          elsif (RUBY_PLATFORM =~ /java/ || (!STDIN.tty? && ENV['TERM'])) && shell_command_exists?('tput')
            terminal_size["lines"] = `tput lines`.strip.to_i
            terminal_size["columns"] = `tput cols`.strip.to_i
          elsif STDIN.tty? && shell_command_exists?('stty')
            terminal_size["lines"], terminal_size["columns"] = `stty size`.strip.split(/\s/).map(&:to_i)
          else
            terminal_size["lines"], terminal_size["columns"] = 40, 90
          end
          terminal_size
        end

        # Get the task count to be executed
        # To be fixed
        def get_task_count
          variables.has_key?(:task_count) ? variables[:task_count] : 14
        end

        @terminal_size = get_terminal_size
        @banner = get_banner

        #Initialize the ProgressBar
        $bar = ProgressBar.new('Fire', get_task_count)
        $bar.bar_mark = '='

        #Clear the screen and cup the cursor postion and display the banner
        row_position= (@terminal_size["columns"] - @banner[0].size)/2
        system  "tput clear && tput cup 1 #{row_position}"
        @banner.each_with_index do |line,index|
          system "tput cup #{index + 2} #{row_position}"
          puts line
        end
        # put the progressbar at the middle of the terminal
        system  "tput cup #{@terminal_size["lines"]/2} 0"

        #cleanup the releases
        after "deploy", "deploy:cleanup"
        # set the callback to update the progressbar
        on :after, :only => 'deploy:clean' do
          system "tput clear"
        end
        on :after do
          $bar.inc
        end
      end
    end
  end
end
if Capistrano::Configuration.instance
  CapistranoProgressbar::CapistranoIntegration.load_into(Capistrano::Configuration.instance)
end
