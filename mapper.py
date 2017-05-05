#!/usr/bin/python

# Format of each line is:
# Job Title, Total Pay, Gender

import sys

for line in sys.stdin:
    data = line.strip().split("\t") 

    if len(data) == 3:
        job_title, total_pay, gender = data
        print "{0}\t{1},{2}".format(job_title, total_pay, gender)
