# ARRAT::PAT - PHP Array Tools
#
# Copyright (c) 2003 Brian Shade <bshade@eden.rutgers.edu>. All rights reserved.
# This program is free software; you can redistribute it and/or modify it under
# the same terms as Perl itself. However, if you make any modifications/improvements
# please let me know so I may include it in the new releases.
#

package Array::PAT;
require 5.001;
require Exporter;
@ISA = qw(Exporter);
$VERSION = '1.0';
@EXPORT = qw(in_array array_unique array_count_values array_merge array_pad shuffle); #put the subroutine names in here
use strict;

#checks to see if an item is in the specified array
sub in_array{
	my ($check, @array) = @_;
	my $retval = 0;
	foreach my $test (@array){
		if($check eq $test){
			$retval =  1;
		}#if
	}#foreach
	return $retval;
}#in_array

#remove all duplicate entries in an array
sub array_unique{
	my (@array) = @_;
	my @nodupes;
	foreach my $element (@array){
		if(in_array($element, @nodupes) == 0){
			@nodupes = (@nodupes, $element);
		}#if
	}#foreach
	return @nodupes;
}#array_unique

#returns a hash using the values of the input array as keys and their frequency in input as values
sub array_count_values{
	my(@array) = @_;
	my @unduped = array_unique(@array);
	my %rethash;
	foreach my $mykey (@unduped){
		$rethash{$mykey} = 0;
	}#foreach
	foreach my $key (@array){
		my $value = $rethash{$key};
		$value++;
		$rethash{$key} = $value;
	}#foreach
	return %rethash;
}#array_count_values

#merges the elements of two or more arrays together so that the values of one are appended to the end of the previous one
sub array_merge{
	my(@array1, @array2) = @_;
	foreach my $element (@array2){
		@array1 = (@array1, $element);
	}#foreach
	return @array1;
}#array_merge

#Returns a copy of the input padded to size specified by pad_size with value pad_value.
#If pad_size is positive then the array is padded on the right, if it's negative then on the left.
#If the absolute value of pad_size is less than or equal to the length of the input then no padding takes place.
#int pad_size, mixed pad_value, array  input
sub array_pad{
	my($pad_size, $pad_value, @array) = @_;
	#this is just to get the absolute value of the pad_size
	my $temp = $pad_size;
	if($pad_size < 0){
		$temp = $temp * -1;
	}#if
	#first let's see if the pad_size is less than or equal to the array size, return 0 no padding
	my $input_size = @array;
	if($temp <= $input_size){
		return 0;
	}#if
	#since it didn't return 0, time to pad
	#if the pad_size is < 0, pad on the left, else the right
	if($pad_size < 0){
		my @retval;
		$temp = $temp - $input_size;
		for(my $i=0;$i<$temp;$i++){
			unshift(@array, $pad_value);
		}#for
		return @array;
	}#if
	else{
		$temp = $pad_size - $input_size;
		for(my $i=0;$i<$temp;$i++){
			push(@array, $pad_value);
		}#for
		return @array;
	}#else
}#array_pad

#returns an array in random order
sub shuffle{
	my(@array) = @_;
	srand;
	my $size = @array;
	my $random = int(rand($size));
	my @tracker;
	@tracker  = (@tracker, $random);
	my @retval;
	@retval = (@retval, $array[$random]);
	while(@retval < @array){
		$random = int(rand($size));
		if(in_array($random, @tracker) == 0){
			@tracker = (@tracker, $random);
			@retval = (@retval, $array[$random]);
		}#if
	}#while
	return @retval;
}#shuffle

1;

__END__

=head1 NAME

Array::PAT - PHP Array Tools - Perl extension for array functions that are built into PHP.

=head1 SYNOPSIS

  use Array::PAT;

  @array = @array = qw(foo bar foo bar foo);
  $result = in_array("foo", @array);
  @duplicates_removed = array_unique(@array);
  @merged = array_merge(@array, @duplicates_removed);
  @foo = array_pad(17, 3, @array);
  @shuffled = shuffle(@foo);
  %result = array_count_values(@shuffled);

=head1 DESCRIPTION

This module is designed to give Perl the same array functionality that can be found in PHP.

=head1 METHODS

=head2 %return = array_count_values(@array)

This method scans the given array and returns a hash with the keys as the unique elements 
of the array and the values are how many times each unique element is in the array.

=head2 @array_merged = array_merge(@array1, @array2)

This method merges the two given arrays together. It returns an array with all elements of
array1 placed in the beginning of the merged array, followed by all the elements of array2.

=head2 @padded_array = array_pad($pad_size, $pad_value, @array)

This method returns a copy of the input padded to size specified by pad_size with value pad_value.
If pad_size is positive then the array is padded on the right, if it's negative then on the left.
If the absolute value of pad_size is less than or equal to the length of the input then no padding 
takes place. The pad_size must be an integer, but the pad_value may be of any type.

=head2 @duplicates_removed = array_unique(@array)

This method returns an array with all of the duplicate entries of the given array removed.

=head2 $returned_value = in_array($check, @array)

This method returns 1 if the the array contains $check, otherwise it will return 0.

=head2 @shuffled = shuffle(@array)

This method returns the passed array with its elements placed in a random order.

=head1 AUTHOR

Brian Shade <bshade@eden.rutgers.edu>

=head1 SEE ALSO

perl(1).

=cut
