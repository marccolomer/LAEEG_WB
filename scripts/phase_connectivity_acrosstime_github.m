function [output]=phase_connectivity_acrosstime_github(data)

% ACROSS-TIME
% INPUT
% data = single trial fourier coefficients; channels x time
% OUTPUT
% phaseconnectivity = adjacency matrix; channel x channel

%% initialize
phaseconnectivity = zeros(size(data, 1), size(data, 1));
weighted_phaselagidx = zeros(size(data, 1), size(data, 1));

%% now compute all-to-all connectivity
for chani=1:size(data, 1)
    for chanj=chani:size(data, 1)

        %% take cross-spectral density
        crossspecden = squeeze(data(chani,:) .* conj(data(chanj,:)));
        %% phase angle difference (shortcut, as implemented in Cohen's book)
        phaseconnectivity(chani,chanj) = abs(mean(exp(1i*angle(crossspecden))));
        phaseconnectivity(chanj,chani) = abs(mean(exp(1i*angle(crossspecden))));

        %% Other ways of calculating ISPC
%         % Initialize channel and phase variable
%         chan1_data2 = squeeze(data(chani,:)); 
%         chan2_data2 = squeeze(data(chanj,:));
% 
%         %% Collect phase data
%         chan1_phase = angle(chan1_data2);
%         chan2_phase = angle(chan2_data2);
% 
%         %% Prepare phase angle data
%         chan_phase_angle(1,:) = chan1_phase;
%         chan_phase_angle(2,:) = chan2_phase;
% 
%         %% Calculate phase angle difference and clustering (ISPC)
%         phaseconnectivity(chani, chanj) = abs(mean(exp(1i*diff(chan_phase_angle,[],1)),2));
%         phaseconnectivity(chanj, chani) = abs(mean(exp(1i*diff(chan_phase_angle,[],1)),2));


        %% You can also calculate wPLI
        % take imaginary part of signal only
        crossspecden_imag = imag(crossspecden);
        weighted_phaselagidx(chani,chanj) = abs( mean( abs(crossspecden_imag).*sign(crossspecden_imag)) )./mean(abs(crossspecden_imag));
        weighted_phaselagidx(chanj,chani) = abs( mean( abs(crossspecden_imag).*sign(crossspecden_imag)) )./mean(abs(crossspecden_imag));

    end
end 

output = phaseconnectivity;
%output = weighted_phaselagidx;
