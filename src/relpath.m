%RELPATH Calculate relative paths between given paths.
%   R = RELPATH(F,T) calculates the relative path R, that leads from path F
%   to path T, e.g. F='/home/foo', T='/home/bar', R='../bar'. F and T may be
%   single strings or cell arrays of strings. If both are cell arrays, they
%   must be of the same size or of length 1. R is a cell array of strings.
%
%   If a from-path (F) is a direct parent of a to-path T, the relative path R
%   will be T truncated by F.
%
%   Take care that from-paths and to-paths either are all absolute paths, or are
%   all relative paths in regard to the very same base dir. If one path of a
%   from-path to-path pair is absolute, but the other relative, no common path
%   will be found and the resulting path will go up all of from-path and then
%   down all of to-path.
%
%   RELPATH does not recognize '.' and '..' markers in the input arguments
%   themselves. RELPATH does not rely on actual existing files or directories,
%   it just computes differences in path strings. Therefore, never will it
%   assume pwd to be a base of any path.
%
%   See also common_basepath.

% Copyright (c) 2013, Alexander Roehnsch
% Released under the terms of the BSD 2-Clause License (FreeBSD license)
% http://opensource.org/licenses/BSD-2-Clause
function relpaths = relpath(from_dirs, to_dirs)
    
    if isempty(from_dirs), relpaths = to_dirs; return; end
    if isempty(to_dirs), to_dirs = ''; end

    % force cell wrap
    if ~iscell(from_dirs), from_dirs = {from_dirs}; end
    if ~iscell(to_dirs), to_dirs = {to_dirs}; end

    % should have ruled empty cells out by now
    assert(~isempty(from_dirs) && ~isempty(to_dirs));

    % remember default size for the output array
    size_guide = size(to_dirs);
    if issingleton(to_dirs)
        size_guide = size(from_dirs);
    end

    % linearize from_dirs and to_dirs
    to_dirs = reshape(to_dirs, numel(to_dirs), 1);
    from_dirs = reshape(from_dirs, numel(from_dirs), 1);

    % inflate them if singleton
    if issingleton(from_dirs)
        from_dirs = repmat(from_dirs, size(to_dirs));
    elseif issingleton(to_dirs)
        to_dirs = repmat(to_dirs, size(from_dirs));
    end
    % if from_dirs and to_dirs both are non-singleton, they must have the
    % same size, which will be checked by the cellfun call below
    
    % put respective from and to dirs side by side
    pairs = num2cell([from_dirs, to_dirs], 2);

    % chop off basepath between any from-to pairs
    [dummy, path_differences] = cellfun(@common_basepath, pairs, 'UniformOutput', false); %#ok<ASGLU> omit ~ for R2007b compatibility

    % path_differences contains 2 paths each item, the first the relative base
    % path, the second the relative target path, both relative to their common
    % base
    relpaths = cellfun(@calculate_updown_path, path_differences, 'UniformOutput', false);

    % reshape result
    relpaths = reshape(relpaths, size_guide);


function singleton = issingleton(array)

    singleton = numel(array) == 1;


function relpath = calculate_updown_path(diff_cell)

    base2from = diff_cell{1};
    base2target = diff_cell{2};
    
    % Invert base2from direction by replacing its path items with '..'.
    % Do this as safely as possible, i.e. by only using fileparts for
    % tokenizing and fullfile for concatenating.
    from2base = unfoldr_reduce(@path_parentizer, base2from);
    
    % append by target relative path
    relpath = fullfile(from2base, base2target);


% Transform last path item into parent directory marker '..'.
function [parentized_path, remaining_path, hasended] = path_parentizer(parentized_path, named_path)

    parent_marker = '..';

    [remaining_path, name, extension] = fileparts(named_path);

    if isempty([name extension])
        hasended = true;
        % parentized_path remains the same
    else
        hasended = false;
        parentized_path = fullfile(parent_marker, parentized_path);
    end


% Cheap, iterative Hylomorphism: combines an unfold with a fold/reduce.
% Because we can.
% Produces a single result, calculated by reduce from an intermediate list that
% is expanded by unfold from a seed. No actual intermediate list need be
% constructed, however. It depends on fun's internal implementation.
% fun must be a function of two arguments, the result of the unfold_fold so far,
% and the seed. fun must yield three output arguments, the new result, the new
% seed and a boolean true if this was the last computation step or false not.
function result = unfoldr_reduce(func, varargin)

    use_initval = false;

    if nargin == 0 || isempty(func), error('Provide a valid function as first argument, please.'); end
    if nargin == 1, seed = []; end
    if nargin == 2, seed = varargin{1}; end
    if nargin >= 3
        use_initval = true;
        initval = varargin{1};
        seed = varargin{2};
        if nargin > 3, warning('PATHTOOLS:IgnoredArguments', 'Only the first three arguments used, others ignored.'); end
    end

    if use_initval
        result = initval;
    else
        result = [];
    end

    hasended = false;
    while ~hasended
        [result, seed, hasended] = func(result, seed);
    end
