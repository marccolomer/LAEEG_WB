function [phaseconnectivity, weighted_phaselagidx]=phase_connectivity(data, pos_f_min, pos_f_max)

% ACROSS TRIALS
% INPUT
% data = single trial fourier coefficients; channel x frequency x trial
% OUTPUT
% phaseconnectivity = adjacency matrix; frequency x channel x channel

%% initialize
phaseconnectivity = zeros(size(data, 2), size(data, 1), size(data, 1));
weighted_phaselagidx       = zeros(size(data, 2), size(data, 1), size(data, 1));

%% now compute all-to-all connectivity
for chani=1:size(data, 1)
    for chanj=chani:size(data, 1)

        if(chani==chanj) % Set value to zero for the diagonal (if we divide by 0, we get NaN)
            weighted_phaselagidx(:,chani,chanj) = 0;            
        else

            %% take cross-spectral density
            crossspecden = squeeze(data(chani,:,:) .* conj(data(chanj,:,:)));
            % take imaginary part of signal only
            crossspecden_imag = imag(crossspecden);
            it = 0;
            for freq=pos_f_min:pos_f_max
                it = it+1;
                %% phase angle difference (shortcut, as implemented in Cohen's book)
                phaseconnectivity(it,chani,chanj) = abs(mean(exp(1i*angle(crossspecden(freq,:)))));
                phaseconnectivity(it,chanj,chani) = abs(mean(exp(1i*angle(crossspecden(freq,:)))));

                weighted_phaselagidx(it,chani,chanj) = abs( mean( abs(crossspecden_imag(freq, :)).*sign(crossspecden_imag(freq, :))) )./mean(abs(crossspecden_imag(freq, :)));
                weighted_phaselagidx(it,chanj,chani) = abs( mean( abs(crossspecden_imag(freq, :)).*sign(crossspecden_imag(freq, :))) )./mean(abs(crossspecden_imag(freq, :)));
            end
        end
    end
end
    