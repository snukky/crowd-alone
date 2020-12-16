#!/usr/bin/env bash

set -e

scores=wmt20/WMT20SegSrcDACrowd.csv

# Uncomment for using only users who passed QC
# cat wmt20/WMT20SegSrcDACrowd.csv | grep -vf wmt20/WMT20SegSrcDACrowd.rejected > wmt20/WMT20SegSrcDACrowd_QC.csv
# scores=wmt20/WMT20SegSrcDACrowd_QC.csv

test -s $scores
mkdir -p analysis

# grep -v True removes document scores
cat $scores | grep -v "True" | sort -k1,2 -k8,8 -k11,11 -t,  | python ./convert_appraise_scores.py --segment > analysis/ad-good-raw.csv
cp analysis/ad-good-raw.csv analysis/ad-latest.csv

mkdir -p out

for lpair in de-fr fr-de en-ps en-km ; do
    l1=$(echo $lpair | cut -c1-2)
    l2=$(echo $lpair | cut -c4-5)

    bash standardize-scrs.sh $l1 $l2 > out/$lpair.step2
    bash score-systems.sh    $l1 $l2 > out/$lpair.step3

    echo "### $lpair raw " | tee out/$lpair.ranking
    tail -n +2 analysis/ad-raw-system-scores-500.$lpair.csv | sort -k2,2 -t' ' -rn | column -t | nl | tee -a out/$lpair.ranking

    echo "### $lpair stnd" | tee -a out/$lpair.ranking
    tail -n +2 analysis/ad-stnd-system-scores-500.$lpair.csv | sort -k2,2 -t' ' -rn | column -t | nl | tee -a out/$lpair.ranking
done
