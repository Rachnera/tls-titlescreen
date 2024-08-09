module CustomTitleScreen
  CONFIG = {
    font: {
      name: "Nunito",
    },
  }
end

class Scene_Title < Scene_Base
  alias original_879_create_command_window create_command_window
  def create_command_window
    original_879_create_command_window
    @command_window.windowskin = Cache.system("TitleScreen")
  end
end

class Window_TitleCommand < Window_Command
  def draw_text(*args)
    old_f = contents.font.name
    contents.font.name = CustomTitleScreen::CONFIG[:font][:name]

    contents.draw_text(*args)

    contents.font.name = old_f

    if args[1] == 'Patreon'
      draw_patreon_logo(args[0])
    end
  end

  def alignment
    1
  end

  # FIXME Pretty fragile function
  # Likely to put the logo(s) in weird spots if basically anything else changes on the screen
  def draw_patreon_logo(text_rect)
    logo = Cache.picture("Patreon_logo_16x16")
    contents.blt(text_rect.x + 8, text_rect.y + 4, logo, logo.rect)
    contents.blt(text_rect.x + text_rect.width - 24, text_rect.y + 4, logo, logo.rect)
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
end
