function all_tests

    basedir = fileparts(mfilename('fullpath'));
    test_dir = fullfile(basedir, 'test');

    % save path state and setup environment
    oldpath = path;
    run(fullfile(basedir, 'setup.m'));

    % execute unit tests
    all_suites(test_dir);

    % restore path
    path(oldpath);

