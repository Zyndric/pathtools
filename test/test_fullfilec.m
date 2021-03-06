% fullfilec unit tests

% Copyright (c) 2013, Alexander Roehnsch
% Released under the terms of the BSD 2-Clause License (FreeBSD license)
% http://opensource.org/licenses/BSD-2-Clause
function test_fullfilec

% no arguments
expect_from(@() ...
    fullfilec(), ...
    {});

% empty cell argument
expect_from(@() ...
    fullfilec({}), ...
    {''});

% most of following test cases come in two flavours:
% plain input arguments and cell array

% single empty argument
expect_from(@() ...
    fullfilec(''), ...
    {''});
expect_from(@() ...
    fullfilec({''}), ...
    {''});

% single argument
expect_from(@() ...
    fullfilec('foo'), ...
    {'foo'});
expect_from(@() ...
    fullfilec({'foo'}), ...
    {'foo'});

% actual fullfilec behaviour (2 arguments and up)
expect_from(@() ...
    fullfilec('foo', 'bar'), ...
    {['foo' filesep 'bar']});
expect_from(@() ...
    fullfilec({'foo'}, {'bar'}), ...
    {['foo' filesep 'bar']});
expect_from(@() ...
    fullfilec('foo', 'bar', 'moo'), ...
    {['foo' filesep 'bar' filesep 'moo']});
expect_from(@() ...
    fullfilec({'foo'}, {'bar'}, {'moo'}), ...
    {['foo' filesep 'bar' filesep 'moo']});

% fullfilec cell expansion
expect_from(@() ...
    fullfilec({'foo', 'foo2'}, 'bar'), ...
    {['foo' filesep 'bar'], ['foo2' filesep 'bar']});

% fullfilec cell element-wise expansion
expect_from(@() ...
    fullfilec({'foo', 'foo2'}, {'bar', 'bar2'}), ...
    {['foo' filesep 'bar'], ['foo2' filesep 'bar2']});

% fullfilec cell expansion with empty items
expect_from(@() ...
    fullfilec({'', 'foo'}, ''), ...
    {'', 'foo'});

% fullfilec cell expansion with empty cells
expect_from(@() ...
    fullfilec({'foo'}, {}), ...
    {'foo'});
