% fileset unit tests

% Copyright (c) 2013, Alexander Roehnsch
% Released under the terms of the BSD 2-Clause License (FreeBSD license)
% http://opensource.org/licenses/BSD-2-Clause
function test_fileset

% we assume following directory structure
%   /home/foo/
%   /home/foo/bar/
%   /home/foo/bar/moo/
%   /home/foo/nuf/
% with pwd being in /home/foo/
pwd_dir = [filesep 'home' filesep 'foo'];

files_relative = {'foo'; '.hgrc'; '.temp.txt'; 'abc.txt'; ['bar' filesep '.txt']};
files_absolute = fullfilec(pwd_dir, files_relative);
files_local = fullfilec('.', files_relative);

files_bar = {['bar' filesep '.txt']};

txts_relative = {'.temp.txt'; 'abc.txt'; ['bar' filesep '.txt']};

% setup, save path state and temporarily add stubs path
testdir = fileparts(mfilename('fullpath'));
stubdir = fullfile(testdir, 'dirset_stubs');
oldpath = path;
addpath(stubdir);


allfiles_ondefault = { ...
    @() fileset(), ...
    @() fileset(''), ...
    @() fileset([]), ...
    @() fileset('*'), ...
    @() fileset('*.*'), ...
    };

cellfun(@(fun) expect_from(fun, files_absolute), allfiles_ondefault);

allfiles_on = @(dir) { ...
    @() fileset('', dir), ...
    @() fileset([], dir), ...
    @() fileset('*', dir), ...
    @() fileset('*.*', dir), ...
    };

cellfun(@(fun) expect_from(fun, files_absolute), allfiles_on(pwd_dir));
cellfun(@(fun) expect_from(fun, files_relative), allfiles_on(''));
cellfun(@(fun) expect_from(fun, files_local), allfiles_on('.'));
cellfun(@(fun) expect_from(fun, files_bar), allfiles_on('bar'));

expect_from(@() fileset('non-existing-bogus'), {});
expect_from(@() fileset('non-existing-bogus', ''), {});
expect_from(@() fileset('non-existing-bogus', '.'), {});
expect_from(@() fileset('non-existing-bogus', pwd_dir), {});
expect_from(@() fileset('non-existing-bogus', 'bar'), {});

expect_from(@() fileset('*.txt', ''), txts_relative);

% shutdown, restore old path
path(oldpath);
