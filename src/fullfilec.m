%FULLFILEC Concatenate partial paths safely, on cell arrays.
%   P = FULLFILEC(A1,A2,...) concatenates partials paths A1, A2, ... somewhat
%   safely and returns the concatenated path P. A1, A2, ... may
%   be scalar strings or cell arrays of strings. All cell arrays with length
%   greater than one must be of the same size. strcmp expansion rules apply.
%   P will be a cell array of strings.
%
%   "Safely" means system-independently and tolerant of dangling or missing
%   path separators. Just like fullfile. In fact, after handling the cell
%   expansion, fullfile will just be called. Be careful of any succession of
%   separators already in the inputs paths, as fullfile will not crop those.
%   "Safely" also means FULLFILEC won't hit you with error messages if you give
%   it empty cell arrays, empty strings, or no arguments at all.
%   
%   The name fullfile may be misleading. No actual file has to exist, nor will
%   any exist checks be performed. The resulting path(s) may well be as partial
%   as their input constituents, only safely concatenated.
%
%   See also fullfile, strcmp.

% Copyright (c) 2013, Alexander Roehnsch
% Released under the terms of the BSD 2-Clause License (FreeBSD license)
% http://opensource.org/licenses/BSD-2-Clause
function pathcell = fullfilec(varargin)

    % determine cell dimensions to work on
    issingleton = true;
    cellsize = [1 1];
    for i = 1:numel(varargin)
        if iscell(varargin{i}) && ~isempty(varargin{i}) && any(size(varargin{i}) > [1 1])
            issingleton = false;
            cellsize = size(varargin{i});
            % stop as long as we found one non-singular cell array
            % if others exist with different sizes, then cellfun will let us
            % know
            break;
        end
    end
    
    % normalize non-cell and singular cell arguments into full-size cell arrays,
    % in order for cellfun to work seamlessly
    for i=1:numel(varargin)
        % Replace empty cell/arrays with empty string. Works the same as far as
        % fullfile is concerned, but helps a lot with the cellfun preparation.
        if isempty(varargin{i})
            varargin{i} = '';
        end
        
        % guarantee cell array
        if ~iscell(varargin{i})
            varargin{i} = {varargin{i}};
        end

        if ~issingleton
            % inflate singleton arrays
            if isequal(size(varargin{i}), [1 1])
                varargin{i} = repmat(varargin{i}, cellsize);
            end
        end
    end

    % handle no arguments and single arguments: cases in which fullfile fails
    switch numel(varargin)
        case 0
            pathcell = {};
        case 1
            pathcell = varargin{1};
        otherwise
            pathcell = cellfun(@fullfile, varargin{:}, 'UniformOutput', false);
    end
