% paths unit tests

% Copyright (c) 2013, Alexander Roehnsch
% Released under the terms of the BSD 2-Clause License (FreeBSD license)
% http://opensource.org/licenses/BSD-2-Clause
function test_paths

% set up path stub, lest MATLAB gets confused with our path mangling
% switch off stub warnings
oldwarnstate = warning('off', 'MATLAB:dispatcher:nameConflict');
testdir = fileparts(mfilename('fullpath'));
stubdir = fullfile(testdir, 'paths_stubs');
oldpath = builtin('path');     % save path state
addpath(stubdir);   % temporarily add stubs path


% define test data
% get current path as reference
mlpath = path;
mlpathc = path_expand(mlpath);
% define another path for comparison
altpath = ['/some/arbitrary/path' pathsep '/foo/bar' pathsep 'also/relatives' pathsep '..'];
altpathc = path_expand(altpath);


% paths returns path as cell array
expect_from(@() paths(), mlpathc);

% try also controlledly set the path
expect_from(@() set_get_restore_paths(mlpathc), mlpath, mlpathc);
expect_from(@() set_get_restore_paths(altpathc), altpath, altpathc);

% for single string input, behaviour should be identical to MATLAB's path
expect_from(@() set_get_restore_paths, mlpath, mlpathc);
expect_from(@() set_get_restore_paths(''), '', {''}); % don't try this unstubbed
expect_from(@() set_get_restore_paths(mlpath), mlpath, mlpathc);
expect_from(@() set_get_restore_paths(altpath), altpath, altpathc);


% revert stubbing
builtin('path', oldpath);   % restore actual MATLAB path
warning(oldwarnstate);      % restore warn state



% Set path to a specific setting, then query the actual path being set, last
% restore the previous path. The queried path is returned in two forms: a) as
% pathsep concatenated string, b) as cell array of string. In this way, both
% outputs can be compared and verfied.
function [pstring, pcell] = set_get_restore_paths(pin)

    % set path
    if nargin >= 1
        oldpath = paths(pin);
    else
        % without args, path is refreshed
        oldpath = paths();
    end

    % get path as MATLAB's path string and as path cell array
    pstring = path();
    pcell = paths();

    % restore path
    paths(oldpath);
