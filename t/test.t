#!/usr/bin/perl

use 5.006;
use strict;
use warnings;
use Test::More tests => 2;
use LWP::Online ':skip_all';
use Github::Fork::Parent;

is(github_parent('git://github.com/chorny/cgi-session.git'),
 'http://github.com/cromedome/cgi-session');
#git://github.com/cromedome/cgi-session.git

is(github_parent('git@github.com:chorny/PPI-App-ppi_version-BDFOY.git'),
 'http://github.com/briandfoy/PPI-App-ppi_version-BDFOY');
#git://github.com/briandfoy/PPI-App-ppi_version-BDFOY.git

# (c) Alexandr Ciornii, 2009
