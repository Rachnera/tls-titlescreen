## Setup

- Copy the `Graphics/` and `Fonts/` folders to the root of the project
- Add the `CustomTitleScreen.rb` file as a new script

## How to

### Change the font used

- Drop the file(s) of the new font you wish to use in the `Fonts/` folder of the game
- Change the `font` -> `name` variable in the config of the script

See [there](https://forums.rpgmakerweb.com/index.php?threads/how-do-i-font-change-vx-ace.136293/#post-1186160) for help with debugging some common issues (typo, folder hierarchy, etc.)

### Change text colors

Update the config parameters `color` -> `text`, `color` -> `outline` and/or `color` -> `disabled` with the RGBA values of the desired color(s).
