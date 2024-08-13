module CustomTitleScreen
  CONFIG = {
    font: {
      name: "Nunito",
      size: 32,
    },
    color: { # RGBA format
      text: [31, 37, 37, 255],
      outline: [181, 161, 128, 255],
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
  def draw_text(*args)
    old_f = contents.font.name
    contents.font.name = CustomTitleScreen::CONFIG[:font][:name]
    contents.font.size = font_size
    contents.font.color = Color.new(*CustomTitleScreen::CONFIG[:color][:text])
    contents.font.out_color = Color.new(*CustomTitleScreen::CONFIG[:color][:outline])

    contents.draw_text(*args)

    contents.font.name = old_f
    reset_font_settings # Reset font size and color; cf Yanfly Core; might not be strictly necessary, but better safe than sorry
  end

  def line_height
    font_size
  end

  def font_size
    CustomTitleScreen::CONFIG[:font][:size]
  end

  # Align text right
  def alignment
    2
  end

  def update_placement
    self.x = Graphics.width - width
    self.y = 0
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
  def update_cursor
    if @selector.nil?
      @selector = Sprite.new
      @selector.visible = true
      @selector.z = z+1
      @selector.bitmap = CustomTitleScreen.bitmap("selector")
    end

    i_rect = item_rect(@index)
    @selector.x = x + i_rect.x
    @selector.y = y + i_rect.y
  end
end
