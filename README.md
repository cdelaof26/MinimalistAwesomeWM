# Minimalist AwesomeWM

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

Create `wallpaper` folder in awesome config directory
<pre>
$ mkdir ~/.config/awesome/wallpaper
</pre>

Copy your wallpapers
<pre>
$ cp Light.jpg ~/.config/awesome/wallpaper
$ cp Dark.jpg ~/.config/awesome/wallpaper
</pre>

**Note**: Your wallpapers should be named as `Light.jpg` and `Dark.jpg`
(case sensitive), at the moment this is not customizable unless you change 
the code

See [theme_manager](awesome/tools/theme_manager.lua)


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
  - [ ] Add `Restart` button
    - [X] Functional
    - [ ] Show confirmation window
  - [ ] Add `Power off` button
    - [X] Functional
    - [ ] Show confirmation window
  - [ ] Add `Log out` button
    - [X] Functional
    - [ ] Show confirmation window
  - [ ] Make accessible throught keyboard
- [X] Create top bar
  - [ ] Add widgets
    - [X] Menu button
    - [X] Search button
    - [X] Tag-lists
    - [ ] Control center
    - [X] Username label
    - [X] Clock
- [X] Create dock
  - [ ] Add functionalities
    - [X] Show clients
    - [ ] Close client 
    - [ ] Pin applications 
- [ ] Create control center
  - [ ] Add volume slider
  - [ ] Add brightness slider
  - [ ] Add uptime label
  - [ ] Add dark / light mode buttons
  - [ ] Add CPU monitor
  - [ ] Add RAM monitor
- [ ] Create awesome settings _micro-app_
  - WIP
- [ ] Customize rofi
- [ ] Implement shortcuts
  - WIP
- [ ] Clean up

### Changelog

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
