%MLPATHS Get/set MATLAB search path, using cell arrays.
%   P = MLPATHS returns a cell array P containing all path items of MATLAB's
%   search path. MLPATHS(P) changes the search path to P, with P being a cell
%   array of path strings, or a single string.
%   MLPATHS(PATH) refreshes MATLAB's view of the directories on the path.
%
%   See also path, pathsplit, pathjoin.

% Copyright (c) 2013, Alexander Roehnsch
% Released under the terms of the BSD 2-Clause License (FreeBSD license)
% http://opensource.org/licenses/BSD-2-Clause
function outpaths = mlpaths(inpaths)
    
    % call MATLAB's built-in path
    if nargin == 0
        % if called without input argument, we should call path the same way,
        % lest MATLAB refreshes its path, which the user wouldn't expect
        outpathstr = path;
    else
        outpathstr = path(pathjoin(inpaths));
    end
    
    % split paths for output
    outpaths = pathsplit(outpathstr);

