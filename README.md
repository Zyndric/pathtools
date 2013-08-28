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


TODO
----

- Function documentation
- Test cases
- light-weight test framework by expanding expect_from into state collecting test case executor
