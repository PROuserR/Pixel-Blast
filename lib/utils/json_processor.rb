require 'json'

class JsonProcessor
  attr_reader :data

  def initialize(file_path)
    @file_path = file_path
    @data = load_file
  end

  # Load JSON file into Ruby hash/array
  def load_file
    if File.exist?(@file_path)
      content = File.read(@file_path)
      JSON.parse(content)
    else
      {} # default to empty hash if file doesn't exist
    end
  rescue JSON::ParserError => e
    puts "Error parsing JSON: #{e.message}"
    {}
  end

  # Save current @data back to file
  def save(pretty: true)
    json_string = pretty ? JSON.pretty_generate(@data) : JSON.generate(@data)
    File.write(@file_path, json_string)
  end

  # Update a key/value pair in the JSON
  def update(key, value)
    if @data.is_a?(Hash)
      @data[key] = value
    else
      puts "Update only works on Hash data"
    end
  end

  # Get a value by key
  def get(key)
    @data[key]
  end

  # Delete a key
  def delete(key)
    @data.delete(key) if @data.is_a?(Hash)
  end

  # Print JSON nicely
  def print
    puts JSON.pretty_generate(@data)
  end
end