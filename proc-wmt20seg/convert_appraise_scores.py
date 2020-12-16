#!/usr/bin/env python3

import argparse
import datetime
import sys


MAP_TYPES = {
    "TGT": "system",
    "BAD": "cal",   # I don't know what 'cal' mean, but other types match
    "CHK": "repeat",
    "REF": "ref"
}

MAP_LANGS = {
    "ces": "cs",
    "deu": "de",
    "eng": "en",
    "fra": "fr",
    "iku": "iu",
    "jpn": "ja",
    "khm": "km",
    "plk": "pl",
    "pus": "ps",
    "rus": "ru",
    "tam": "ta",
    "zho": "zh",
}


def main():
    args = parse_args()

    args.output_csv.write("HITId\tWorkerId\tInput.src\tInput.trg\tInput.item\tsys_id\trid\ttype\tsid\tscore\ttime\n")

    users = set()
    rid = 0
    for line in args.input_csv:
        fields = line.strip().split(",")
        user  = fields[0]
        sysid = fields[1]
        segid = fields[2]
        itype = fields[3]
        srclg = fields[4]
        tgtlg = fields[5]
        score = int(fields[6])
        if args.segment:
            sid = segid
        else:
            docid = fields[7]
            isdoc = fields[8]
            sid = docid + "-" + segid
        time1 = float(fields[-2])
        time2 = float(fields[-1])

        args.output_csv.write("{user}\t{user}".format(user=user))
        args.output_csv.write("\t{}\t{}\tad".format(MAP_LANGS[srclg], MAP_LANGS[tgtlg]))
        args.output_csv.write("\t{}\t{}\t{}\t{}".format(sysid, rid, MAP_TYPES[itype], sid))
        args.output_csv.write("\t{}\t{}\n".format(score, time2 - time1))

        users.add(user)
        rid += 1

    sys.stderr.write("Read {} users\n".format(len(users)))
    sys.stderr.write("Read {} scores\n".format(rid))


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("input_csv", nargs="?", type=argparse.FileType("r"), default=sys.stdin)
    parser.add_argument("output_csv", nargs="?", type=argparse.FileType("w"), default=sys.stdout)
    parser.add_argument("--segment", action='store_true')
    return parser.parse_args()


if __name__ == "__main__":
    main()
