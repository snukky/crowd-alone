#!/usr/bin/env bash

# Copyright 2015 Yvette Graham
#
# This file is part of Crowd-Alone.
#
# Crowd-Alone is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Crowd-Alone is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Crowd-Alone.  If not, see <http://www.gnu.org/licenses/>

set -e

DIR=analysis
ITEM=ad
SRC=$1
TRG=$2
MIN_N=10

STND=stnd;
echo "Arguments: $DIR $ITEM $STND $SRC $TRG $MIN_N "
R --no-save --args $DIR $ITEM $STND $SRC $TRG $MIN_N < score-systems.R

STND=raw
echo "Arguments: $DIR $ITEM $STND $SRC $TRG $MIN_N "
R --no-save --args $DIR $ITEM $STND $SRC $TRG $MIN_N < score-systems.R
