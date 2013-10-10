% Stub for MATLAB's path function.

% Copyright (c) 2013, Alexander Roehnsch
% Released under the terms of the BSD 2-Clause License (FreeBSD license)
% http://opensource.org/licenses/BSD-2-Clause
function pold = path(pin)

    % init stubbed path state
    persistent pathstate;

    % if first call, actually take path from MATLAB
    if isempty(pathstate)
        pathstate = builtin('matlabpath');
    end

    % output old path state first
    pold = pathstate;

    % set path state if input arg given
    if nargin >= 1
        pathstate = pin;
    end
