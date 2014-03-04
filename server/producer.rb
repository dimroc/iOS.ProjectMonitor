require_relative 'bootstrap'

scheduler = Rufus::Scheduler.new

def poll_parse
  ParseClient.from_settings.fetch_builds.each do |build|
    puts "enqueuing #{build}"
    UpdateBuildWorker.perform_async(build)
  end
rescue => e
  puts e.message
end

scheduler.every '1m', first: :now, overlap: false do
  poll_parse
end

scheduler.join
