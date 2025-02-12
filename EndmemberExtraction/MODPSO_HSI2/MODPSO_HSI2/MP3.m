

function Off = MP3(p1, N, P, j, G, iter, r)
    Off = zeros(1, N); % Initialize the offspring

    % Randomly select two individuals from the Pareto front (G)
    idx1 = randi(size(G, 1));
    idx2 = randi(size(G, 1));
    G1 = G(idx1, :);
    G2 = G(idx2, :);

    % Get endmembers' position sets for G1 and G2
    pos1 = getPositionSet(G1);
    pos2 = getPositionSet(G2);

    % Copy the parent individual (p1) to the offspring (osj)
    osj = p1;

    % Iterate over each position in the individual
    for posk = 1:N
        R = [pos1(posk) - r, pos1(posk) + r, pos2(posk) - r, pos2(posk) + r];

        % If the current position is not within the range R, mutate it
        if p1(posk) < min(R) || p1(posk) > max(R)
            posk_new = randi([min(R), max(R)]);
            osj(posk) = 0;
            osj(posk_new) = 1;
        end
    end

    Off = osj;

    % Optionally, you can perform additional operations or adjustments here
end

function pos = getPositionSet(individual)
    % This function retrieves the endmembers' position set from an individual
    % Modify this function according to your data structure and representation.
    pos = find(individual == 1); % Assuming '1' represents selected positions.
end
