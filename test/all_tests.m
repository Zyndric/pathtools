% Execute all tests consecutively.

% Copyright (c) 2013, Alexander Roehnsch
% Released under the terms of the BSD 2-Clause License (FreeBSD license)
% http://opensource.org/licenses/BSD-2-Clause
function all_tests

    testdir = fileparts(mfilename('fullpath'));
    srcdir = fullfile(fileparts(testdir), 'src');

    % switch off stub warnings
    oldwarnstate = warning('off', 'MATLAB:dispatcher:nameConflict');
    
    % save path state and add srcdir and testdir to it
    oldpath = path;
    addpath(testdir, srcdir);
    
    % execute tests
    try
        test_common_basepath;
        test_dirset;
        test_fileset;
        test_fullfilec;
        test_relpath;
    catch err
        % throw exception as MATLAB would have
        disp(getReport(err));
    end
    
    % restore old path
    path(oldpath);

    % restore warn state
    warning(oldwarnstate);
