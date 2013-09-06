pathtools
=========

MATLAB helper functions for path handling.

Set of MATLAB functions that help querying file and directory paths, and
process sets of paths. dirset and fileset are inspired by Apache Ant's
equivalents, but with less features. All functions run on MATLAB R2007b and
probably newer.

The code comes unoptimized, but is written with functional paradigms in mind.
Even though MATLAB and FP don't go well together, the code favors high-level
functions, avoids state and tries to limit side effects to those required.


Existing functions
------------------

- common_basepath Calculate base path common to several given paths.
- dirset          Return list of directories, recursively.
- fileset         Return list of files that match a pattern, recursing directories.
- fullfilec       Concatenate partial paths safely, on cell arrays.
- relpath         Calculate relative paths between given paths.


Mutual dependencies
-------------------

These functions try not to depend on each other, in order to use them in and
distribute along other projects. Nevertheless, these dependencies exist:

- relpath --> common_basepath --> fullfilec
- fileset --> dirset


Possible future functionality
-----------------------------

- abspath     Calculate absolute from relative paths, including . and .. resolve, include resetting file separators platform-dependently
- path_join   ; on windows : on unix
- path_expand ; on windows : on unix
- isdirempty
- paths       Wrapper for MATLAB path function, but returning and receiving helpful cell arrays
- path_elements Tokenize given path into all constituents, using only fileparts.


Unit tests
----------

pathtools features the Light-weight Unit Test Evaluator for MATLAB (LUTE).
Lute treats each call to one of its expect_* functions as test case. This seems
a little awkward at first, but allows easy, boilerplate-free testing in MATLAB.

A Lute test suite is a single MATLAB function or script file called test_*.m.
Therein, make your initialization, call a succession of expect_*, and that's it.
Execute your suite by using single_suite(), or all suites in a directory by
using all_suites(). These functions will give you an overview as well as details
about any errors or failures. Standard output will not show on the MATLAB
console, but will be collected for later display.

Lute happily omits these features:
  - test case names
  - nasty test source parsing in order to get a handle on subfunctions
  - jUnit XML generation


TODO
----

- Function documentation
- make expect_error testcase-collector aware
- handle testsuite errors outside exepct_* calls cleverly
