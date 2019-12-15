from aoc_day_13 import *

import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap
from matplotlib import animation
import sys

# Using Terminal colors from:
# https://jonasjacek.github.io/colors/
N = 5
vals = np.ones((N, 4))
cmap = ListedColormap([
    [  0/256,   0/256,   0/256, 1], # Blank : Black
    [  0/256, 135/256, 215/256, 1], # Wall  : Blue
    [192/256, 192/256, 192/256, 1], # Blocks: Silver Gray                
    [  0/256, 255/256,   0/256, 1], # Paddle: Green1
    [215/256,   0/256, 255/256, 1]  # Ball  : Magenta
])

# Run through the program
pgm = get_pgm_input('./input/input_day_13.txt')
am = arcade_machine(pgm, play=True)
fig = plt.figure()
ax  = plt.axes()
ax.set_xticks([],[])
ax.set_yticks([],[])
im = ax.imshow(am.matr, cmap, vmin = -.5, vmax = 4.0+.5)
title = ax.set_title("score {}".format(am.score))

fig.subplots_adjust(left=0, bottom=0, right=1, top=1, wspace=None, hspace=None)

def animate(frame_num):
    am.joystick(am.cheat_update())
    im.set_array(am.matr)
    ax.set_title("Score {}".format(am.score))
    return im, title

anim = animation.FuncAnimation(
    fig,
    animate,
    frames = 6995,
    interval = 10,
    blit = False,
    repeat = True
)

if '-save' in sys.argv:    
    anim.save('aoc_viz_day_13.mp4', writer='ffmpeg')
else:
    plt.show()
