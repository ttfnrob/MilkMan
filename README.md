MilkMan
=======

This is a Zooniverse data reduction tool; a web app created to display results and analysis of the Milky Way Project. You can find it online at http://mwp-milkman.herokuapp.com/. It's not perfect, or widely tested yet, but it's working for me :)

It requires Mongo (using the MongoMapper ORM), Rails 3.1, Ruby 1.9.3, and a recent database dump from the MWP.

The idea behind Milkman is that it exists as a standalone web app, backed by a recent copy of the full-scale Milky Way Project database. It has been built to allow anyone to inspect the classifications created by the volunteers for any subject (image) in the database, or at any GLON, GLAT location.

For each image you can see the raw volunteer drawings, the clustered results and objects on SIMBAD in the region (this bit is still not quite finished). For example check out http://mwp-milkman.herokuapp.com/subjects/AMW0002t4h

You can either search for a Zooniverse subject ID (e.g. AMW0002t4h) which are the same as those used on Talk (e.g. http://talk.milkywayproject.org/#/subjects/AMW0002t4h) or by coordinates. Or just click the random button to play about.

The same code can be used to generate lists of results - i.e. catalogues of types of objects. I'll get to that when the clustering on this site looks correct. I'm using an algorithm called DBSCAN to extract clusters and am treating all users equally at present (i.e. I'm not doing any user weighting).

I'd love your thoughts and if you have suggestions for improvements by all means add them to the GitHub repository where this code lives https://github.com/ttfnrob/MilkMan/issues

