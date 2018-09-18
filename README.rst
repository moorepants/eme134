The course website for Jason K. Moore's University of California, Davis Vehicle
Stability course (EME 134). The rendered version can be viewed at:

http://moorepants.github.io/eme134

This site is generated with Pelican_.

.. _Pelican: http://getpelican.com

Build Instructions
==================

Install miniconda_. Create an environment for this website::

   $ conda create -n pelican python=2 pygments pip jinja2 docutils markupsafe python-dateutil pytz six unidecode fabric
   $ source activate pelican
   (pelican)$ pip install pelican ghp-import

Clone the plugin repository (for the render_math plugin)::

   $ mkdir ~/src
   $ git clone git@github.com:getpelican/pelican-plugins.git ~/src/

Rebuild and serve the site locally::

   (pelican)$ fab reserve

Push the site to Github pages::

   (pelican)$ fab gh_pages

.. _miniconda: http://conda.pydata.org/miniconda.html

License
=======

Creative Commons Attribution 4.0 (CC-BY 4.0)

https://creativecommons.org/licenses/by/4.0/
