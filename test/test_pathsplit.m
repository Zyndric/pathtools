% pathsplit unit tests

% Copyright (c) 2013, Alexander Roehnsch
% Released under the terms of the BSD 2-Clause License (FreeBSD license)
% http://opensource.org/licenses/BSD-2-Clause
function test_pathsplit

% empty cell from no input
expect_from(@() pathsplit(), {});

% empty cell string from empty input
expect_from(@() pathsplit(''), {''});
expect_from(@() pathsplit([]), {''});
expect_from(@() pathsplit({}), {''});

% return single items
expect_from(@() pathsplit('.'), {'.'});
expect_from(@() pathsplit('foo/bar'), {'foo/bar'});

% split several items
expect_from(@() pathsplit(['foo' pathsep 'bar']), {'foo'; 'bar'});
expect_from(@() pathsplit(['.' pathsep 'foo/bar' pathsep '..']), {'.'; 'foo/bar'; '..'});

% strangely, textscan splits leading separators, but not closing separators
expect_from(@() pathsplit(pathsep), {''});
expect_from(@() pathsplit([pathsep pathsep]), {'';''});
expect_from(@() pathsplit([pathsep 'foo' pathsep]), {'';'foo'});
