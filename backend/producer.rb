require_relative 'bootstrap'

scheduler = Rufus::Scheduler.new

def poll_parse
  puts "#{DateTime.now}: Starting Poll"
  ParseClient.from_settings.fetch_valid_builds.each do |build|
    puts "#{DateTime.now}: enqueuing #{build}"
    UpdateBuildWorker.perform_async(build)
  end
rescue => e
  puts "## ERROR: #{e.message}"
end

scheduler.every '120', first: :now, overlap: false do
  poll_parse
end

scheduler.join
