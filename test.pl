#!/usr/bin/perl -w

use Test::More tests => 36;
use Array::PAT;

@array = qw(foo bar foo bar perl cpan linux linus perl unix foo);
@num = (1,2,3,4,5,6,7,8,1,2,3);
is(in_array("foo", @array), 1, "Checked in_array Strings should be true");
is(in_array("java", @array), 0, "Checked in_array Strings should be false");
is(in_array(2, @num), 1, "Checked in_array Integers should be true");
is(in_array(27, @num), 0, "Checked in_array Integers should be false");
is(array_unique(@array), 7, "Checked array_uniqe Strings");
is(array_unique(@num), 8, "Checked array_uniqe Integers");
is(array_merge(@num, @array), 22,"Checked array_merge");
is(array_pad(17, 19, @num), 17, "Checked array_pad");
is(shuffle(@num), 11, "Checked shuffle");
%result = array_count_values(@array);
is($result{"foo"}, 3, "Checked array_count_values");
is($result{"bar"}, 2, "Checked array_count_values");
is($result{"perl"}, 2, "Checked array_count_values");
is($result{"cpan"}, 1, "Checked array_count_values");
is($result{"linux"}, 1, "Checked array_count_values");
is($result{"linus"}, 1, "Checked array_count_values");
is($result{"unix"}, 1, "Checked array_count_values");
%case = array_change_key_case(1, %result);
is($case{"UNIX"}, 1, "Checked array_change_key_case");
is($case{"CPAN"}, 1, "Checked array_change_key_case");
is(array_chunk(2, @num), 4,"Checked array_chunk");
%new = %{array_combine(\@num, \@array)};
is($new{"8"}, "linus", "Checked array_combine");
is(array_product(@num), 241920, "Checked array_product");
is(array_sum(@num), 42, "Checked array_sum");
@array2 = qw(foo bar foo bar perl cpan linux linus perl unix foo windows gates);
is(array_diff(@array, @array2), 9, "Checked array_diff");
@test_keys = keys(%{array_diff_assoc(\%result, \%new)});
is(@test_keys, 7, "Checked array_diff_assoc");
undef(@test_keys);
@test_keys = keys(%{array_diff_key(\%result, \%new)});
is(@test_keys, 7, "Checked array_diff_key");
is(array_fill(0, 6, "banana", 1), 6, "Checked array_fill");
%flip = array_flip(%case);
is($flip{3}, "FOO", "Checked_array_flip");
@array2 = qw(foo bar linux);
is(array_intersect(\@array, \@array2, 1), 4, "Checked array_intersect");
%inter = array_intersect_assoc(\%flip, \%case, 1);
is(keys(%inter), 0, "Checked array_intersect_assoc");
undef(%inter);
%inter = array_intersect_key(\%flip, \%case, 1);
is(keys(%inter), 0, "Checked array_intersect_key");
is(array_key_exists("unix", \@array), 1, "Checked array_key_exists");
is(@{array_rand(2, 0, \%result)}, 2, "Checked array_rand");
is(array_search("cpan", \@array), 5, "Checked array_search");
is(array_slice(2, 4, @array), 4, "Checked array_slice");
is(@{range('a','m', 2)}, 5, "Checked range");
is(@{range(100, 2, 6)}, 15, "Checked range");
#functions
#array_change_key_case - DONE
#array_chunk - DONE
#array_combine - DONE
#array_count_values - DONE
#array_diff - DONE
#array_diff_assoc - DONE
#array_diff_key - DONE
#array_fill - DONE
#array_flip - DONE
#array_intersect - DONE
#array_intersect_assoc - DONE
#array_intersect_key - DONE
#array_key_exists - DONE
#array_merge - DONE
#array_pad - DONE
#array_product - DONE
#array_rand - DONE
#array_search - DONE
#array_slice - DONE
#array_sum - DONE
#array_unique - DONE
#in_array - DONE
#range
#shuffle -DONE
