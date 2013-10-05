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

% empty to-path should yield empty relpath
expect_from(@() relpath('foo/bar', ''), {''});

% without common base
full_route = {['..' filesep '..' filesep 'bar' filesep 'bar']};
expect_from(@() relpath('foo/foo', 'bar/bar'), ...
    full_route);

% should yield the same results with or without leading abspath markers,
% i.e. C:\ or /.
expect_from(@() relpath('/foo/foo', 'bar/bar'), ...
    full_route);
expect_from(@() relpath('foo/foo', 'c:\bar/bar'), ...
    full_route);

% identical paths
expect_from(@() relpath('foo/bar', 'foo/bar'), {''});
