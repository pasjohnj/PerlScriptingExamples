# Perl Scripting Examples for the Text Creation Partnership (TCP)
## 1_file_discrep.pl
This script reconciles what files are on hand with what markup reviewers indicated they completed.
1.) It creates two lists, one list of files on hand, and one list of files reviewers claimed completed, and compares them.
2.) It outputs a 3rd list of file discrepancies--either files on hand but unclaimed, or claimed but on hand--that the operator then has to resolve. (ie, figure out where they are)
3.) The operator runs this script until there are no more discrepancies.
This script was run monthly as part of a suite of reporting routines.
## 3_STC_compare.pl
This QC script ensures that a file's handle was the same as its internal catalog number, found within the file. (STC--Short Title Catalog)
1.) It creates two arrays: one of file handles for all monthly incoming files, and one of each file's internal catalog number. It sorts each array, and compares them.
2.) It outputs a list of file handles that need to be changed. (It did not change them manually, as it required a human to inspect before changing them)
This script was run monthly as part of a suite of file check-in and standardization/validation routines.
