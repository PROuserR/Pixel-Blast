# frozen_string_literal: true

require_relative './json_processor'

# Useful functions to consume
module RandomGenerator
  module_function

  ASSETS_DIR = File.join(__dir__, '..', '..', '/assets')

  def asset(name)
    File.join(ASSETS_DIR, name)
  end

  # Define the path to the target folder (outside current directory)
  def random_file_from_subfolders
    # content = File.read('./config.txt')

    settings_file_path = File.join(__dir__, '..', '..', 'settings.json')
    processor = JsonProcessor.new(settings_file_path)

    content = ''
    content = processor.get('image_path') if !processor.get('image_path').nil? && !processor.get('image_path').empty?

    return content unless content.empty?

    target_folder = 'assets/Card_Sets' # or use an absolute path like "/home/user/images"
    # Get all files in that folder (adjust pattern as needed)
    folders = Dir.glob(File.join(target_folder, '*'))
    # Select one random file
    Dir.glob(File.join(folders.sample, '*')).sample
  end

  def random_vivid_color
    hue = rand(360) # Full spectrum
    saturation = rand(60..99)         # 60–100%
    value = rand(70..99)              # 70–100%
    Gosu::Color.from_hsv(hue, saturation / 100.0, value / 100.0)
  end

  def generate_unique_random(avoided_number, range)
    random_number = rand(range)
    loop do
      break if random_number != avoided_number

      random_number = rand(range)
    end
    random_number
  end
end
