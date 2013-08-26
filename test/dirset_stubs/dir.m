% Stub for MATLAB's dir. Provides two directories.
% Should also some day test stub behaviour on abc.txt named directories.

% Copyright (c) 2013, Alexander Roehnsch
% Released under the terms of the BSD 2-Clause License (FreeBSD license)
% http://opensource.org/licenses/BSD-2-Clause
function dstruct = dir(path)

    virtual_base = { ...
        '.',   '12-Aug-2013 22:00:00',  0, true,  now; ...
        'foo', '12-Aug-2013 22:00:00', 10, false, now; ...
        'bar', '12-Aug-2013 22:00:00',  0, true,  now; ...
        '..',  '12-Aug-2013 22:00:00',  0, true,  now; ...
        'nuf', '12-Aug-2013 22:00:00',  0, true,  now; ...
        '.git','12-Aug-2013 22:00:00',  0, true,  now; ...
        '.hgrc',    '12-Aug-2013 22:00:00',  99, false,  now; ...
        '.temp.txt','12-Aug-2013 22:00:00',  99, false,  now; ...
        'abc.txt'  ,'12-Aug-2013 22:00:00',  99, false,  now; ...
    };

    virtual_bar = { ...
        '.',   '12-Aug-2013 22:00:00',  0, true,  now; ...
        'moo', '12-Aug-2013 22:00:00',  0, true,  now; ...
        '.txt','12-Aug-2013 22:00:00', 99, false, now; ...
    };

    virtual_empty = { ...
        '.',   '12-Aug-2013 22:00:00',  0, true,  now; ...
        '..',  '12-Aug-2013 22:00:00',  0, true,  now; ...
    };

    if nargin == 0, path = 'foo'; end

    % Output bar's contents if path has some bar string dangling, else output
    % base's contents. Likewise for moo and nuf.
    % We have a problem here by stubbing for dirset as well as for fileset
    % tests. Sometimes, path is a directoy path, sometimes a file path. We want
    % to change behaviour for distinct directories, but sometimes the triggering
    % name is found in filepart's name output argument, sometimes in the path
    % output argument. Also, if the name is non-existing-bogus (a file,
    % presumably) we want to ignore being in directory moo, nuf or bar.
    % Also, if checking against the last or next-to-last path token, we want to
    % check with any extensions on, e.g. 'my.dir'.
    last_pathitem_equals = @(name) isequal(name, nth(2, @() fileparts_with_ext(path))) || isequal(name, nth(2, @() fileparts_with_ext(fileparts(path)))); 
    if last_pathitem_equals('non-existing-bogus')
        virtual_dir = {};
    elseif last_pathitem_equals('moo') || last_pathitem_equals('nuf')
        virtual_dir = virtual_empty;
    elseif last_pathitem_equals('bar')
        virtual_dir = virtual_bar;
        % only .txt items with filter
        if last_pathitem_equals('*.txt')
            virtual_dir(1:2,:) = [];
        end
    else
        virtual_dir = virtual_base;
        % only .txt items with filter
        if last_pathitem_equals('*.txt')
            virtual_dir(1:7,:) = [];
        end
    end

    % feed the array columnwise into dirstruct
    content_cols = num2cell(virtual_dir, 1);
    if isempty(content_cols)
        % if we actually yield empty virtual_dir/content_cols, we actually need
        % a 1x5 cell array of empty cells in order for the later struct() call
        % to output a correctly typed 0x0 struct array
        content_cols = repmat({{}}, 1, 5);
    end
    dstruct = dirstruct(content_cols{:});

    
function [pathstr, name] = fileparts_with_ext(path)

    [pathstr, name_without, ext] = fileparts(path);
    name = [name_without, ext];
    
    
% Return the nth output argument of function func. Will call func on exactly n
% output arguments. Be careful when func changes behaviour when being called on
% different numbers of output arguments. May also be used to access any number
% of the output arguments, e.g. with n==1:3, the first three.
function varargout = nth(n, func)

    [outargs{1:max(n)}] = func();
    varargout = outargs(n);


function dstruct = dirstruct(name, date, bytes, isdir, datenum)

    dstruct = struct(...
        'name', name, ...
        'date', date, ...
        'bytes', bytes, ...
        'isdir', isdir, ...
        'datenum', datenum ...
        );
