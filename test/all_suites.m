% Execute all test suites consecutively.

% Copyright (c) 2013, Alexander Roehnsch
% Released under the terms of the BSD 2-Clause License (FreeBSD license)
% http://opensource.org/licenses/BSD-2-Clause
function all_suites

    testdir = fileparts(mfilename('fullpath'));
    srcdir = fullfile(fileparts(testdir), 'src');

    % switch off stub warnings
    oldwarnstate = warning('off', 'MATLAB:dispatcher:nameConflict');
    
    % save path state and add srcdir and testdir to it
    oldpath = path;
    addpath(testdir, srcdir);

    % TODO: dynamically determine test suites
    suites = { ...
        'test_common_basepath', ...
        'test_dirset', ...
        'test_fileset', ...
        'test_fullfilec', ...
        'test_relpath', ...
        };

    % execute test suites
    [testcases_in_suites, failures] = cellfun(@single_suite, suites);
    
    % output summary
    all_testcases = sum(testcases_in_suites);
    disp(['Executed ' ...
        num2str(all_testcases) ' test cases in ' ...
        numel(testcases_in_suites) ' test suites. ' ...
        'Failed test suites: ' sum(numerical(failures))]);

    % restore old path
    path(oldpath);

    % restore warn state
    warning(oldwarnstate);
