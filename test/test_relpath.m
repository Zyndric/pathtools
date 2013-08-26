% relpath unit tests

% Copyright (c) 2013, Alexander Roehnsch
% Released under the terms of the BSD 2-Clause License (FreeBSD license)
% http://opensource.org/licenses/BSD-2-Clause
function test_relpath

% normal use case
expect_from(@() relpath('foo/bar', 'foo/moo/nuf'), ...
    {['..' filesep 'moo' filesep 'nuf']});

expect_from(@() relpath(''));

disp('relpath: 1 test run.');
