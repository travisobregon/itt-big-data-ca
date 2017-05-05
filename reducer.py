#!/usr/bin/python

import sys
from decimal import *

def print_row(male_salary_total, male_count, female_salary_total, female_count):
    male_avg_pay = "NA"
    female_avg_pay = "NA"
       
    if male_count > 0:
        male_avg_pay = format(male_salary_total / male_count, ".2f")
        
    if female_count > 0:
        female_avg_pay = format(female_salary_total / female_count, ".2f")
        
    if male_avg_pay != "NA" and female_avg_pay != "NA":
        difference = Decimal(male_avg_pay) - Decimal(female_avg_pay)
		discrimination = False

        if difference >= Decimal(5000):
            discrimination = True

        print '"{0}",{1},{2},{3}'.format(old_key, male_avg_pay, female_avg_pay, discrimination)

male_salary_total = Decimal(0)
male_count = 0

female_salary_total = Decimal(0)
female_count = 0

old_key = None

print "Job Title,Male Average Pay,Female Average Pay,Discrimination"

for line in sys.stdin:
    data_mapped = line.strip().split("\t")
    
    if len(data_mapped) != 2:
        # Something has gone wrong. Skip this line.
        continue

    this_key, this_value = data_mapped
    total_pay, gender = this_value.strip().split(",")
    
    if old_key and old_key != this_key:
        print_row(male_salary_total, male_count, female_salary_total, female_count)
 
        male_salary_total = Decimal(0)
		male_count = 0

		female_salary_total = Decimal(0)
		female_count = 0

    old_key = this_key
    
    if gender == "male":
        male_salary_total += Decimal(total_pay)
        male_count += 1
    else:
        female_salary_total += Decimal(total_pay)
        female_count += 1

if old_key != None:
    print_row(male_salary_total, male_count, female_salary_total, female_count)

