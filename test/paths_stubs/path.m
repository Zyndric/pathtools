% Stub for MATLAB's path function. MATLAB's path function outputs the updated
% path, not the previous path.

% Copyright (c) 2013, Alexander Roehnsch
% Released under the terms of the BSD 2-Clause License (FreeBSD license)
% http://opensource.org/licenses/BSD-2-Clause
function pout = path(pin)

    % init stubbed path state
    persistent pathstate;

    % if first call, actually take path from MATLAB
    % but if pathstate is empty string, we actually want that
    if isempty(pathstate) && ~ischar(pathstate)
        pathstate = builtin('matlabpath');
    end

    % set path state if input arg given
    if nargin >= 1
        pathstate = pin;
    end

    % output possibly updated or previous path state
    pout = pathstate;

