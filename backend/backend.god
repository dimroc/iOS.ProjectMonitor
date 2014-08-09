# vim: ft=ruby

full_dir = File.join(File.dirname(__FILE__))
God.watch do |w|
  w.name = "producer"
  w.dir = File.join(File.dirname(__FILE__))

  full_path = File.join(full_dir, 'producer.rb')
  w.start = "bundle exec ruby #{full_path}"
  w.log = '/tmp/pm_producer.log'
  w.keepalive
end

God.watch do |w|
  w.name = "worker"
  w.dir = File.join(File.dirname(__FILE__))
  w.start = "bundle exec sidekiq -c 25 -r #{File.join(full_dir, 'bootstrap.rb')}"
  w.log = '/tmp/pm_worker.log'
  w.keepalive
end
