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

- Install awesomewm and rofi, you might need _root privileges_
<pre>
$ apt update
$ apt install awesomewm rofi
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
- [ ] Design top bar
- [ ] Design dock
- [ ] Design control center
- [ ] Design awesome settings _micro-app_
- [ ] Customize rofi

Code
- [X] Create project
- [ ] Create main menu
  - [X] Add `Awesome shortcuts` button
    - [X] Functional
  - [ ] Add `Awesome settings` button
    - [ ] Functional
  - [X] Add `Toggle theme` button
    - [X] Functional
  - [ ] Add `Restart` button
    - [X] Functional
    - [ ] Show confirmation window
  - [ ] Add `Power off` button
    - [X] Functional
    - [ ] Show confirmation window
  - [ ] Add `Log out` button
    - [X] Functional
    - [ ] Show confirmation window
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
  - WIP 
- [ ] Create awesome settings _micro-app_
  - WIP
- [ ] Customize rofi
- [ ] Implement shortcuts
  - WIP
- [ ] Clean up

### Changelog

### v0.1

- Initial project
- Not ready to ship, but it is minimally functional :)
