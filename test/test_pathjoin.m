% pathjoin unit tests

% Copyright (c) 2013, Alexander Roehnsch
% Released under the terms of the BSD 2-Clause License (FreeBSD license)
% http://opensource.org/licenses/BSD-2-Clause
function test_pathjoin

% empty string from empty input
expect_from(@() pathjoin(), '');
expect_from(@() pathjoin(''), '');
expect_from(@() pathjoin([]), '');
expect_from(@() pathjoin({}), '');

% return single items, from string or from cell
expect_from(@() pathjoin('.'), '.');
expect_from(@() pathjoin('foo/bar'), 'foo/bar');
expect_from(@() pathjoin({'.'}), '.');
expect_from(@() pathjoin({'foo/bar'}), 'foo/bar');

% concat several items, may be multi-paths themselves
expect_from(@() pathjoin({'foo', 'bar'}), ['foo' pathsep 'bar']);
expect_from(@() pathjoin({'foo'; 'bar'}), ['foo' pathsep 'bar']);
expect_from(@() pathjoin({'.', 'foo/bar', ['..' pathsep '/home']}), ...
    ['.' pathsep 'foo/bar' pathsep '..' pathsep '/home']);

% empty strings will be joined anyway
expect_from(@() pathjoin({'', ''}), pathsep);
expect_from(@() pathjoin({'foo', '', 'bar'}), ['foo' pathsep pathsep 'bar']);
