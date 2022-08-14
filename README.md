# MinimalistAwesomeWM

![Concept image](https://github.com/cdelaof26/MinimalistAwesomeWM/blob/main/images/Concept.jpeg?raw=true)

System   | Description
-------- | ----------- 
Distro   | Debian 11 (aarch64)
DE       | Xfce
Theme    | Adwaita / Adwaita-dark
Terminal | Xfce4-terminal


### Dependencies

- AwesomeWM
- rofi
- Python 3.6 or newer


### Shortcuts

You can see shortcuts any time by pressing `modkey + h`

Combination               | Description
------------------------- | -----------
`modkey + h`              | Show shortcuts
`modkey + tab`            | Focus next client by index
`modkey + shift + tab`    | Focus previous client by index
`modkey + u`              | Jump to urgent client
`modkey + f`              | Toggle fullscreen
`modkey + q`              | Close client
`modkey + t`              | Toggle on top (client)
`modkey + up`             | (un)maximize client
`modkey + right`          | View next (tag)
`modkey + left`           | View previous (tag)
`modkey + down`           | Minimize
`modkey + control + down` | Restore minimized
`modkey + control + r`    | Reload awesome
`modkey + control + q`    | Log out
`modkey + space`          | Show rofi (drun)
`modkey + return`         | Open terminal


### Installation

- Install awesomewm, rofi and python, you might need _root privileges_
<pre>
$ apt update
$ apt install awesomewm rofi python3
</pre>

- Clone this repo
<pre>
$ git clone https://github.com/cdelaof26/MinimalistAwesomeWM.git
</pre>

- Move into repo
<pre>
$ cd MinimalistAwesomeWM
</pre>

- Copy contents to `.config` directory
<pre>
Delete awesome config folder if exist (backup your stuff)
$ rm -r ~/.config/awesome

Copy awesome files
$ cp -r awesome ~/.config/
</pre>

- Restart `awesomewm`


### No wallpaper?

Create `wallpaper` folder inside awesome config directory
<pre>
$ mkdir ~/.config/awesome/wallpaper
</pre>

Copy your wallpapers
<pre>
$ cp Light.jpg ~/.config/awesome/wallpaper
$ cp Dark.jpg ~/.config/awesome/wallpaper
</pre>

**Note**: Your wallpapers should be named as `Light.jpg` and `Dark.jpg`
(case-sensitive), at the moment this is not customizable unless you change 
the code

See [theme_manager](awesome/ui/tools/theme_manager.lua)


### Mini library

Feel free to use [color_button](awesome/ui/modular/color_button.lua) and
[message_pane](awesome/ui/modular/message_pane.lua) in your projects!

**Disclaimer**: Those might be a _hot mess_, use at your own discretion


### License

<pre>
MIT License

Copyright (c) 2022 cdelaof26

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
</pre>


### TODO

Appearance
- [X] Design desktop base
- [X] Design main menu
- [X] Design top bar
- [ ] Design dock
- [X] Design control center
- [ ] Design awesome settings _micro-app_
- [ ] Customize rofi

Code
- [X] Create project
- [ ] Create main menu
  - [X] Add `Awesome shortcuts` button
    - [X] Functional
  - [ ] Add `Awesome settings` button
    - [ ] Functional
  - [X] Add `Restart` button
    - [X] Functional
    - [X] Show confirmation window
  - [X] Add `Power off` button
    - [X] Functional
    - [X] Show confirmation window
  - [X] Add `Log out` button
    - [X] Functional
    - [X] Show confirmation window
  - [ ] Make accessible throught keyboard
- [X] Create top bar
  - [X] Add widgets
    - [X] Menu button
    - [X] Search button
    - [X] Tag-lists
    - [X] Control center
    - [X] Username label
    - [X] Clock
- [X] Create dock
  - [ ] Add functionalities
    - [X] Show clients
    - [ ] Close client 
    - [ ] Pin applications 
- [X] Create control _panel_
  - [X] Add uptime label
  - [X] Add dark / light mode buttons
    - [X] Create scheduled for changing themes
  - [X] Add CPU monitor
  - [X] Add RAM monitor
- [ ] Create awesome settings _micro-app_
  - WIP
- [ ] Customize rofi
- [ ] Implement shortcuts
  - WIP
- [ ] Clean up

### Changelog

### v0.2.5_1
- Fixed memory leak when theme was toggled 

### v0.2.5
- Added control panel
- Added scheduled theme function
- Removed toggle theme from the main menu
- Created `message_pane` utility 
  - **This utility requires of Python 3.6 or newer**

**Note**: This will not work with multiple monitors

### v0.2.0

- Project completely reworked
- [License](LICENSE) added
- Now all UI elements are _managed_ as tables (objects) 
- Toggle theme function no longer requires restart awesome

**Note**: This will not work with multiple monitors


### v0.1

- Initial project
- Not ready to ship, but it is minimally functional :)


### References

#### Lua reference
- [Lua manual](https://www.lua.org/manual/5.4/)
- [Tutorials point reference](https://www.tutorialspoint.com/lua/)
- [Lua os.execute return value](https://stackoverflow.com/questions/9676113/lua-os-execute-return-value)

#### Awesome resources
- [AwesomeWM API Documentation](https://awesomewm.org/apidoc/)
- [Streetturtle's awesome widgets (webpage)](http://pavelmakhov.com/)
  - [Streetturtle's awesome widgets (repo)](https://github.com/streetturtle/awesome-wm-widgets)
- [How to get a transparent wibar?](https://www.reddit.com/r/awesomewm/comments/7561fx/how_to_get_a_transparent_wibar/)
- [How can I position an awful.popup relative to a widget in another wibox?](https://www.reddit.com/r/awesomewm/comments/bhuldr/how_can_i_position_an_awfulpopup_relative_to_a/)
- [Smaller title bar?](https://www.reddit.com/r/awesomewm/comments/jyew3n/smaller_title_bar/) (How to change client title bar size)

#### Others

- [Script to get CPU usage](https://github.com/pcolby/scripts/blob/master/cpu.sh)
  - [How to read the Linux /proc/stat file](https://supportcenter.checkpoint.com/supportcenter/portal?eventSubmit_doGoviewsolutiondetails=&solutionid=sk65143)
- [How to Find the Physical Memory Available on a System Through the Command Line](https://qualitestgroup.com/insights/technical-hub/how-to-find-the-physical-memory-available-on-a-system-through-the-command-line/)
- [Memory leak with gears.wallpaper](https://github.com/awesomeWM/awesome/issues/368)
