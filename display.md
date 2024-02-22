LCD
IPS panels

TFT LCD

OLED
microLED
QLED

Dell U2415 is a 16:10 (1920x1200) WUXGA, active matrix TFT LCD, w/ in panel switching (IPS), 61.13 cm (24.1-inch)


LCd displays are 'not usually named as such' but the LED is just the backlight, instead of cathode fluorescent lamps (CFLs)

First LCD screen is Twisted nematic (low cost and power, fast response, poor color, angles, and contrast

2nd gen was IPS, which is slower and energy inefficient, but give wide viewing and color accuracy

3rd gen is VA (immature), which gives good color and contrast, but is slowest response and has limited angles.

Now, changing to we have:

OLEDs:  active emissive devices. high contrast, highest viewing angle. But expesive, with only a few companise (very few variations)


MiniLED: use LCD but with local dimming backlights (200um pitch leds, rather than big one)

QD-LED: LCD plus an in-between layer which and generated a higher range of colors from the backlight, rather than just relying on the LCD filters subtractive 

QD-OLED: 



### Linux console
Multiseat
VT
TTY
VTE
KMS
Multiseat on modern Linux systems is provided by systemd-logind
https://linuxconsole.sourceforge.net
FBCON and FBDEV
telnet and rs232
Kmscon and systemd-consoled were both attempts but both stopped, around 2015





sudo systemctl set-default multi-user.target
sudo systemctl set-default graphical.target
sudo systemctl isolate [mode]
sudo systemctl get-default
