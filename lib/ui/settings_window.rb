# frozen_string_literal: true

require 'gosu'
require 'clipboard'
require_relative '../utils/random_generator'
require_relative '../media/media_loader'
require_relative './button'
require_relative '../utils/json_processor'

class SettingsWindow < Gosu::Window
  def initialize(width, height)
    super(width, height, resizable: false)
    @hard_toggled_image = Gosu::Image.new(RandomGenerator.asset('toggle/hard.png'))
    @easy_toggled_image = Gosu::Image.new(RandomGenerator.asset('toggle/easy.png'))
    @is_easy = true
    processor = JsonProcessor.new('./settings.json')
    @is_easy = processor.get('is_easy') unless processor.get('is_easy').nil?
    @is_toggle_button_clicked = false
    @loader = MediaLoader.new

    @btn_open_file_dialog = Button.new(
      x: 50, y: 175, width: 300, height: 50,
      label: 'Set Custom Image',
      font: @loader.font_subtitle,
      bg_color: Gosu::Color::GRAY,
      hover_color: RandomGenerator.random_vivid_color,
      text_color: Gosu::Color::BLACK
    )

    @btn_save = Button.new(
      x: 50, y: 250, width: 300, height: 50,
      label: 'Save',
      font: @loader.font_subtitle,
      bg_color: Gosu::Color::GRAY,
      hover_color: RandomGenerator.random_vivid_color,
      text_color: Gosu::Color::BLACK
    )
  end

  def mouse_over_toggle?
    if @is_easy
      mouse_x.between?(220, 220 + @easy_toggled_image.width / 10) &&
        mouse_y.between?(25, 25 + @easy_toggled_image.height / 15)
    else
      mouse_x.between?(220, 220 + @hard_toggled_image.width / 10) &&
        mouse_y.between?(25, 25 + @hard_toggled_image.height / 15)
    end
  end

  def button_down(id)
    if @btn_open_file_dialog.clicked?(mouse_x, mouse_y)
      clipboard_value = Clipboard.paste

      @filename = clipboard_value.encode("UTF-8")

      # Print the value
      puts "The last clipboard value is: #{@filename}"

    end

    if @btn_save.clicked?(mouse_x, mouse_y)
      processor = JsonProcessor.new('settings.json')
      processor.update('is_easy', @is_easy)
      processor.update('image_path', @filename)
      processor.save # writes pretty JSON by default
    end
    return unless mouse_over_toggle?

    @is_easy = !@is_easy
    @is_toggle_button_clicked = true
  end

  def draw
    @loader.font.draw_text('Difficulty:', 25, 40, 0, 2, 2, 0xff_ffffff)
    @btn_open_file_dialog.draw(@btn_open_file_dialog.x, @btn_open_file_dialog.y)
    @btn_save.draw(@btn_save.x, @btn_save.y)

    if @is_easy
      @easy_toggled_image.draw(220, 5, 1, 0.1, 0.1)
    else
      @hard_toggled_image.draw(220, 5, 1, 0.1, 0.1)
    end
  end
end

# run
settings_window = SettingsWindow.new(400, 325)
settings_window.caption = 'Settings'
settings_window.show