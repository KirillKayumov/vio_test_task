desc "Import locations from a CSV file"
task :import_locations, %i[filepath] => [:environment] do |_task, args|
  results = Geolocation::Importer.new(filepath: args[:filepath]).call

  puts "Completed in #{results[:time_elapsed]}. #{results[:accepted_count]} accepted, #{results[:rejected_count]} rejected."
end
