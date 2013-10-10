%PATHSPLIT Split pathsep separated string into several paths.
%   C = PATHSPLIT(S) splits the multi-path string P into a cell array of path
%   strings C. Path strings in P are separated by the pathsep character.
%   C will be in column vector form.
%
%   When splitting awkward cases like ';', ';;' or ';foo;' (; being pathsep),
%   textscan('%s', 'Delimiter', ';') rules apply. Particularly, and strangely,
%   these are all true:
%
%   >> isequal(pathsplit(';'), {''})
%   >> isequal(pathsplit(';;'), {'';''})
%   >> isequal(pathsplit(';foo;'), {'';'foo'})
%   >> isequal(pathsplit(''), {})
%
%   See also pathjoin, pathsep, textscan.

% Copyright (c) 2013, Alexander Roehnsch
% Released under the terms of the BSD 2-Clause License (FreeBSD license)
% http://opensource.org/licenses/BSD-2-Clause
function pathcell = pathsplit(pathstring)
    
    % textscan fails on empty strings
    if nargin == 0
        pathcell = {};
    elseif isempty(pathstring)
        pathcell = {''};
    else
        % textscan returns a cell array of possible results, because pathstring
        % could be a cell; take first item only, since we provide a single string
        firstitem = @(c) c{1};
        pathcell = firstitem(textscan(pathstring, '%s', 'Delimiter', pathsep));
    end
