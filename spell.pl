use strict;

my $input = <STDIN>;
chomp $input;

my @str = &list2array($input, ',');
#print "element array is: @str\n";

while(my $word = <>)
{
    my ($selected, $score) = &match($word, @str);
    if ($selected)
    {
	print "$score $selected";
    }
}

###########################################################################
sub replaceDoubleScoreTile
{
    my ($list, $alternative) = @_;
    # print "$alternative\n";
    $list =~ s/\?/$alternative/;
    $list;
}
###########################################################################
sub buildOptionalElementsTable
{
    my @optional = qw(a b c d e f g h i j k l m n o p q r s t u v w x y z);
}
###########################################################################
sub hasDoubleScore
{
    my ($input) = @_;
    if ($input =~ /\?/)
    {
	return 1;
    }
    else
    {
	return undef;
    }
}
###########################################################################
sub score
{
    my($word, %scoreTable) = @_;
    my $score = 0;
    my @str = &list2array($word, '');
    foreach my $ele (@str)
    {
	if (exists $scoreTable{$ele})
	{
	    $score += $scoreTable{$ele};
	}else
	{
	    last;
	}	
    }
    $score;
}
###########################################################################
sub list2array
{
    my ($input, $delimeter) = @_;
    my @str = split $delimeter, $input;
    @str;
}
############################################################################
sub buildScoreTable
{
    my %scoreTable = (
	a  => 3,
	b  => 4,
	c  => 4,
	d  => 4,
	e  => 3,
	f  => 6,
	g  => 6,
	h  => 5,
	i  => 3,
	j  => 8,
	k  => 7,
	l  => 3,
	m  => 4,
	n  => 4,
	o  => 3,
	p  => 5,
	qu => 10, # FIXME
	r  => 3,
	s  => 3,
	t  => 3,
	u  => 3,
	v  => 7,
	w  => 7,
	x  => 9,
	y  => 7,
	z  => 10, # FIXME
	'*'  => 0,
	);
}
############################################################################
sub buildElementString
{
    my (%table) = @_;
    my @name = keys %table;
    my $elements = join "",@name;
}
############################################################################
sub buildPatternString
{
    my (%table) = @_;
    my $pattern = '';
    while( my ($key, $value) = each %table)
    {
	my $number = $value + 1;
	$pattern = $pattern."|($key(.*)){$number}";
    }
    $pattern = substr($pattern, 1);
}
############################################################################
sub buildElementTable
{
    my (@str) = @_;
    my %table;
    foreach my $item (@str)
    {
	$table{$item}++;
    }    
    %table;
}
############################################################################
sub match
{
    my ($word, @letters) = @_;
    
    my $buffer = $word;
    my $score = 0;
    my %scoreTable = &buildScoreTable;

    foreach my $ele (@letters)
    {
	my $currentScore = $scoreTable{$ele};
	$ele =~ s/\*/\\w/;
	if ($buffer =~ s/$ele//)
	{
	    $score += $currentScore;
	}
	#print "current buffer is: $buffer";
	#print "Score is: $score\n";
	if($buffer =~ m/^\n$/)
	{
	    #print ($score, $word);
	    return ($word, $score);
	}
    }
    return undef;    
}
############################################################################
