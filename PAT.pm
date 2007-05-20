# ARRAT::PAT - PHP Array Tools
#
# Copyright (c) 2003-2007 Brian Shade <bshade@gmail.com>. All rights reserved.
# This program is free software; you can redistribute it and/or modify it under
# the same terms as Perl itself. If you make any modifications/improvements
# please let me know so I may include it in the new releases.
#

package Array::PAT;
require 5.6.1;
require Exporter;
@ISA = qw(Exporter);
$VERSION = '2.0';
@EXPORT = qw(array_change_key_case array_chunk array_combine array_count_values array_diff array_diff_assoc array_diff_key 
						array_fill array_flip array_intersect array_intersect_assoc array_intersect_key array_key_exists array_merge 
						array_pad array_product array_rand array_search array_slice array_sum array_unique in_array range shuffle);

use List::Util;
use strict;

#returns a hash with all string keys lowercased or uppercased
sub array_change_key_case{
	my($case, @updated_keys, @vals);
	$case = shift(@_);
	if($_[0] =~ /hash/gi){
		@updated_keys = keys(%{$_[0]});
		if($case){
			map { $_ =~ tr/a-z/A-Z/ } @updated_keys;
		}#if
		else{
			map { $_ =~ tr/A-Z/a-z/ } @updated_keys;
		}#else
		@vals = values(%{$_[0]});
		return array_combine(\@updated_keys, \@vals);
	}#if
	else{
		my %hash = @_;
		@updated_keys = keys(%hash);
		if($case){
			map { $_ =~ tr/a-z/A-Z/ } @updated_keys;
		}#if
		else{
			map { $_ =~ tr/A-Z/a-z/ } @updated_keys;
		}#else
		@vals = values(%hash);
		return %{array_combine(\@updated_keys, \@vals)};
	}#else
}#array_change_key_case


#split an array into chunks
sub array_chunk{
	my (@array, $size, $counter, @retval, @temp_array, $array_size);
	$size = shift(@_);
	if($_[0] =~ /array/gi){
		@array = @{$_[0]};
	}#if
	else{
		@array = @_;
	}#else
	$counter = 0;
	$array_size = @array;
	for(my $i=0;$i<$array_size;$i++){
		if($size == $counter){
			@retval = (@retval, [@temp_array]);
			undef(@temp_array);
			$counter = 0;
			$temp_array[$counter] = $array[$i];
		}#if
		elsif($size > $counter){
			$temp_array[$counter] = $array[$i];
			$counter++;
		}#elsif
	}#for
	if(($array_size%$size) != 0){
		#remainders
		@retval = (@retval, [@temp_array]);
		undef(@temp_array);
	}#if
	return @retval;
}#array_chunk

#creates an array by using one array for keys and another for its values
sub array_combine{
	my(@array_keys, @array_values, %retval);
	@array_keys = @{$_[0]};
	@array_values = @{$_[1]};
	if(@array_keys == @array_values && (@array_values != 0 && @array_values != 0)){
		for(my $i=0;$i<@array_keys;$i++){
			$retval{$array_keys[$i]} = $array_values[$i];
		}#for
		return \%retval;
	}#if
	else{
		return 0;
	}#else
}#array_combine

#returns a hash using the values of the input array as keys and their frequency in input as values
sub array_count_values{
	my %seen;
	if($_[0] =~ /array/gi){
		for(@{$_[0]}){
			$seen{$_ }++;
		}#for
		return \%seen;
	}#if
	else{
		for(@_){
			$seen{$_ }++;
		}#for
		return %seen;
	}#else
}#array_count_values

#this will return an array with the difference between the first and the second array
sub array_diff{
	my(@retval, $ret);
	if($_[0] =~ /array/gi){
		return array_unique(array_merge($_[0], $_[1]));
	}#if
	else{
		return array_unique(@_);
	}#else
}#array_diff

#computes the difference of arrays with additional index check
sub array_diff_assoc{
	my(%hash1, %hash2, %retval, @hash_keys);
	%hash1 = %{$_[0]};
	%hash2 = %{$_[1]};
	@hash_keys = keys(%hash2);
	while(my($k,$v) = each(%hash1)){
		if(in_array($k, @hash_keys) == 1){
			if($hash2{$k} !~ /\b$v\b/){
				$retval{$k} = $v;
			}#if
		}#if
		else{
			$retval{$k} = $v;
		}#else
	}#while
	if($_[2]){
		return %retval;
	}#if
	else{
		return \%retval
	}#else
}#array_diff_assoc

#computes the difference of arrays using keys for comparison
sub array_diff_key{
	my(%hash1, %hash2, %retval, @hkeys);
	%hash1 = %{$_[0]};
	%hash2 = %{$_[1]};
	@hkeys = keys(%hash2);
	while(my($k,$v) = each(%hash1)){
		if(in_array($k, @hkeys) == 0){
			$retval{$k} = $v;
		}#if
	}#while
	if($_[2]){
		return %retval;
	}#if
	else{
		return \%retval;
	}#else
}#array_diff_key

#fill an array with values
sub array_fill{
	my($start, $num, $value) = @_;
	my($stop, @retval);
	if($num <= 0){
		return 0;
	}#if
	else{
		$stop = $start + $num;
		for(my $i=$start;$i<$stop;$i++){
			$retval[$i] = $value;
		}#for
		if($_[3]){
			return @retval;
		}#if
		else{
			return \@retval;
		}#else
	}#else
}#array_fill

#exchanges all keys with their associated values in an array
sub array_flip{
	my($ret, %hash, %retval);
	if($_[0] =~ /hash/gi){
		%hash = %{$_[0]};
	}#if
	else{
		$ret = 1;
		%hash = @_;
	}#else
	while(my($k,$v) = each(%hash)){
		$retval{$v} = $k;
	}#while
	if($ret){
		return %retval;
	}#if
	else{
		return \%retval;
	}#else
}#array_flip

#computes the intersection of arrays
sub array_intersect{
	my(@array1, @retval, @array_values);
	@array1 = @{$_[0]};
	for(my $i=0;$i<@array1;$i++){
		if(in_array($array1[$i], $_[1]) == 1){
			@retval = (@retval, $array1[$i]);
		}#if
	}#for
	if($_[2]){
		return @retval;
	}#if
	else{
		return \@retval;
	}#else
}#array_intersect

#computes the intersection of arrays with additional index check
sub array_intersect_assoc{
	my(%hash1, %hash2, %retval, @hash_keys);
	%hash1 = %{$_[0]};
	%hash2 = %{$_[1]};
	@hash_keys = keys(%hash2);
	while(my($k,$v) = each(%hash1)){
		if(in_array($k, \@hash_keys) == 1){
			if($hash2{$k} =~ /\b$v\b/){
				$retval{$k} = $v;
			}#if
		}#if
	}#while
	if($_[2]){
		return %retval;
	}#if
	else{
		return \%retval;
	}#else
}#array_intersect_assoc

#computes the intersection of arrays using keys for comparison
sub array_intersect_key{
	my(%hash1, %hash2, %retval, @hkeys);
	%hash1 = %{$_[0]};
	%hash2 = %{$_[1]};
	@hkeys = keys(%hash2);
	while(my($k,$v) = each(%hash1)){
		if(in_array($k, \@hkeys) == 1){
			$retval{$k} = $v;
		}#if
	}#while
	if($_[2]){
		return %retval;
	}#if
	else{
		return \%retval;
	}#else
}#array_intersect_key

#checks if the given key or index exists in the array
sub array_key_exists{
	my($key, @array, %hash, $retval,$test);
	$key = shift(@_);
	$test = shift(@_);
	if($test == 1){
		@array = @_;
	}#if
	elsif($test == 2){
		%hash = @_;
	}#elsif
	elsif($test =~ /array/gi){
		@array = @{$test};
		my $temp = @array;
	}#elsif
	elsif($test =~ /hash/gi){
		%hash = {$test};
	}#elsif
	if(%hash){
		return in_array($key, \keys(%hash));
	}#if
	elsif(@array){
		return in_array($key, \@array);
	}#elsif
}#array_key_exists

#merges the elements of two or more arrays together so that the values of one are appended to the end of the previous one
sub array_merge{
	if($_[0] =~ /array/gi){
		my @temp = array_merge(@{$_[0]}, @{$_[1]});
		return \@temp;
	}#if
	else{
		return @_;
	}#else
}#array_merge

#Returns a copy of the input padded to size specified by pad_size with value pad_value.
 sub array_pad{
 	my($pad_size, $pad_value, @array, $diff, @retval, $ret);
 	$pad_size = shift(@_);
	$pad_value = shift(@_);
	if($_[0] =~ /array/gi){
		$ret = 1;
		@array = @{$_[0]};
	}#if
	else{
		@array = @_;
	}#else
	$pad_size = abs $pad_size;
	$diff = $pad_size - @array;
	if($diff <= 0) {
 		return 0;
 	}#if
	@retval = ($pad_value) x $diff;
	if($pad_size < 0){
		unshift(@array, @retval);
	}#if
	else{
		push(@array, @retval);
 	}#else
	if($ret){
		return \@array;
	}#if
	else{
		return @array;
	}#else
}#array_pad

#calculate the product of values in an array
sub array_product{
	my(@array, $retval);
	if($_[0] =~ /array/gi){
		@array = @{$_[0]};
	}#if
	else{
		@array = @_;
	}#else
	$retval = $array[0];
	for(my $i=1;$i<@array;$i++){
		$retval = ($retval * $array[$i]);
	}#for
	return $retval;
}#array_product

#pick one or more random entries out of an array
sub array_rand{
	my($num, @array, %hash, @retval, $test, @hash_keys, $temp_key, $ran);
	$num = shift(@_);
	$test = shift(@_);
	if($test == 0){
		#it's  a reference
		if($_[0] =~ /array/gi){
			@array = @{$_[0]};
		}#if
		elsif($_[0] =~ /hash/gi){
			%hash = %{$_[0]};
		}#elsif
	}#if
	elsif($test == 1){
		#array
		@array = @_;
	}#elsif
	elsif($test == 2){
		#hash
		%hash = @_;
	}#elsif
	if(@array){
		while(@retval < $num){
			srand;
			$ran = rand(scalar(@array));
			if(in_array($array[$ran], \@retval) == 0){
				@retval = (@retval, $array[$ran]);
			}#if
		}#while
	}#if
	elsif(%hash){
		@hash_keys = keys(%hash);
		while(@retval < $num){
			srand;
			$ran = rand(scalar(@hash_keys));
			$temp_key = $hash_keys[$ran];
			if(in_array($hash{$temp_key}, \@retval) == 0){
				@retval = (@retval, $hash{$temp_key});
			}#if
		}#while
	}#elsif
	if($test == 0){
		return \@retval;
	}#if
	else{
		return @retval;
	}#else
}#array_rand

#searches the array for a given value and returns the corresponding key if successful
sub array_search{
	my($needle, @haystack, $retval);
	$needle = shift(@_);
	if($_[0] =~ /array/gi){
		@haystack = @{$_[0]};
	}#if
	else{
		@haystack = @_;
	}#else
	$retval = -1;
	for(my $i=0;$i<@haystack;$i++){
		if($haystack[$i] =~ /\b$needle\b/){
			$retval = $i;
			last;
		}#if
	}#for
	return $retval;
}#array_search

#extract a slice of the array
sub array_slice{
	my(@array, $offset, $len, $start, $finish, @retval);
	$offset = shift(@_);
	$len = shift(@_);
	if($_[0] =~ /array/gi){
		@array = @{$_[0]};
	}#if
	else{
		@array = @_;
	}#else
	if($offset < 0){
		$start = scalar(@array) + $offset;
	}#if
	else{
		$start = $offset;
	}#else
	if($len < 0){
		$finish = scalar(@array) + $len;
	}#if
	elsif($len > 0){
		$finish = $start + $len;
	}#elsif
	else{
		$finish = @array;
	}#else
	for(my $i=$start;$i<$finish;$i++){
		@retval = (@retval, $array[$i]);
	}#for
	if(@_  == 1){
		return \@retval;
	}#if
	else{
		return @retval;
	}#else
}#array_slice

#calculate the sum of values in an array
sub array_sum{
	my(@array, $retval);
	if($_[0] =~ /array/gi){
		@array = @{$_[0]};
	}#if
	else{
		@array = @_;
	}#else
	$retval = $array[0];
	for(my $i=1;$i<@array;$i++){
		$retval = ($retval + $array[$i]);
	}#for
	return $retval;
}#array_sum

#remove all duplicate entries in an array
sub array_unique{
	if($_[0] =~ /array/gi){
		my %seen = map { $_ => 1 } @{$_[0]};
		my @temp = keys(%seen);
		return \@temp;
	}#elsif
	else{
		my %seen = map { $_ => 1 } @_;
		return keys(%seen);
	}#else
}#array_unique

#checks to see if an item is in the specified array
sub in_array{
	my($needle, @array);
	$needle = shift(@_);
	if($_[0] =~ /array/gi){
		@array = @{$_[0]};
	}#if
	else{
		@array = @_;
	}#else
	for(@array){
		if($_ =~ /\b$needle\b/){
			return 1;
		}#if
	}#for
	return 0;
}#in_array

#create an array containing a range of elements
sub range{
	my($low, $high, $step);
	$low = shift(@_);
	$high = shift(@_);
	if(@_){
		$step = shift(@_);
	}#if
	else{
		$step = 0;
	}#else
	my(@retval);
	if($low =~ /\d+/gi){
		if($low < $high){
			$high++;
			for(my $i=$low;$i<$high;$i++){
				for(my $j=0;$j<$step;$j++){
					$i++;
				}#for
				@retval = (@retval, $i);
			}#for
		}#if
		else{
			$high--;
			for(my $i=$low;$i>$high;$i--){
				for(my $j=0;$j<$step;$j++){
					$i--;
				}#for
				@retval = (@retval, $i);
			}#for
		}#else
	}#if
	else{
		if($high gt $low){
			$high++;
			for(my $i=$low;$i lt $high;$i++){
				for(my $j=0;$j<$step;$j++){
					$i++;
				}#for
				@retval = (@retval, $i);
			}#for
		}#if
		elsif($high lt $low){
			$low++;
			for(my $i=$high;$i lt $low;$i++){
				for(my $j=0;$j<$step;$j++){
					$i--;
				}#for
				@retval = (@retval, $i);
			}#for
			@retval = reverse(@retval);
		}#elsif
	}#else
	return \@retval;
}#range

#returns an array in random order
sub shuffle{
	if($_[0] =~ /array/gi){
		my @shuffled = List::Util::shuffle @{$_[0]};
		return \@shuffled
	}#if
	else{
		my @shuffled = List::Util::shuffle @_;
		return @shuffled
	}#else
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
  ...

=head1 DESCRIPTION

This module is designed to give Perl the same array functionality that can be found in PHP. In PHP, hashes are called associative
arrays and are treated similarly to numeric arrays. As is such, some of these functions will work with hashes or arrays. Just
as The Beatles say:

=begin html
<p><i>"And in the end, the love you take,<br>
is equal to the love you make" - "The End", John Lennon/Paul McCartney (1969)</i></p>


This applies to all functions, unless otherwise noted. If you use pass by value, you will recieve a value back, but if you pass
a reference to a hash or value, you will receive a reference back. This is to support backwards compatability, it might be removed
in later releases.   

=head1 FUNCTIONS

=head2 array_change_key_case()

<code>%changed = array_change_key_case($case, %hash);<br>
---OR---<br>
$hash_ref = array_change_key_case($case, \%hash);</code><br><br>
This function will take a hash and change all keys to either uppercase or lowercase. It will accept a hash or
a hash reference. To make the keys uppercase, set <code>$case</code> to 1. To make the keys lowercase, set <code>$case</code> to 0.
The function will leave number indices as is.

=head2 array_chunk()

<code>
@return = array_chunk($size, @array);<br>
---OR---<br>
$reference = array_chunk($size, \@array);</code><br><br>

This function splits the array into several arrays with size values in them. You may also have an array with less values 
at the end. You get the arrays as members of a multidimensional array indexed with numbers starting from zero. This 
method will <b>NOT</b> preserve the keys like its PHP cousin.

=head2 array_combine()

<code>$hash_ref = array_combine(\@keys, \@values);</code><br><br>

This function returns a hash reference by using the values from the keys array as keys and the values from the values array 
as the corresponding values. Returns 0 if the number of elements for each array isn't equal or if the arrays are empty. 
This function will <b>ONLY</b> accept array references, do not use pass by value.

=head2 array_count_values()

<code>%return = array_count_values(@array);</code><br><br>

This function scans the given array and returns a hash with the keys as the unique elements 
of the array and the values are how many times each unique element is in the array.

=head2 array_diff()

<code>@return = array_diff(@array1, @array2);<br>
---OR---<br>
$array_reference = array_diff(\@array1, \@array2);</code><br><br>

This function returns an array containing all the values of array1  that are not present in any of the other arguments. 
Note that keys are <b>NOT</b> preserved.

=head2 array_diff_assoc()

<code> %return = array_diff_assoc(\%hash1, \%hash2, $return);<br>
---OR---<br>
$hash_ref = array_diff_assoc(\%hash1, \%hash2);</code><br><br>

Returns an array  containing all the values from array1  that are not present in any of the other arguments.
Note that the keys are used in the comparison unlike <code>array_diff()</code>. If you specify <code>$return</code> to be 1, 
it will return a hash. If <code>$return</code> is omitted or specified to be 0, you will recieve a hash reference.

=head2 array_diff_key()

<code> %return = array_diff_key(\%hash1, \%hash2, $return);<br>
---OR---<br>
$hash_ref = array_diff_key(\%hash1, \%hash2);</code><br><br>

Returns an array containing all the values of hash1 that have keys that are not present in any of the other arguments.
Note that the associativity is preserved. This function is like <code>array_diff()</code> except the comparison is done on the keys instead 
of the values. Strict type check is executed so the string representation must be the same. If you specify <code>$return</code> to be 1, 
it will return a hash. If <code>$return</code> is omitted or specified to be 0, you will recieve a hash reference.

=head2 array_fill()

<code>@array = array_fill($start, $num, $value, $return);<br>
---OR---<br>
$array_ref = array_fill($start, $num, $value);</code><br><br>

Fills an array with num entries of the value of the value parameter, keys starting at the start_index parameter. 
Note that  num must be a number greater than zero, or 0 will be returned. If you specify <code>$return</code> to be 1, 
it will return an array. If <code>$return</code> is omitted or specified to be 0, you will recieve an array reference.

=head2 array_flip()

<code>%flipped = array_flip(%hash);<br>
---OR---<br>
$hash_ref = array_flip(\%hash);</code><br><br>

Returns an array in flip order. The keys become the values and the values become the keys. If a value has several occurrences, 
the latest key will be used as its values, and all others will be lost.

=head2 array_interset()

<code>@return = array_intersect(\@array1, \@array2, $return);<br>
---OR---<br>
$array_ref = array_intersect(\@array1, \@array2);</code><br><br>

Returns an array containing all the values of array1  that are present in array2. Note that keys are <b>NOT</b> preserved. If you specify
<code>$return</code> to be 1, it will return an array. If <code>$return</code> is omitted or specified to be 0, you will recieve an array 
reference.

=head2 array_intersect_assoc()

<code> %return = array_intersect_assoc(\%hash1, \%hash2, $return);<br>
---OR---<br>
$hash_ref = array_intersect_assoc(\%hash1, \%hash2);</code><br><br>

Returns a hash containing all the values of hash1 that are present in hash2. Note that the keys are used in the comparison unlike in 
<code>array_intersect()</code>. if you specify <code>$return</code> to be 1, it will return a hash. If <code>$return</code> is omitted 
or specified to be 0, you will recieve a hash reference.

=head2 array_intersect_key()

<code> %return = array_intersect_key(\%hash1, \%hash2, $return);<br>
---OR---<br>
$hash_ref = array_intersect_key(\%hash1, \%hash2);</code><br><br>

Returns a hash containing all the values of hash1  which have matching keys that are present in hash2. Strict type check is executed 
so the string representation must be the same. If you specify <code>$return</code> to be 1, it will return a hash. If <code>$return</code> 
is omitted or specified to be 0, you will recieve a hash reference.

=head2 array_key_exists()

<code>$return = array_key_exists($key, 1, @array);<br>
---OR---<br>
$return = array_key_exists($key, 2, %hash);<br>
---OR---<br>
$return = array_key_exists($key, \@array);<br>
---OR---<br>
$return = array_key_exists($key, \%hash);</code><br><br>

Returns 1 if the given key is in the array or hash. If you want to use pass by value, you <b>MUST</b> specify a 1 for an array or a 2 
for a hash. If you are using pass by reference, you do not need to do this.

=head2 array_merge()

<code>@array_merged = array_merge(@array1, @array2);<br>
---OR---<br>
@array_merged = array_merge(\@array1, \@array2);</code><br><br>

This function merges the two given arrays together. It returns an array with all elements of
array1 placed in the beginning of the merged array, followed by all the elements of array2.

=head2 array_pad()

<code>@padded_array = array_pad($pad_size, $pad_value, @array);<br>
---OR---<br>
$array_ref = array_pad($pad_size, $pad_value, \@array);</code><br><br>

This function returns a copy of the input padded to size specified by pad_size with value pad_value.
If pad_size is positive then the array is padded on the right, if it's negative then on the left.
If the absolute value of pad_size is less than or equal to the length of the input then no padding 
takes place. The pad_size must be an integer, but the pad_value may be of any type.

=head2 array_product()

<code>$product = array_product(@array);<br>
---OR---<br>
$product = array_product(\@array);</code><br><br>

Returns the product of values in an array as an integer or float.

=head2 array_rand()

<code>@random = array_rand($number, 1, @array);<br>
---OR---<br>
@random = array_rand($number, 2, %hash);<br>
---OR---<br>
$array_ref = array_rand($number, \@array);<br>
---OR---<br>
$array_ref = array_rand($number, \%hash);</code><br><br>

It takes an array/hash and a number which specifies how many entries you want to pick. It returns an array of keys for the random entries. 
This is done so that you can pick random keys as well as values out of the array. if you want to use pass by value, you <b>MUST</b> 
specify a 1 for an array or a 2 for a hash. If you are using pass by reference, you do not need to do this.

=head2 array_search()

<code>$return = array_search($needle, @haystack);<br>
---OR---<br>
$return = array_search($needle, \@haystack);</code><br><br>

Searches the given array for the value and will return the index if found. If it does not find the value, it will return -1.

=head2 array_slice()

<code>@return = array_slice($offset, $length, @array);<br>
---OR---<br>
$array_ref = array_slice($offset, $length, \@array);</code><br><br>

Returns the sequence of elements from the array as specified by the offset and length  parameters. If offset is non-negative, 
the sequence will start at that offset in the array. If offset is negative, the sequence will start that far from the end of the array.
if length is given and is positive, then the sequence will have that many elements in it. If length is given and is negative then the 
sequence will stop that many elements from the end of the array. If it is omitted, then the sequence will have everything from offset up 
until the end of the array. 

=head2 array_sum()

<code>$sum = array_sum(@array);<br>
---OR---<br>
$sum = array_sum(\@array);</code><br><br>

Returns the sum of values in an array as an integer or float.

=head2 array_unique()

<code>@duplicates_removed = array_unique(@array);<br>
---OR---<br>
$array_ref = array_unique(\@array);</code><br><br>

This function returns an array with all of the duplicate entries of the given array removed.

=head2 in_array()

<code>$return = in_array($needle, @haystack);<br>
---OR---<br>
$return = in_array($needle, \@haystack);</code><br><br>

This function returns 1 if the the array contains the value, otherwise it will return 0.

=head2 range()

<code>$array_ref = range($low, $high, $step);<br>
---EXAMPLE---<br>
$array_ref = range('a','m', 2);<br>
---OR---<br>
$array_ref = range(100, 2, 6);</code><br><br>

Returns an array of elements from low to high, inclusive. If low > high, the sequence will be from high to low. If a step value is given, it 
will be used as the increment between elements in the sequence. step should be given as a positive number. If not specified, step will default 
to 1. The low and high may be integers or characters.

=head2 shuffle()

<code>@shuffled = shuffle(@array);<br>
---OR---<br>
$array_ref = shuffle(\@array);</code><br><br>

This function returns the passed array with its elements placed in a random order.

=head1 AUTHOR

Brian Shade <bshade@gmail.com>

=head1 SEE ALSO

perl(1).

=cut
