% Calculate base path common to several given paths.

% Copyright (c) 2013, Alexander Roehnsch
% Released under the terms of the BSD 2-Clause License (FreeBSD license)
% http://opensource.org/licenses/BSD-2-Clause
function [basepath, relpaths] = common_basepath(paths)

    if nargin == 0, paths = {}; end

    % tokenize paths
    path_unfolder = @(path) unfoldr(@path_tokenizer, path);
    tokens = cellfun(path_unfolder, paths, 'UniformOutput', false);
    
    % patch up each path's token cell array to match the longest
    max_path_tokens = max(cellfun('length', tokens));
    for i=1:numel(tokens)
        [tokens{i}{end+1:max_path_tokens}] = deal('');        
    end
    
    % merge into path token matrix
    pathmatrix = vertcat(tokens{:});
    
    % search index of first difference
    i = 1;
    while i <= size(pathmatrix, 2)
        if isequal(pathmatrix{:, i})
            i = i+1;
        else
            break;
        end
    end
    idx_differences_start = i;
    idx_basepath_end = i-1;
    
    % cannot use reduce, because fullfile would have to accept zero arguments
    switch idx_basepath_end
        case 0
            basepath = '';
        case 1
            basepath = pathmatrix{1,1};
        otherwise
            basepath = fullfile(pathmatrix{1,1:idx_basepath_end});
    end
    
    % use fullfilec to join row-wise into relpaths
    token_columns = num2cell(pathmatrix(:,idx_differences_start:end), 1);
    switch numel(token_columns)
        case 0
            relpaths_raw = cell(size(paths));
        case 1
            relpaths_raw = [token_columns{:}];
        otherwise
            relpaths_raw = fullfilec(token_columns{:});
    end
    
    % bring back into paths' shape
    relpaths = reshape(relpaths_raw, size(paths));
    
    
function [path_element, remaining_path] = path_tokenizer(path)

    [remaining_path, name, extension] = fileparts(path);
    if isempty([name extension])
        path_element = {};
    else
        path_element = {[name extension]};
    end

    
function list = unfoldl(fun, seed)

    % fun be a function getting a seed and returning the next element of the
    % list as well as the remaining seed; fun must terminate on any seed
    % function [element, remaining_seed] = fun(seed)
    % element being a one-element cell array or an empty cell array if no new
    % values can be generated
    % produces a cell array in a loop, i.e. memory allocation may be slow
    
    list = {};
    while true
        [el, seed] = fun(seed);
        if isempty(el)
            break;
        end
        list(end+1) = el; %#ok<AGROW>
    end
    
    
function list = unfoldr(fun, seed)

    list = fliplr(unfoldl(fun, seed));
