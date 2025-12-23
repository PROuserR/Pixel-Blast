# frozen_string_literal: true

require './lib/ui/window'
require_relative './lib/utils/json_processor'

# load the settings
processor = JsonProcessor.new('./settings.json')

is_easy = true
is_easy = processor.get('is_easy') unless processor.get('is_easy').nil?

# run
window = if is_easy == true
           PixelblastWindow.new(400, 600)
         else
           PixelblastWindow.new(800, 1000)
         end
window.random_block_id = rand(8)
window.caption = 'Pixel Blast'
window.show
