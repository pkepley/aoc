from aoc_day_11 import *
import numpy as np
import matplotlib.pyplot as plt
from   matplotlib import animation
import sys

def run_robot_part_1():
    pgm = get_pgm_input('./input/input_day_11.txt')
    rb = robot(pgm)
    rb.run()
    
    return rb.pos_history, rb.paint_history

def run_robot_part_2():
    pgm = get_pgm_input('./input/input_day_11.txt')
    rb = robot(pgm)
    rb.paint_current_cell(1)    
    rb.run()
    
    return rb.pos_history, rb.paint_history

class animator:
    def __init__(self, pos_history, paint_history):
        self.pos_history = pos_history
        self.paint_history = paint_history

        # Set up the coordinates
        self.xs = [pos[0] for pos in self.pos_history]
        self.ys = [pos[1] for pos in self.pos_history]
        self.xs_min = min(self.xs)
        self.xs_max = max(self.xs)
        self.ys_min = min(self.ys)
        self.ys_max = max(self.ys)

        # Set up the matrix of cells
        self.n_col = self.xs_max - self.xs_min + 1
        self.n_row = self.ys_max - self.ys_min + 1        
        self.cells = np.array([[0 for j in range(self.n_col)]
                                  for i in range(self.n_row)])

        # Figure
        fig, ax = plt.subplots()        
        self.fig = fig
        self.ax = ax
        self.im = ax.imshow(self.cells, animated=True, vmin=0,
                            vmax = 1, cmap=plt.get_cmap('gray'))
        #self.im = plt.imshow(self.cells, cmap=plt.get_cmap('gray'))        
        self.ax.set_xticks([],[])
        self.ax.set_yticks([],[])

        self.fig.subplots_adjust(left=0, bottom=0, right=1, top=1,
                                 wspace=None, hspace=None)        
        
    def initialize(self):
        self.im.set_array(np.zeros(self.cells.shape))

    def animate(self, k):
        if k == 0:
            self.cells = np.zeros(self.cells.shape)
            
        j = self.xs[k]  - self.xs_min
        i = self.ys_max - self.ys[k]
        self.cells[i, j] = self.paint_history[k]        
        self.im.set_array(self.cells)
        #self.ax.imshow(self.cells)
        return self.im,


pos_history, paint_history = run_robot_part_2()        
a = animator(pos_history, paint_history)

# Perform the animation
anim = animation.FuncAnimation(a.fig, 
                               a.animate, 
                               init_func=a.initialize,
                               frames=len(a.pos_history),
                               interval = 30, 
                               blit=False,
                               repeat=False)

if '-save' in sys.argv:    
    anim.save('aoc_viz_day_11.mp4', writer='ffmpeg')
else:
    plt.show()
