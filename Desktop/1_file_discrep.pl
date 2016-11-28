use warnings;
require '(pathway removed)\require_subs.pl';
#Explanation: This script reconciles what files are on hand with what reviewers entered on spreadsheets.  It extracts the ID # and file name from each file and places them into a hash, then it extracts the same information from a tab delimited version of the master spread sheet, called yyyymmtabs.txt, and places that information into a hash.  It then sorts the hashes by ID #, outputs the information into .txt files, called 1_filesyyyymm.txt and 1_spreadsheetyyyymm.txt, and compares the two lists, looking for unique entries on each.  The results of this comparison are outputted into 1_file_discrepanciesyyyymm.pl.  
#Note: This is the most awkward step of the process because usage of two spreadsheets (the tab delimited spreadsheet and original).  Any changes made during this step should be made to the original spreadsheet, and saved both in the original AND to the tab delimited spreadsheet.  It can be tricky to go back and forth between the two files.  The usage of a tab delimited file is a workaround since there seem to be restrictions in downloading from the CPAN archive.  I would've used the module that dealt directly with spreadsheets.  Allowing for this inconvenience, this step seems to work well.
#An improvement: could do a running count of relevant files and spreadsheet entries and output them to the command line.  I've tried this in the past and could never quite get it to work.

sub fileExtraction {  #subroutine to extract IDs from files
	while (defined(my $file = readdir($dir))) {
		if ($file ne '.' && $file ne '..') { #skips over the . and .. files
			open (SOURCE, "<$dirName/$file") || die "Can't open file: $!";
			$file =~ s/^([^\.]+)\.([0-9]\..*)/$1-$2/g; #formats file names into a standardized format (do AFTER opening file)
			while (my $line = <SOURCE>) {
				if ($line =~ /.*ID="([AB][0-9]+)"/) {
					$fileHash{$1} = $file; #makes ID's the keys and the filenames the values
					last;
				}

			}
			close SOURCE;
		}
	}
closedir($dir);
}

sub spreadsheetExtraction { #subroutine to extract IDs from files
	my $fileName = "(pathway removed)/lists/${ym}tabs.txt";
	open(SPREAD, "<$fileName") || die "Can't open file: $!";
	
	while (my $line = <SPREAD>) {
		if ($line =~ /^[^\t]+\t([^\t]+)\t([AB][0-9]+)+/) { #separates out file name and ID #
			$spreadHash{$2} = $1; #this line will return a false positive if the file name has a . in it
		}
		#closes spreadsheet
		if($line =~ /^\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t$/){ 
			close SPREAD;
			return;
		}
	}
}
######
{
	monthYear(); #gives access to a number of relevant date variables.
	
	system("mkdir (pathway removed)/auto-generated");

	{#files on hand

		%fileHash = ();

		{ #accepted file processing
			$dirName = "(pathway removed)/temp${ym}/done${ym}";
			opendir($dir, $dirName) || die "Can't open diretory $!";
			print "Now extracting IDs from accepted files...\n";
			fileExtraction();
		}
		
		{#rejected file processing
			$dirName = "(pathway removed)/temp${ym}/rej${ym}";
			opendir($dir, $dirName) || die "Can't open directory: $!";
			print "Now extracting IDs from rejected files...\n";
			fileExtraction();
		}

		{#sort hash alphabetically by ID's and outputs them
			open(OUT, ">1_files${ym}.txt") || die "Can't open file: $!";
			foreach my $key (sort (keys(%fileHash))) {
				print OUT uc "$key\t$fileHash{$key}\n";
			}
			close OUT;
		}
	}

	{#spread sheet entries

		%spreadHash = ();

		{#spreadsheet processing
			print "Now extracting IDs from spreadsheet...\n";
			spreadsheetExtraction($counter, $batchCounter);
		}

		{#sorts hash alphabetically by ID's and outputs them
			open(OUT, ">1_spreadsheet${ym}.txt") || die "Can't open file: $!";
			foreach my $key (sort (keys(%spreadHash))) {
				print OUT uc "$key\t$spreadHash{$key}\n";
			}
			close OUT;
		}
	}
	
	#run unix-type commands comparing the two lists
	print "Now comparing lists...\n";
	$atest = `comm -23 1_files${ym}.txt 1_spreadsheet${ym}.txt`;
	$btest = `comm -13 1_files${ym}.txt 1_spreadsheet${ym}.txt`;

	#open a txt file to output sorted list of spreadsheet items
	open(OUT, ">1_file_discrepancies${ym}.txt") || die "Can't open file: $!";
	print OUT "Files on hand but not entered into the spreadsheet:\n${atest}\n\nFiles entered into the spreadsheet but not on hand:\n${btest}\t";
	close OUT;
	
	print "Now creating a copy of all files in this month's auto-generated directory and cleaning up...\n";
	system("cp  1_file_discrepancies${ym}.txt 1_files${ym}.txt 1_spreadsheet${ym}.txt (pathway removed)/temp${ym}/auto-generated");

	#comment these out to debug
	#system("rm 1_files${ym}.txt "); #this file needed for notes script
	system("rm 1_spreadsheet${ym}.txt");
}