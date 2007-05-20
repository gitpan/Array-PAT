use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'	=> 'Array::PAT',
    'VERSION_FROM' => 'PAT.pm', # finds $VERSION
    PREREQ_PM => {
		'List::Util' => 0, # minimum version unchecked
		},
);
