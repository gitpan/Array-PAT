#!/usr/bin/perl -w

use Test::More tests => 16;
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

