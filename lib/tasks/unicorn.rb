namespace :unicorn do
  desc "Start unicorn"
  task :start do
    config_file = "#{rails_root}/config/unicorn.rb"
    sh "bundle exec unicorn --daemonize --config-file #{config_file}"
  end

  desc "Stop unicorn"
  task :stop do
    unicorn_signal(:QUIT)
  end

  desc "Gracefully stop unicorn"
  task :graceful_stop do
    unicorn_signal(:TERM)
  end

  desc "Gracefully restart unicorn"
  task :restart do
    begin
      unicorn_signal(:USR2)
    rescue Errno::ESRCH, Errno::ENOENT
      Rake::Task["unicorn:start"].execute
    end
  end

  def unicorn_signal(signal)
    Process.kill(signal, unicorn_pid)
  end

  def unicorn_pid
    File.read("/tmp/unicorn.pid").to_i
  end

  def rails_root
    File.expand_path(File.dirname(__FILE__)+ "../../..")
  end
end
