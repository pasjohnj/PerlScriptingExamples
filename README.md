# Perl Scripting Examples for the Text Creation Partnership (TCP)
My first forays into programming. These got the job done.
## 1_file_discrep.pl
This script reconciles what files are on hand with what markup reviewers indicated they completed.
1.) It creates two lists, one list of files on hand, and one list of files reviewers claimed completed, and compares them.
2.) It outputs a 3rd list of file discrepancies--either files on hand but unclaimed, or claimed but on hand--that the operator then has to resolve. (ie, figure out where they are)
3.) The operator runs this script until there are no more discrepancies.
This script was run monthly as part of a suite of reporting routines.
## 3_master_generator.pl
This script manipulates a tab-delimited version of a spreadsheet into a "master" file. The master file was then used to generate reports and metadata updates further in my automated process.
## 3_STC_compare.pl
This QC script ensures that a file's handle is the same as its internal catalog number, found within the file. (STC--Short Title Catalog)
1.) It creates two arrays: one of file handles for all monthly incoming files, and one of each file's internal catalog number. It sorts each array, and compares them.
2.) It outputs a list of file handles that need to be changed. (It does not change them manually, as it requires a human to inspect before changing them)
This script was run monthly as part of a suite of file check-in and standardization/validation routines.
