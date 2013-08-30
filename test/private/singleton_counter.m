function value = singleton_counter(name, cmd)

    if nargin < 1 || isempty(name), name = 'counter'; end
    if nargin < 2, cmd = ''; end

    % init persistent counters structure
    persistent counters;
    if isempty(counters)
        counters = struct(name, 0);
    end

    % create resetted counter if not existant
    if ~isfield(counters, name), counters.(name) = 0; end

    % regardless of the action taken, return previous counter value
    value = counters.(name);

    switch cmd
        case 'reset'
            % reset timer
            counters.(name) = 0;
        otherwise
            % count up
            counters.(name) = counters.(name) + 1;
    end
