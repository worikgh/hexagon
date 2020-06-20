#!/usr/bin/perl -w
use strict;
use Math::Trig;
my $R = 280;
my $r = cos(deg2rad 30) * $R;

# Sets the size.  This many hexegons accross (x)  and tall (y).  
my $repeatx = 7;
my $repeaty = 5;

# With of the pen 
my $stroke_width = 5;

my $colour = 'red';
my $fill = 'transparent';

sub round( $ ) {
    my $i = shift;
    int($i + 0.5);
}
sub hexagon( $$$$ ) {
    # https://en.wikipedia.org/wiki/Hexagon
    # https://en.wikipedia.org/wiki/Hexagon#/media/File:Regular_hexagon_1.svg
    my $centrex = shift or die;
    my $centrey = shift or die;
    my $R = shift or die;
    my $r = shift or die;

    my $x1 = $centrex - $R;
    my $y1 = $centrey;

    # my $x2 = $x1 + $r*sin(deg2rad 30);
    my $x2p = $centrex- $R*0.5;
    my $y2 = $centrey + $r;
    
    # my $x3 = $centrex + ($centrex - $x2);
    my $x3p = $centrex + $R*0.5;
    my $y3 = $y2;

    my $x4 = $centrex + $R;
    my $y4 = $centrey;

    my $x5 = $x3p;
    my $y5 = $centrey - $r;

    my $x6 = $x2p;
    my $y6 = $y5;
    # $x1 = round($x1);
    # $x2 = round($x2);
    # $x3 = round($x3);
    # $x4 = round($x4);
    # $x5 = round($x5);
    # $x6 = round($x6);
    # $y1 = round($y1);
    # $y2 = round($y2);
    # $y3 = round($y3);
    # $y4 = round($y4);
    # $y5 = round($y5);
    # $y6 = round($y6);

    my $ret = '';
    $ret .= "<polyline points=".
	"'$x1, $y1 $x2p, $y2 $x3p, $y3 $x4, $y4 $x5, $y5 $x6, $y6 $x1, $y1' ".
	"stroke='$colour' fill='$fill' stroke-width='$stroke_width'/>\n";
    $ret;
}

open(my $fho, ">hexagon.svg") or die $!;

my $maxx = 4.0*$repeatx*$R;
my $maxy = 2.5*$repeaty*$r;
my $svg = '
    <svg version="1.1"
    width="'.$maxx.'" height="'.$maxy.'"
    xmlns="http://www.w3.org/2000/svg">
    ';

my $y = $r;
my $odd = 1;
my $row = 0;
my $column = 0;
while(1){
    $row++;
    $row == $repeaty * 2 and last;
    
    # Even and odd rows are staggered by displacing the first hexagon
    my $x = $odd?($R*2.5):$R;
    
    $column = 0;
    while(1){
	$svg .= hexagon($x, $y, $R, $r);
	$x += (3*$R);
	$column++; # Columns are stagered with a blank between hexegons
	$column == int($repeatx/2) and last;
    }
    $odd = $odd?0:1;
    $y += $r;
}

$svg .= '
</svg>
    ';
print $fho $svg;

