function [phaseconnectivity]=phase_connectivity_acrosstime_github(data)

% ACROSS-TIME
% INPUT
% data = single trial fourier coefficients; channel x time
% OUTPUT
% phaseconnectivity = adjacency matrix; channel x channel

%% initialize
phaseconnectivity = zeros(size(data, 1), size(data, 1));

%% now compute all-to-all connectivity
for chani=1:size(data, 1)
    for chanj=chani:size(data, 1)

        %% take cross-spectral density
        crossspecden = squeeze(data(chani,:) .* conj(data(chanj,:)));
        %% phase angle difference (shortcut, as implemented in Cohen's book)
        phaseconnectivity(chani,chanj) = abs(mean(exp(1i*angle(crossspecden))));
        phaseconnectivity(chanj,chani) = abs(mean(exp(1i*angle(crossspecden))));
    end
end  