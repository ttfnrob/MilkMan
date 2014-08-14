#!/usr/bin/env python
import numpy as np
import pylab as pl
from matplotlib import pyplot as plt
from matplotlib.ticker import MultipleLocator, FormatStrFormatter
from matplotlib.patches import Ellipse
import os
import datetime
import time

def makeVCMap( inputlist ):
	"prepare_map_for_data"
	# Create maop canvas
	fig = pl.figure(figsize=(25,3))
	ax = fig.add_subplot(111, aspect='equal')
	ax.set_xlim(-65, -105)
	ax.set_ylim(-2.5, 2.0)
	ax.xaxis.set_major_locator(MultipleLocator(2))	
	ax.xaxis.set_minor_locator(MultipleLocator(0.5))
	ax.yaxis.set_major_locator(MultipleLocator(1))	
	ax.yaxis.set_minor_locator(MultipleLocator(0.1))
	plt.figtext(0.89, 0.92, inputlist[0], fontdict=None, ha='right')
	#Mapo the data
	for b in inputlist[1]:
	    e = Ellipse(xy=[b[1], b[2]], width=b[3]*2, height=b[4]*2, angle=b[9], lw=0.25)
	    e.set_clip_box(ax.bbox)
	    e.set_alpha(0.80)
	    e.set_facecolor(inputlist[2])
	    e.set_edgecolor('black')
	    ax.add_artist(e)
    # Save image
	pl.savefig(directory+inputlist[3]+".png", dpi=600, bbox_inches='tight')
	pl.close()
	return directory+inputlist[3]+".png"

with open('milkman-output-all.csv') as f:
  dataset = np.loadtxt(f, delimiter=",", dtype={'names':('type', 'glon', 'glat', 'degx', 'degy', 'imgx', 'imgy', 'rx', 'ry', 'angle', 'qglon', 'gqlat', 'qdegx', 'qdegy', 'potential_duplicate',  'pixel_scale', 'zooniverse_id', 'img_url'), 'formats':('S8', 'float', 'float', 'float', 'float', 'float', 'float', 'float', 'float', 'float', 'float', 'float', 'S1', 'float', 'S8', 'float', 'S10', 'S255')}, skiprows=1)

bubbles = dataset[dataset['type']=='bubble']
clusters = dataset[dataset['type']=='cluster']
egos = dataset[dataset['type']=='ego']
gals = dataset[dataset['type']=='galaxy']

ts = time.time()
stamp = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d-%H-%M-%S')
directory = "public/images/maps/"
if not os.path.exists(directory):
	os.makedirs(directory)

print makeVCMap(['Vela-Carina Bubble Map', bubbles, 'CornflowerBlue','vc-bubble-map'])
print makeVCMap(['Vela-Carina Star Cluster Map', clusters, 'GoldenRod','vc-cluster-map'])
print makeVCMap(['Vela-Carina EGO Map', egos, 'YellowGreen','vc-ego-map'])
print makeVCMap(['Vela-Carina Galaxy Map', gals, 'Crimson','vc-galaxy-map'])
