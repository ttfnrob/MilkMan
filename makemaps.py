import matplotlib.pylab as pl
from pylab import figure, show, rand
from matplotlib.patches import Ellipse
import time
import datetime

print pl.get_backend()

## Create 'canvas' for map
fig = pl.figure(figsize=(7, 7))
ax = fig.add_subplot(111, aspect='equal')
ax.set_xlim(data[:,0].max()+0.2, data[:,0].min()-0.2)
ax.set_ylim(-1, 1)

#Plot data
for xys in data:
    e = Ellipse(xy=[xys[0], xys[1]], width=xys[2], height=xys[3], angle=xys[5])
    e.set_clip_box(ax.bbox)
    e.set_alpha(0.33)
    e.set_facecolor('blue')
    e.set_edgecolor('none')
    ax.add_artist(e)

# pl.show()
ts = time.time()
stamp = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d-%H-%M-%S')
directory = "output/charts/"
if not os.path.exists(directory):
    os.makedirs(directory)
pl.savefig(directory+"map_"+stamp, format='ps', dpi=300, bbox_inches='tight')
pl.close()