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
% i.e. C:\ or /. This is in fact questionable. If one is an absolute, but the
% other a relative path, they should be used for calculation only after
% canonizing them. But this is a simple implementation and we can live with it.
expect_from(@() relpath('/foo/foo', 'bar/bar'), ...
    full_route);
expect_from(@() relpath('foo/foo', '/bar/bar'), ...
    full_route);

% this is especially vexing; we'd need to incorporate the multi entry node
% behaviour of windows systems with its C:\, D:\, ... in order to calculate
% proper relative paths there; alternatively, return the to-path if no common
% base was found and to-path is decidedly absolute
% Also, on Unix, fileparts does not strip the \ off C:\.
expect_from(@() relpath('foo/foo', 'c:\bar/bar'), ...
    {['..' filesep '..' filesep 'c:\bar' filesep 'bar']});

% identical paths
expect_from(@() relpath('foo/bar', 'foo/bar'), {''});
