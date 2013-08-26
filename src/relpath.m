% Calculate relative paths between given paths.
% If base is a direct parent of a target, target will be truncated by base.
% Take care that from_dirs and to_dirs either are all absolute paths, or are
% all relative paths in regard to the very same base dir. If one path of a
% from_dir to_dir pair is absolute, but the other relative, no common path can
% be found and the resulting path will go up all of from_dir and then
% down all of to_dir.
% relpath does not recognize '.' and '..' markers in the input arguments
% themselves. relpath does not rely on actual existing files or directories,
% it just computes differences in path strings. Therefore, never will relpath
% assume pwd to be a base of any path.

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
    
    % invert base2from direction by replacing its path items with '..'
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
% is expanded by unfold from a seed. No actual intermediate list will be
% constructed, however. That depends on fun's internal implementation.
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
