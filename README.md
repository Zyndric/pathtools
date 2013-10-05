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

- abspath     Calculate absolute from relative paths, including . and .. resolve, include resetting file separators platform-dependently. Much like Simon's GetFullPath, really.
- isabspath
- path_join   ; on windows : on unix
- path_expand ; on windows : on unix
- isdirempty
- paths       Wrapper for MATLAB path function, but returning and receiving helpful cell arrays
- path_elements Tokenize given path into all constituents, using only fileparts.


Hacking
-------

For cloning pathtools use this shell command:

    >> git clone git@github.com:Zyndric/pathtools.git

pathtools uses the Light-weight Unit Test Evaluator for MATLAB (LUTE). You have
to pull it in as a git submodule like so:

    >> cd pathtools
    >> git submodule init
    >> git submodule update

Run all unit tests by executing all_tests.m in the base directory. Run one
single test suite by calling its name, e.g. '>> test_relpath' with lute/, src/
and test/ on the MATLAB path.

Lute treats each call to one of its expect_* functions as test case. This seems
a little awkward at first, but allows easy, boilerplate-free testing in MATLAB.

A Lute test suite is a single MATLAB function or script file called test_*.m.
Therein, make your initialization, call a succession of expect_*, and that's it.
Standard output will not show on the MATLAB console, but will be collected for
later display.

