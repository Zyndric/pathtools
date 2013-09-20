function all_tests

    basedir = fileparts(mfilename('fullpath'));

    % define lute, source and test dirs
    lute_dir = fullfile(basedir, 'lute');
    src_dir = fullfile(basedir, 'src');
    test_dir = fullfile(basedir, 'test');

    % save path state and dirs
    oldpath = path;
    addpath(lute_dir, src_dir);

    % execute unit tests
    all_suites(test_dir);

    % restore path
    path(oldpath);

