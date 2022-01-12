%% Script edited by Marc (August 10 2020)

function [connectivity_trials, weighted_phaselagidx]=phase_connectivity_chanpair_Trials_Time(channel1_data, channel2_data, t, freq, type)

% INPUT
% data = single trial fourier coefficients; frequency x time x trial
% OUTPUT
% weighted_phaselagidx = connectivity over trials matrix; frequency x time


switch type
    case 1
        chan1_data = squeeze(channel1_data(:,t,:));
        chan2_data = squeeze(channel2_data(:,t,:));
        % Phase-lag index
        crossspecden = squeeze(chan1_data .* conj(chan2_data));
        % take imaginary part of signal only
        crossspecden_imag = imag(crossspecden);

        %% Initialize channel and phase variable
        chan1_data2 = squeeze(channel1_data(freq, t,:));
        chan2_data2 = squeeze(channel2_data(freq, t,:));

        %% Collect phase data
        chan1_phase = angle(chan1_data2);
        chan2_phase = angle(chan2_data2);

        %% Collect phase angle data
        chan_phase_angle(1,:) = chan1_phase;
        chan_phase_angle(2,:) = chan2_phase;

        %% Calculate phase angle difference

        % Intersite phase clustering (ISPC)
        connectivity_trials = abs(mean(exp(1i*diff(chan_phase_angle,[],1)),2));

        %% weighted phase-lag index (shortcut, as implemented in Cohen's book)
        weighted_phaselagidx = abs( mean( abs(crossspecden_imag(freq, :)).*sign(crossspecden_imag(freq, :))) )./mean(abs(crossspecden_imag(freq, :)));

    case 2        
        
        chan1_data = squeeze(channel1_data(:,:,t));
        chan2_data = squeeze(channel2_data(:,:,t));
        % Phase-lag index
        crossspecden = squeeze(chan1_data .* conj(chan2_data));
        % take imaginary part of signal only
        crossspecden_imag = imag(crossspecden);

        %% Initialize channel and phase variable
        chan1_data2 = squeeze(channel1_data(freq, :,t));
        chan2_data2 = squeeze(channel2_data(freq, :,t));

        %% Collect phase data
        chan1_phase = angle(chan1_data2);
        chan2_phase = angle(chan2_data2);

        %% Collect phase angle data
        chan_phase_angle(1,:) = chan1_phase;
        chan_phase_angle(2,:) = chan2_phase;

        %% Calculate phase angle difference

        % Intersite phase clustering (ISPC)
        connectivity_trials = abs(mean(exp(1i*diff(chan_phase_angle,[],1)),2));

        %% weighted phase-lag index (shortcut, as implemented in Cohen's book)
        weighted_phaselagidx = abs( mean( abs(crossspecden_imag(freq, :)).*sign(crossspecden_imag(freq, :))) )./mean(abs(crossspecden_imag(freq, :)));   

end