#!/usr/bin/perl -w

#########################################################
#    Tianyin Zhou 07/18/2012
#    Take the "minor" file as input and 
#    Calculate the Minor Groove Width for 
#    each base pair (average of 3 levels centered around )
#    the base pair)
#
#########################################################


use strict;

my ($id,$level,$width,$occur);
my @matrix = ();
my @row = ();
my @num_levels = ();
foreach (1..150){
    push @num_levels,0;
}

while (<>){
    my $line = $_;
    chomp $line;
    my @line_content = split /\s+/,$line;  #leading empty fields are always returned
    if ((scalar(@line_content) == 10) and ($line_content[1] =~ /[0-9]/)){   
	$id = $line_content[1];
	$level = $line_content[2];
	$width = $line_content[4];
	$occur = $line_content[9];
	@row = ($id,$level,$width,$occur);
	$num_levels[$id]++;
	push @matrix,[@row];
	#print "id=$id level=$level width=$width \n";
    }
}

my ($prev_width,$current_width,$predicted_width,$current_id,$next_width);
my %cp = (); 

for (my $i=1; $i<$#matrix; $i++){
    if ($matrix[$i][1]==1){
	$current_id = $matrix[$i][0];
	$current_width = $matrix[$i][2];
	if ($matrix[$i+1][1]==2){
	    $next_width = $matrix[$i+1][2];
	}
	else {
	    next;
	}
	my $p = $i;
	my $flag = 0;
	foreach (1..$num_levels[$current_id-1]){
	    $p--;
	    if (($matrix[$p][1]<=4) and ($matrix[$p][3]>100000)){
		$flag = 1;
		$prev_width = $matrix[$p][2];
		last;
	    }
	}
	if (!$flag){
	    next;
	}
	$predicted_width = ($prev_width + $current_width + $next_width)/3;
	printf "%3d%7.2f\n",$current_id,$predicted_width;
    }
}


=comment
for (my $i=1;$i<$index;$i++){
    if ($list[$i*3+1]==1){
	my $prev;
	if ($list[$i*3+1-3]==5){
	    if ($i*3+2-6>0){
		$prev = $list[$i*3+2-6];
	    }
	    else{
		next;
	    }
	}
	else{
	    $prev = $list[$i*3+2-3];
	}
	my $current = $list[$i*3+2];
	my $nextv = $list[$i*3+2+3];
	printf "%3d%7.2f\n",$list[$i*3],($prev+$current+$nextv)/3;
    }
}
=cut
