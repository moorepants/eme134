The course website for Jason K. Moore's University of California, Davis Vehicle
Stability course (EME 134). The rendered version can be viewed at:

http://moorepants.github.io/eme134

This site is generated with Pelican_.

.. _Pelican: http://getpelican.com

Local Build Instructions
========================

Install miniconda_ and then install Pelican::

   $ conda install pelican

Clone the plugin repository::

   $ mkdir ~/src
   $ git clone git@github.com:getpelican/pelican-plugins.git ~/src/

Rebuild and serve the site locally::

   $ make devserver

Access the site at http://localhost:8000.

Stop the server::

   $ make stopserver

.. _miniconda: http://conda.pydata.org/miniconda.html

License
=======

Creative Commons Attribution 4.0 (CC-BY 4.0)

https://creativecommons.org/licenses/by/4.0/
