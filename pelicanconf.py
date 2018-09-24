#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

AUTHOR = 'Jason K. Moore'
SITENAME = 'EME 134: Vehicle Stability'
SITEURL = ''
SOURCEURL = 'http://github.com/moorepants/eme134'

PATH = 'content'
PAGE_ORDER_BY = 'sortorder'

THEME = 'theme'

TIMEZONE = 'US/Pacific'

DEFAULT_LANG = 'en'

# This sets the default pages to be top level items.
PAGE_URL = '{slug}.html'
PAGE_SAVE_AS = '{slug}.html'

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

DEFAULT_PAGINATION = False

# Uncomment following line if you want document-relative URLs when developing
#RELATIVE_URLS = True

COURSE_TITLE = 'Vehicle Stability'
COURSE_CODE = 'EME 134'
COURSE_CRN = 43393
COURSE_YEAR = 2018
COURSE_QUARTER = 'Fall'
COURSE_LOCATION = 'Olson 250'
COURSE_TIME = 'MWF 11:00-11:50 AM'
