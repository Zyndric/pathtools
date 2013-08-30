% Execute a single test suite.
% Give the suite name as first argument.

% Copyright (c) 2013, Alexander Roehnsch
% Released under the terms of the BSD 2-Clause License (FreeBSD license)
% http://opensource.org/licenses/BSD-2-Clause
function [testcases, failure] = single_suite(name)

    testdir = fileparts(mfilename('fullpath'));
    srcdir = fullfile(fileparts(testdir), 'src');

    % switch off stub warnings
    oldwarnstate = warning('off', 'MATLAB:dispatcher:nameConflict');
    
    % save path state and add srcdir and testdir to it
    oldpath = path;
    addpath(testdir, srcdir);

    % reset suite information
    singleton_counter('testcase', 'reset');
    failure = false;

    try
        % TODO: catch standard output and return some other way
        eval(name);
    catch err
        failure = true;
        disp(getReport(err));
    end

    testcases = singleton_counter('testcase', 'reset');

    outstring = sprintf('%24s:%3d tests run', name, testcases);
    if failure
        outstring = [outstring ' with FAILURE'];
    end
    disp(outstring);

    % restore old path
    path(oldpath);

    % restore warn state
    warning(oldwarnstate);
