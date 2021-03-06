%FILESET Find files that match a pattern, recursing directories.
%   FP = FILESET(name_filter, basedir) returns a cell array of path
%   strings that match actual files in the file system. name_filter is a
%   file pattern string, i.e. '*.mat'. basedir is the directory to search in.
%
%   name_filter should only contain file name patterns, not directories like in
%   'src/*.m'. While this should work, it is hard to predict its behaviour.
%   Basically, you are looking for *.m files in all subdirs named 'src',
%   regardless of their nesting depth. Use with caution.
%
%   name_filter must always contain file name patterns or be empty. Use '', '*',
%   or '*.*' if you are looking for all files. Use basedir if you want to look
%   in a specific directory.
%
%   FP = FILESET(name_filter) will do the same, but in the current working
%   directory.
%
%   FP = FILESET() will find all files in the current working directory.
%
%   See also dirset, dir.

% Copyright (c) 2013, Alexander Roehnsch
% Released under the terms of the BSD 2-Clause License (FreeBSD license)
% http://opensource.org/licenses/BSD-2-Clause
function filepaths = fileset(name_filter, basedir)

    if nargin < 1, name_filter = ''; end
    if nargin < 2, basedir = pwd; end
    
    % get all subdirectories as cell array
    dirs = dirset(basedir);
    
    % get all files by filter from these directories
    find_files_plain_filtered = @(dir) find_files_plain(dir, name_filter);
    filepaths_cell = cellfun(find_files_plain_filtered, dirs, 'UniformOutput', false);
    
    % merge these result cells into one single cell array
    filepaths = vertcat(filepaths_cell{:});
    
    % Sometimes, find_files_plain filters empty content into a 0x1 array,
    % sometimes into a 0x0 array. That's not a problem when any filepaths_cell
    % item actually contains items. But when all are empty, vertcat mixes 0x0
    % and 0x1 arrays into an empty 0x1. We expect a clean 0x0 empty cell.
    % Normalize.
    if any(size(filepaths) == 0)
        filepaths = {};
    end
    

% Find files by name_filter in a specific directory. Plain, non-recursive.
function paths = find_files_plain(directory, name_filter)

    % get items
    items = dir(fullfile(directory, name_filter));
    file_items = items(~[items.isdir]);
    
    % name_filter might contain directories, which need be prepended to the
    % names of the found files
    filter_rel_dir = '';
    if ~isempty(name_filter)
        filter_rel_dir = fileparts(name_filter);
    end

    % prepend by directory name
    paths = arrayfun(@(item) fullfile(directory, filter_rel_dir, item.name), file_items, 'UniformOutput', false);
