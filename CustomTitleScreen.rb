module CustomTitleScreen
  CONFIG = {
    # If you change anything about the font, you'll likely want to change some of the +8, -4... below to make everything "perfectly" aligned again
    font: {
      name: "Amiri",
      size: 60,
      italic: true,
    },
    color: { # RGBA format
      text: [24, 33, 32, 255],
      outline: [165, 151, 117, 255],
      disabled: [165, 151, 117, 255],
    }
  }

  class << self
    def bitmap(filename)
      Cache.system("titlescreen/#{filename}")
    end
  end
end

class Scene_Title < Scene_Base
  alias original_879_create_command_window create_command_window
  def create_command_window
    original_879_create_command_window
    @command_window.windowskin = CustomTitleScreen.bitmap("Window")
  end
end

class Window_TitleCommand < Window_Command
  alias_method :original_879_initialize, :initialize
  def initialize
    original_879_initialize

    select_symbol(:new_game) if !continue_enabled
  end

  def draw_item(index)
    change_color(normal_color, command_enabled?(index))

    old_f = contents.font.name
    contents.font.name = CustomTitleScreen::CONFIG[:font][:name]
    contents.font.size = font_size
    contents.font.italic = CustomTitleScreen::CONFIG[:font][:italic]

    contents.font.color =
      if command_enabled?(index)
        Color.new(*CustomTitleScreen::CONFIG[:color][:text])
      else
        Color.new(*CustomTitleScreen::CONFIG[:color][:disabled])
      end
    contents.font.out_color = Color.new(*CustomTitleScreen::CONFIG[:color][:outline])

    draw_text(item_rect_for_text(index), command_name(index), alignment)

    contents.font.name = old_f
    reset_font_settings # Reset font size and color; cf Yanfly Core; might not be strictly necessary, but better safe than sorry
  end

  def line_height
    font_size
  end

  def font_size
    CustomTitleScreen::CONFIG[:font][:size]
  end

  def window_width
    240 # Could be anything wide enough for the text really?
  end

  # Align text right
  def alignment
    2
  end

  def update_placement
    self.x = Graphics.width - width
    self.y = -12
  end

  # Skip continue if disabled
  alias original_879_cursor_down cursor_down
  def cursor_down(wrap = false)
    if not continue_enabled and index+1 < @list.length and @list[index+1][:symbol] == :continue
      select(index+2)
      return
    end

    original_879_cursor_down(wrap)
  end
  alias original_879_cursor_up cursor_up
  def cursor_up(wrap = false)
    if not continue_enabled and index > 0 and @list[index-1][:symbol] == :continue
      select(index-2)
      return
    end

    original_879_cursor_up(wrap)
  end

  # Replace standard highlight with custom selector
  alias original_879_update update
  def update
    original_879_update

    if @selector.nil?
      @selector = Sprite.new
      @selector.bitmap = CustomTitleScreen.bitmap("Selectbar")
    end

    @selector.visible = open? && active

    i_rect = item_rect_for_text(@index)
    @selector.x = x + width - @selector.width - 7
    @selector.y = y + i_rect.y + i_rect.height - @selector.height + 3
    @selector.z = z + 1
  end

  def update_cursor
    # Do nothing, fully replaced with the above function
  end

  alias original_879_dispose dispose
  def dispose
    if @selector
      @selector.dispose
      @selector.bitmap.dispose
      @selector = nil
    end

    original_879_dispose
  end

  # FIXME Super weird stuff to fix ??? behavior with font scaling
  alias original_879_item_rect_for_text item_rect_for_text
  def item_rect_for_text(index)
    rect = original_879_item_rect_for_text(index)

    rect.y -= font_size/2 * index
    rect.y -= 6 * index

    rect
  end
end
