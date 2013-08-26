% Stub for MATLAB's exist.
% Must be saved as @char member method in order to properly override the
% built-in exist function.

% Copyright (c) 2013, Alexander Roehnsch
% Released under the terms of the BSD 2-Clause License (FreeBSD license)
% http://opensource.org/licenses/BSD-2-Clause
function result = exist(path, type)

    if isequal(path, 'invalid')
        result = 0;
    else
        result = 7;
        if nargin >= 2 && isequal(type, 'file')
            result = 2;
        end
    end
