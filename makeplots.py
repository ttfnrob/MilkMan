#!/usr/bin/env python
import numpy as np
import pylab as pl
from matplotlib import pyplot as plt
from matplotlib.patches import Ellipse
import os
import datetime
import time

with open('milkman-output-all.csv') as f:
  dataset = np.loadtxt(f, delimiter=",", dtype={'names':('type', 'glon', 'glat', 'degx', 'degy', 'imgx', 'imgy', 'rx', 'ry', 'angle', 'qglon', 'gqlat', 'qdegx', 'qdegy', 'potential_duplicate',  'pixel_scale', 'zooniverse_id', 'img_url'), 'formats':('S8', 'float', 'float', 'float', 'float', 'float', 'float', 'float', 'float', 'float', 'float', 'float', 'S1', 'float', 'S8', 'float', 'S10', 'S255')}, skiprows=1)

bubbles = dataset[dataset['type']=='bubble']
clusters = dataset[dataset['type']=='cluster']
egos = dataset[dataset['type']=='ego']
gals = dataset[dataset['type']=='galaxy']

ts = time.time()
stamp = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d-%H-%M-%S')
directory = "output/charts/"
if not os.path.exists(directory):
	os.makedirs(directory)

charts = [	['glon', 36, 'linear',[180,-180], 'GLON'],
			['glat', 20, 'linear',[-2.5,2.5], "GLAT"],
			['degx', 20, 'log', [0,0.1], 'Width (deg)'],
			['degy', 20, 'log', [0,0.1], 'Height (deg)'],
			['angle', 20, 'linear', [0,90], 'Angle (deg)'],
			['imgx', 100, 'linear', [0,800], 'X (Pixels)'],
			['imgy', 50, 'linear', [0,400], 'Y (Pixels)'],
			['rx', 20, 'log', [0,200], 'Width (Pixels)'],
			['ry', 20, 'log', [0,200], 'Height (Pixels)'],
			['pixel_scale', 10, 'linear', [0,0.0015], 'Pixel Scale (pixels/deg)']
		 ]

for prop in charts:
	fig = plt.figure()
	ax1 = fig.add_subplot(111)
	# ax1.xlim(prop[3])
	ax1.set_yscale(prop[2])
	plt.xlim(prop[3])
	n, bins, patches = ax1.hist( [bubbles[prop[0]], clusters[prop[0]], egos[prop[0]], gals[prop[0]] ], bins=prop[1], color=['CornflowerBlue', 'GoldenRod', 'YellowGreen', 'Crimson'], histtype='step')
	# plt.savefig(directory+prop[0]+"_"+stamp+".png", dpi=300, bbox_inches='tight')
	plt.figtext(0.89, 0.92, 'Distribution of '+prop[4], fontdict=None, ha='right')
	plt.savefig(directory+prop[0]+".png", dpi=300, bbox_inches='tight')
	plt.close()

## Create 'canvas' for map
fig = pl.figure(figsize=(10, 4))
ax = fig.add_subplot(111, aspect='equal')
ax.set_xlim(-64,-82)
ax.set_ylim(-1.6, 0.5)

#Map data
for b in bubbles:
    e = Ellipse(xy=[b[1], b[2]], width=b[3]*2, height=b[4]*2, angle=b[9])
    e.set_clip_box(ax.bbox)
    e.set_alpha(0.25)
    e.set_facecolor('CornflowerBlue')
    e.set_edgecolor('CornflowerBlue')
    ax.add_artist(e)

pl.savefig(directory+"bubble-map.png", dpi=300, bbox_inches='tight')
pl.close()