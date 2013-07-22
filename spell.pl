use strict;

my $input = <STDIN>;
chomp $input;

my @str = &list2array($input, ',');
#print "element array is: @str\n";

my @list = &buildElementList(@str);
#print "The List is: @list\n";

while(my $word = <>)
{
    my @letters = $word =~ m/(qu|\w)/g;
    my @selected = &match(\@list, \@letters);
    
    if (@selected)
    {
	my $score = &score(@selected);
	print "$score $word";
    }
}
###########################################################################
sub score
{    
    my (@elements) = @_;
    my %scoreTable = &buildScoreTable;

    my $totalScore = 0;
    foreach my $element (@elements)
    {
#	print "Current element is: $element\n";
	my $score = $scoreTable{$element->{'letter'}};
#	print "$score\n";
	    
	if ($element->{'bonus'})
	{
	    $score *= 2;
	}
	
	$totalScore += $score;
#	print "$totalScore\n";
    }
    $totalScore;
}
###########################################################################
sub buildElementList
{
    my @letters = @_;
    my @list;

    foreach my $ele (@letters)
    {
	$ele =~ m/(\w+)([!|$|@|#]*)/;	
	
	my $element = {
	    letter => $1,
	    bonus => $2,
	};
	push @list, $element;
    }
    @list;
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
sub match
{
    my ($listRef, $lettersRef) = @_;
    my @list = @$listRef;
    my @letters = @$lettersRef;
    my @elements = ();
    
    #print "Current Word is: $buffer\n";
    #print "The List is: @list\n";

    foreach my $letterElement (@letters)
    {
	#print "Current Letter to be match is: $letterElement\n";
	#print "Alternative Letter is: ($#list+1)\n";
	my $earlyStop = 1;
	if (!($#list + 1))
	{
	    return ();
	}
	foreach my $i (0..$#list)
	{
	    my $letter = $list[$i]->{'letter'};
	    #print "Current Letter is: $letter\n";
	    #print "Current Bonus is: $bonus\n";
	    
	    $letter =~ s/\*/\\w/;
	    if ($letterElement =~ s/$letter//)
	    {
		push @elements, $list[$i];
		splice(@list, $i, 1);
		$earlyStop = 0;
		last;
	    }
	    #print "Current Buffer is: $buffer\n";  
	}
	if ($earlyStop)
	{
	    return ();
	}
    }
    @elements;
}
############################################################################
sub render
{
    my ($letter, $bonus) = @_;
    
    my %bounusTable = &buildRenderTable;
    if ($bonus)
    {
	my $color = $bounusTable{$letter};
	$letter =~ s/$letter/\033[;$color m$letter\033[0m/;
    }
    $letter;
    
}
############################################################################
sub buildRenderTable
{
    my @table = {
	'!' => '33', # Topaz tiles, Brown
	'@' => '31', # Ruby Tiles, Red
	'#' => '32', # Enerald Tiles, Green
	'$' => '34', # Sapphine Lucky Word, Blue
	'*' => '37', # Double Score, Light Gray
    };
}
############################################################################
