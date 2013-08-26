% dirset unit tests

% Copyright (c) 2013, Alexander Roehnsch
% Released under the terms of the BSD 2-Clause License (FreeBSD license)
% http://opensource.org/licenses/BSD-2-Clause
function test_dirset

% we assume following directory structure
%   /home/foo/
%   /home/foo/bar/
%   /home/foo/bar/moo/
%   /home/foo/nuf/
% with pwd being in /home/foo/
pwd_dir = [filesep 'home' filesep 'foo'];

pwd_relative_depth   = {''; 'bar'; ['bar' filesep 'moo']; 'nuf'};
pwd_relative_breadth = {''; 'bar'; 'nuf'; ['bar' filesep 'moo']};

pwd_absolute_depth   = fullfilec(pwd_dir, pwd_relative_depth);
pwd_absolute_breadth = fullfilec(pwd_dir, pwd_relative_breadth);

bar_dir = fullfile(pwd_dir, 'bar');

bar_relative = {'bar'; ['bar' filesep 'moo']};
bar_absolute = fullfilec(pwd_dir, bar_relative);


% setup, save path state and temporarily add stubs path
testdir = fileparts(mfilename('fullpath'));
stubdir = fullfile(testdir, 'dirset_stubs');
oldpath = path;
addpath(stubdir);


% execute tests
expect_from(@() dirset(), ...
    pwd_absolute_depth);

expect_from(@() dirset(pwd), ...
    pwd_absolute_depth);
expect_from(@() dirset(pwd, true), ...
    pwd_absolute_depth);
expect_from(@() dirset(pwd, false), ...
    pwd_absolute_breadth);

expect_from(@() dirset(''), ...
    pwd_relative_depth);
expect_from(@() dirset('', false), ...
    pwd_relative_breadth);

expect_from(@() dirset('.'), ...
    fullfilec('.', pwd_relative_depth));
expect_from(@() dirset('.', false), ...
    fullfilec('.', pwd_relative_breadth));

expect_from(@() dirset(bar_dir), ...
    bar_absolute);

expect_from(@() dirset('bar'), ...
    bar_relative);

expect_error(@() dirset('invalid'));

disp('dirset: 11 tests run.');


% shutdown, restore old path
path(oldpath);


function expect_error(fun)

    bCaught = false;
    try
        fun();
    catch
        bCaught = true;
    end
    
    if ~bCaught
        error('Error expected, but none occurred.');
    end
