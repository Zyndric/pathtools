% Execute all test suites consecutively.

% Copyright (c) 2013, Alexander Roehnsch
% Released under the terms of the BSD 2-Clause License (FreeBSD license)
% http://opensource.org/licenses/BSD-2-Clause
function all_suites

    testdir = fileparts(mfilename('fullpath'));

    % save path state and add testdir in order to find single_suite
    oldpath = path;
    addpath(testdir);
    
    % TODO: dynamically determine test suites
    suites = { ...
        'test_common_basepath', ...
        'test_dirset', ...
        'test_fileset', ...
        'test_fullfilec', ...
        'test_relpath', ...
        };

    % execute test suites
    [testcases_in_suites, failflags] = cellfun(@single_suite, suites);
    
    % output summary
    fprintf('Executed %d test cases in %d test suites.\n', ...
        sum(testcases_in_suites), ...
        numel(testcases_in_suites));
    failures = sum(double(failflags));
    if failures == 0
        disp('No test suites failed.')
    else
        fprintf('%d test suites failed.\n', failures);
    end

    % restore old path
    path(oldpath);
