function all_tests

    build_dir = fileparts(mfilename('fullpath'));
    basedir = fileparts(build_dir);

    % define lute, source and test dirs
    lute_dir = fullfile(basedir, 'builddeps', 'lute');
    src_dir = fullfile(basedir, 'src');
    test_dir = fullfile(basedir, 'test');

    % save path state and dirs
    oldpath = path;
    addpath(lute_dir, src_dir);

    % execute unit tests
    all_suites(test_dir);

    % restore path
    path(oldpath);
