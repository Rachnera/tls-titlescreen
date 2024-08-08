module CustomTitleScreen
  CONFIG = {
    font: {
      name: "Nunito",
    }
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
  end
end
