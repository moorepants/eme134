#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals
from os.path import expanduser, join

AUTHOR = 'Jason K. Moore'
SITENAME = 'EME 134: Vehicle Stability'
SITEURL = ''
SOURCEURL = 'http://github.com/moorepants/eme134'

PATH = 'content'
THEME = 'theme'
PAGE_ORDER_BY = 'sortorder'

TIMEZONE = 'US/Pacific'

DEFAULT_LANG = 'en'

PLUGIN_PATHS = [join(expanduser("~"), 'src', 'pelican-plugins')]
PLUGINS = ['render_math']
MATH_JAX = {'color': 'black'}

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

DEFAULT_PAGINATION = False

STATIC_PATHS = ['materials', 'images']

# Uncomment following line if you want document-relative URLs when developing
#RELATIVE_URLS = True

COURSE_TITLE = 'Vehicle Stability'
COURSE_CODE = 'EME 134'
COURSE_CRN = 43393
COURSE_YEAR = 2018
COURSE_QUARTER = 'Fall'
COURSE_LOCATION = 'Olson 250'
COURSE_TIME = 'MWF 11:00-11:50 AM'
