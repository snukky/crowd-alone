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
args <- commandArgs(TRUE)

DIR <- args[1]
ITEM <- args[2]
STND <- args[3]
SRC <- args[4]
TRG <- args[5]
N <- as.numeric(args[6])

if( STND=="raw" ){
    f <- paste( DIR, "/", ITEM, "-good-", STND, ".csv", sep="")
}else{
    f <- paste( DIR, "/", ITEM, "-", SRC, TRG,"-good-", STND, ".csv", sep="")
}
a <- read.table( f, header=TRUE )

# only include system outputs (repeats are system outputs) - not including ref or bad ref
a <- a[ which( (( a$Input.src==SRC ) & ( a$Input.trg==TRG )) & ( a$type=="system" | a$type=="repeat" ) ), ]

f <- paste( DIR, "/", ITEM, "-", STND, "-system-scores-",N,".", SRC, "-", TRG, ".csv", sep="")
sink( f)

cat( paste( "SYS", "SCR", "N", "\n") )
for( sys in unique(unlist( a$sys_id ))){
  scrs <- a[ which( a$sys_id==sys), ]$score

  if( N <= length(scrs) ){
    cat( paste( sys, mean(scrs), length(scrs), "\n"))
  }
}

sink()
cat(paste("wrote: ",f,"\n"))
a <- read.table(f)
