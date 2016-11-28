use warnings;
require '(pathway removed)\require_subs.pl';

sub stc { #takes the filename (which is an STC #) and pushes it into a sorted array
	my ($filename, $temp);
	opendir(DIR, $dirname) || die "Cannot open directory: $!";
	@fileNames = readdir DIR;
	@fileNames = sort(@fileNames);
	for $filename (@fileNames) {
		if ($filename =~ /.*sgm$/i) {
			if ($filename =~ /^([^.]+)\./i) {
				$temp = $1;
				$temp =~ s/-/./g; #converts dash (-) to dot (.) for purposes of comparison.  May want to comment out to be more accurate?
				push (@fileNameSTC, uc ($temp));
			}
		}
	}
@fileNameSTC = sort(@fileNameSTC);
close DIR;
}

sub stcInFile { #opens each file and pulls out the first STC # and pushes it into a sorted array
	my ($filename, $temp);
	opendir(DIR, $dirname) || die "Cannot open directory: $!"; #seems to be necessary to open the directory in both subroutines to get this to work
	#@inFileSTC ;
	while ($filename = readdir DIR) {
		if ($filename =~ /(^.*)\.sgm$/i) {
			open (SOURCE, "<$dirname/$filename") || die "cannot open $filename";
			while ($line = <SOURCE>) {
				if ($line =~ /<STC T="([WSTCX])">([^<]+)<.*>/i) { #iterates until the first STC # is found, then stops
				#if ($line =~ /^<STC T="([WSTC])">([^<]+)<.*>$/i) { #old pattern, didn't match id's found on a single line
					$temp = "$1"."$2";
					push (@inFileSTC, uc ($temp));
					last;
			}
			
		}
	close SOURCE;
	}
}
@inFileSTC = sort(@inFileSTC);
close DIR;
}

sub printOut {	
	my @copy = @_;
	for $name(@copy){
		if($name eq "0"){
			next;
		}
		print OUT "$name\n";
	}
}
####################################


#prompt for current month and year
monthYear();

#the current month's in folder
$dirname = "F:/MARKUP/eebo/texts/in/in$ym"; 

#prepare the arrays to be compared
@fileNameSTC = 0; @inFileSTC = 0;

#gather stc #'s
stc();
stcInFile();

#print output to files
open(OUT, ">1_fileNames${ym}.txt") || die "Cannot open file: $!";
printOut(@fileNameSTC);
close OUT;
open(OUT, ">1_inFiles${ym}.txt") || die "Cannot open file: $!";
printOut(@inFileSTC);
close OUT;

#run unix-type commands comparing the two lists
$atest = `comm -23 1_fileNames${ym}.txt 1_inFiles${ym}.txt`;
$btest = `comm -13 1_fileNames${ym}.txt 1_inFiles${ym}.txt`;

#output results
open(OUT, ">1_compareSTCs${ym}.txt") || die "Cannot open file: $!";
print OUT "STCs unique to file Names:\n${atest}\n\nSTCs unique to ID group:\n${btest}";
close OUT;