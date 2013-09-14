% relpath unit tests

% Copyright (c) 2013, Alexander Roehnsch
% Released under the terms of the BSD 2-Clause License (FreeBSD license)
% http://opensource.org/licenses/BSD-2-Clause
function test_relpath

% normal use case
expect_from(@() relpath('foo/bar', 'foo/moo/nuf'), ...
    {['..' filesep 'moo' filesep 'nuf']});

% empty from-path should yield to-path
expect_from(@() relpath('', ''), {''});
expect_from(@() relpath('', 'abc'), {'abc'});

% no common base
expect_from(@() relpath('foo/foo', 'bar/bar'), ...
    {['..' filesep '..' filesep 'bar' filesep 'bar']});

% identical paths
expect_from(@() relpath('foo/bar', 'foo/bar'), {''});
