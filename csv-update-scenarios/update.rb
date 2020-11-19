require 'csv'
require 'json'

require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'rest-client'
  gem 'pastel'
end

def usage_and_exit!(code = 1)
  puts <<~TEXT
    Usage: ruby import.rb [server] [path-to-csv]

    For example:

      ruby import.rb beta values.csv
      ruby import.rb pro values.csv
      ruby import.rb http://localhost:3000 scenarios.csv
  TEXT

  exit(code)
end

# Main function which imports slider values based on a row in the CSV.
def import_row(server, row, pastel)
  scenario_id, *values = row
  print "Importing scenario #{scenario_id}... "

  RestClient.put(
    "#{server}/api/v3/scenarios/#{scenario_id}",
    { scenario: { user_values: user_values(values) } }.to_json,
    accept: :json, content_type: :json
  )

  puts pastel.green("done (#{values.length} user values).")
  true
rescue RestClient::NotFound
  puts pastel.red("scenario not found.")
  false
rescue RestClient::UnprocessableEntity => ex
  puts pastel.red("validation error.")

  JSON.parse(ex.http_body)['errors'].each do |msg|
    puts pastel.red("   * #{msg}")
  end

  false
end

# Takes the row values and returns a hash of user values.
def user_values(values)
  values.each_with_object({}) do |row_value, data|
    key, value = row_value.strip.split(/:\s?/)
    data[key] = Float(value)
  end
end

def pluralize(word, count)
  count == 1 ? word : "#{word}s"
end

# Validation
# ----------

server = ARGV[0]
file   = ARGV[1]
pastel = Pastel.new

if %w[staging beta].include?(server.downcase)
  server = 'https://beta-engine.energytransitionmodel.com'
elsif %[production pro live].include?(server.downcase)
  server = 'https://engine.energytransitionmodel.com'
end

if server.nil? || !server.start_with?('http')
  puts "Unknown server: #{server.inspect}"
  puts
  usage_and_exit!
end

if file.nil? || !File.exist?(file)
  puts "Could not find CSV file: #{file.inspect}\n"
  usage_and_exit!
end

# Off we go...
# ------------

puts 'Starting update of scenarios...'

updated = 0
failed = 0
unidentified = 0

CSV.read(file).each.with_index do |row, index|
  if row&.first =~ /^\d+$/
    if import_row(server, row, pastel)
      updated += 1
    else
      failed += 1
    end
  elsif !row.first.nil?
    puts pastel.red("Unidentified line starting with #{row.first.inspect} (line #{index + 1})")
    unidentified += 1
  end
end

puts

if updated.positive?
  puts "Successfully updated #{updated} #{pluralize('scenario', updated)}"
end

if failed.positive?
  puts "Failed to update #{failed} #{pluralize('scenario', failed)}"
end

if unidentified.positive?
  puts "Could not identify #{unidentified} #{pluralize('line', unidentified)} in the CSV"
end
