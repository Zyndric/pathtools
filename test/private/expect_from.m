% wrap function call to assert several output arguments

% Copyright (c) 2013, Alexander Roehnsch
% Released under the terms of the BSD 2-Clause License (FreeBSD license)
% http://opensource.org/licenses/BSD-2-Clause
function expect_from(varargin)

    % first argument is the function itself, rest are output arguments
    nargs = numel(varargin)-1;
    
    actual = cell(1,nargs);
    % TODO: wrap in try catch block
    [actual{:}] = varargin{1}();
    expected = varargin(2:end);
    
    equals = cellfun(@isequal, actual, expected);
    
    if ~all(equals)
        error('Expected %s did not match actual %s on positions %s.', string(expected), string(actual), string(double(equals)));
    end
    
    
function str = string(value)

    if iscell(value)
        item_strings = cellfun(@string, value, 'UniformOutput', false);
        str = ['{' strjoin(item_strings, ',') '}'];
    elseif isstruct(value)
    else
        str = mat2str(value);
    end
    
    
function result = strjoin(stringcell, separator)

    if isempty(stringcell), result = ''; return; end
    result = [sprintf(['%s' separator], stringcell{1:end-1}), stringcell{end}];
