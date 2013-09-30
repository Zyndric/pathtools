function setup

    basedir = fileparts(mfilename('fullpath'));

    lute_dir = fullfile(basedir, 'lute');
    src_dir = fullfile(basedir, 'src');
    test_dir = fullfile(basedir, 'test');

    addpath(lute_dir, src_dir, test_dir);

