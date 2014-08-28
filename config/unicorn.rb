# UNICORN CONF see below for more info
# http://unicorn.bogomips.org/examples/unicorn.conf.minimal.rb
# http://unicorn.bogomips.org/Unicorn/Configurator.html for docs

rails_env = ENV['RAILS_ENV'] || 'production'

rails_root = "/home/rubby/dashboard"

# Use at least one worker per core if you're on a dedicated server,
# more will usually help for _short_ waits on databases/caches.
# 6 is the old spreedly number (feel free to change if necessary)
worker_processes 6

# Since Unicorn is never exposed to outside clients, it does not need to
# run on the standard HTTP port (80), there is no reason to start Unicorn
# as root unless it's from system init scripts.
# If running the master process as root and the workers as an unprivileged
# user, do this to switch euid/egid in the workers (also chowns logs):
# user "unprivileged_user", "unprivileged_group"

# Help ensure your application will always spawn in the symlinked
# "current" directory that Capistrano sets up.
working_directory rails_root # available in 0.94.0+

# listen on both a Unix domain socket and a TCP port,
# we use a shorter backlog for quicker failover when busy
listen "/tmp/dashboard.unicorn.sock", :backlog => 64

# use spreedly existing timeout value
timeout 70

# feel free to point this anywhere accessible on the filesystem
pid_path = "/tmp/unicorn.pid"
pid pid_path

# By default, the Unicorn logger will write to stderr.
# Additionally, ome applications/frameworks log to stderr or stdout,
# so prevent them from going to /dev/null when daemonized here:
stderr_path "#{rails_root}/logs/unicorn.stderr.log"
stdout_path "#{rails_root}/logs/unicorn.stdout.log"

# combine Ruby 2.0.0dev or REE with "preload_app true" for memory savings
# http://rubyenterpriseedition.com/faq.html#adapt_apps_for_cow
preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

# from old spreedly unicorn.rb (must ask nath what it's for)
before_exec do |server|
  ENV.each do |k,v|
    next if k =~ /^UNICORN/
    if OLD_ENV[k]
      ENV[k] = OLD_ENV[k]
    else
      ENV[k] = nil
    end
  end
end

before_fork do |server, worker|
  # the following is highly recomended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!

  # The following is only recommended for memory/DB-constrained
  # installations.  It is not needed if your system can house
  # twice as many worker_processes as you have configured.
  #
  # # This allows a new master process to incrementally
  # # phase out the old master process with SIGTTOU to avoid a
  # # thundering herd (especially in the "preload_app false" case)
  # # when doing a transparent upgrade.  The last worker spawned
  # # will then kill off the old master process with a SIGQUIT.
  # old_pid = "#{server.config[:pid]}.oldbin"
  # if old_pid != server.pid
  #   begin
  #     sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
  #     Process.kill(sig, File.read(old_pid).to_i)
  #   rescue Errno::ENOENT, Errno::ESRCH
  #   end
  # end
  #
  # Throttle the master from forking too quickly by sleeping.  Due
  # to the implementation of standard Unix signal handlers, this
  # helps (but does not completely) prevent identical, repeated signals
  # from being lost when the receiving process is busy.
  # sleep 1
end

after_fork do |server, worker|
  # per-process listener ports for debugging/admin/migrations
  # addr = "127.0.0.1:#{9293 + worker.nr}"
  # server.listen(addr, :tries => -1, :delay => 5, :tcp_nopush => true)

  # the following is *required* for Rails + "preload_app true",
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection

  ##
  # When sent a USR2, Unicorn will suffix its pidfile with .oldbin and
  # immediately start loading up a new version of itself (loaded with a new
  # version of our app). When this new Unicorn is completely loaded
  # it will begin spawning workers. The first worker spawned will check to
  # see if an .oldbin pidfile exists. If so, this means we've just booted up
  # a new Unicorn and need to tell the old one that it can now die. To do so
  # we send it a QUIT.
  #
  # Using this method we get 0 downtime deploys.

  old_pid = "#{pid_path}.oldbin"

  if File.exists?(old_pid) && server.pid != old_pid
    begin
      # make sure we don't send the winch and quit if we are the new master
      if File.read(old_pid).to_i != Process.pid
        Process.kill("WINCH", File.read(old_pid).to_i)
        sleep 0.2 # pause to give the master a second to register the winch
        Process.kill("QUIT", File.read(old_pid).to_i)
      end
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end

end
