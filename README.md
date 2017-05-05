# Big Data - Continuous Assessment

## Files
- Report.docx - Thesis on Equal Pay
- mapper.py - Mapper script for Hadoop
- reducer.py - Reducer script for Hadoop
- salaries.csv - Initial data set on salaries in San Francisco from [Kaggle](https://www.kaggle.com/kaggle/sf-salaries)
- salaries.txt - Output from the preprocessing script
- salaries_discrimination.csv - Output from the Hadoop MapReduce job
- salaries_discrimination_analytics.R - Script to perform analytics on salaries_discrimination.csv
- salaries_preprocessing.R - Script to perform preprocessing on salaries.csv

## Steps to reproduce
*Note you will have to change the file paths within the R scripts to match your system*
1. Open salaries_preprocessing.R in RStudio and run it.
2. Follow the instructions to install the virtual machine that contains Hadoop [here](https://docs.google.com/document/d/1v0zGBZ6EHap-Smsr3x3sGGpDW-54m82kDpPKC2M6uiY/pub).
3. Transfer salaries.txt, mapper.py, and reducer.py to the virtual machine using the instructions [here](https://docs.google.com/a/knowlabs.com/document/d/1MZ_rNxJhR4HCU1qJ2-w7xlk2MTHVqa9lnl_uj-zRkzk/pub).
4. Make directories in HDFS on the virtual machine using the following commands:
```
hadoop fs -mkdir jobinput
hadoop fs -mkdir joboutput
```
5. Put salaries.txt into HDFS using the following command:
```
hadoop fs -put salaries.txt jobinput
```
6. Run the MapReduce job using the following command:
```
hs mapper.py reducer.py jobinput joboutput
```
7. The job's output will be stored in the file part-00000 located in the joboutput directory. The file can be retrieved from HDFS using the following command:
```
hadoop fs -get joboutput/part-00000 salaries_discrimination.csv
```
8. Transfer salaries_discrimination.csv to the local machine using the instructions outlined earlier.
9. Open salaries_discrimination_analytics.R and run it.

Thanks to Cloudera for their free course: [Intro. to Hadoop and MapReduce](https://www.udacity.com/course/intro-to-hadoop-and-mapreduce--ud617)
