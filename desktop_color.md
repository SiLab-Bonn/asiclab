Linux commands to set solid color background.

If you’re familiar with Linux command line, press Ctrl+Alt+T on keyboard to open a terminal window.

When it opens, run the commands below one by one to disable current wallpapers for light and dark mode:

gsettings set org.gnome.desktop.background picture-uri ''

gsettings set org.gnome.desktop.background picture-uri-dark ''

In case you’ve set gradient color background before, reset the “color-shading-type” via command:

gsettings reset org.gnome.desktop.background color-shading-type

Finally, run the command below in set a solid color background (total dark for example):

gsettings set org.gnome.desktop.background primary-color '#000000'
