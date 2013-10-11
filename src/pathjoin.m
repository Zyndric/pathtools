%PATHJOIN Join several paths into one pathsep separated string.
%   S = PATHJOIN(C) concatenates all path strings of cell array C into one
%   multi-path string S. Path strings are separated by the pathsep character.
%
%   Empty strings items in C will be regularly joined. E.g.:
%
%   >> isequal(pathjoin({'', ''}), pathsep)
%   >> isequal(pathjoin({'foo', '', 'bar'}), 'foo;;bar')    % on windows
%
%   See also pathsplit, pathsep.

% Copyright (c) 2013, Alexander Roehnsch
% Released under the terms of the BSD 2-Clause License (FreeBSD license)
% http://opensource.org/licenses/BSD-2-Clause
function pathstring = pathjoin(pathcell)
    
    if nargin == 0 || isempty(pathcell)
        pathstring = '';
    else
        % force single strings into cell array
        if ischar(pathcell), pathcell = {pathcell}; end
        % join cell items
        pathstring = [sprintf(['%s' pathsep], pathcell{1:end-1}), pathcell{end}];
    end
