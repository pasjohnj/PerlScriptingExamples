#use warnings; #commented out because using warnings results in too much complaining for this one
require 'F:\MARKUP\code\Perl\Eebo\require_subs.pl';
#Explanation: This script takes the now fully reconciled tabbed spreadsheet through a number of regex manipulations and outputs the results into a formatted .txt. file similar to the one used to create vendor reports. 

sub preMaster {
	<TABS>; #skip first (header) line
	while ($line = <TABS>) { 
		($batched, $file, $id, $verdict, $reviewer, $date, $size, $sample, $inex, $ex, $bad, $grps, $rate, $date) = split(/\t/, $line); #split bits by tab for formatting
		$veridct = uc $verdict;
		$sample =~ s/\"//g;
		$sample =~ s/,//g;
		$inex = int($inex);
		$bad = int($bad);
		$errs = $inex + $bad; #add up inexcusables and bad $ signs
		if (lc $batched eq "travel"){ #accounting for new Travel designated books, added 8/29
			$batched = "NOT BATCHED";
		}
		print OUT "$batched\t$file\t$id\t$sample\t$errs\t$verdict\t$reviewer\t$date\n"; #output
	}
}

sub master {
	while ($line = <REPORT>) { #reformat pre_master in various ways
		$line =~ s/REJECTED/REJECT/i;
		$line =~ s/ACCEPTED/ACCEPT/i;
		$line =~ s/PARDONED/PARDON/i;
		$line =~ s/\.take2(.*)$/$1\t--resubmission/i;
		$line =~ s/^\t\t\t\t0.*$//g;
		$line =~ s/^\n$//g;
		#if new vendors are used, change here:
		$line =~ s/^([B|Z][0-9]+)\.PDCC/PDCC\t$1.PDCC/i;
		$line =~ s/^([B|Z[0-9]+)\.APEX/APEX\t$1.APEX/i;
		$line =~ s/NOT BATCHED\t([^\t]+)\.([a-z][a-z][a-z][a-z])\.sgm/\U$2\E\tNOT BATCHED\t$1/;
		$line =~ s/\.[apexcd]+\.sgm//i;
		print OUT "$line";
	}
}
######
{
	monthYear(); #gives access to a number of relevant date variables.
	
	{#pre-master formatting stage
		$dirname = "F:/MARKUP/eebo/temps/temp${ym}/lists/${ym}tabs.txt";
		open (TABS, $dirname) || die "Cannot open file: $!";
		open(OUT, ">3_pre_master.txt") || die "Cannot open file: $!";
		print "Now creating interim master .txt...\n";
		preMaster();
		
		close TABS;
		close OUT;
	}
	
	{#master formatting stage	
		open(REPORT, "<3_pre_master.txt") || die "Cannot open file: $!";
		open(OUT, ">3_${short_month}${short_year}Master.pre.txt") || die "Cannot open file: $!";
		print "Now creating master .txt...\n";
		master();
		
		close REPORT;	
		close OUT;

		system("sort 3_${short_month}${short_year}Master.pre.txt >3_${short_month}${short_year}Master.txt");
	}
	
	print "Now creating a copy of all files in this month's auto-generated directory and cleaning up...\n";
	system("cp 3_pre_master.txt 3_${short_month}${short_year}Master.pre.txt 3_${short_month}${short_year}Master.txt F:/MARKUP/eebo/temps/temp${ym}/auto-generated");
	
	#comment out to debug
	system("rm 3_${short_month}${short_year}Master.pre.txt");
	system("rm 3_pre_master.txt");
	

}







