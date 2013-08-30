% Execute a single test suite.
% Give the suite name as first argument.

% Copyright (c) 2013, Alexander Roehnsch
% Released under the terms of the BSD 2-Clause License (FreeBSD license)
% http://opensource.org/licenses/BSD-2-Clause
function [testcases, failure] = single_suite(name)

    singleton_counter('testcase', 'reset');
    failure = false;

    try
        name();
    catch err
        failure = true;
        disp(getReport(err));
    end

    testcases = singleton_counter('testcase', 'reset');

    outstring = sprintf('%20s:%3d tests run', name, testcases);
    if failure
        outstring = [outstring ' with FAILURE'];
    end
    disp(outstring);
