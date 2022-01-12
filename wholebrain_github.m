%% Whole brain connectivity for 9 month olds
clear all;

%% Initialize variables
addpath(genpath(strcat(pwd,'/scripts/')));
addpath(genpath('/Volumes/woodwardlab/Toolboxes'));
freq_win = [6, 9];
age = 9; % IT CAN BE 9 OR 12 AND SHOULD BE CHANGED DEPENDING ON WHAT AGE YOU ARE ANALYZING

%Matlab reads in the vaule of the MATLABSUBJECT environment variable
sub = getenv('MATLABSUBJECT');

load(strcat(pwd,'/metadata/time.mat'));
load(strcat(pwd,'/metadata/frequency.mat'));
load(strcat(pwd,'/metadata/channel104_location.mat'));

% Loop through all subjects and save a new list with name subj + condition
pos_path = strfind(sub,'/');
sub2 = sub(pos_path(end)+1:end);
disp(sub2)
pos_ = strfind(sub2,'_');
pos_dot = strfind(sub2,'.');

if(age == 9)
    data_location = strcat(pwd,'/LAEEG_9m/avg_trial_complex_data2/');
    save_location = strcat(pwd,'/LAEEG_9m/wb_output/');
    sub_save = strcat(sub2(1:pos_(3)-1),sub2(pos_(5):pos_dot(1)-1));
else
    data_location = strcat(pwd,'/LAEEG_12m/avg_trial_complex_data2/');
    save_location = strcat(pwd,'/LAEEG_12m/wb_output/');
    sub_save = strcat(sub2(1:pos_(4)-1),sub2(pos_(6):pos_dot(1)-1));
end
    
subject  = sub2; % to read data
subject_label = sub_save; % to save data
        
load([data_location, subject]);
% tfcomplex_data dimensions: freq; time; trial; channel
  
chan_num =  length(channel_location);

pos_f_min = min(find(frequency >= freq_win(1)));
pos_f_max = max(find(frequency <= freq_win(2)));

time_fil_extrems = time(time>=-1500 & time <1500);

%% CONNECTIVITY OVER-TIME
win_extrems = 500;
times2save = time_fil_extrems(1)+win_extrems:10:time_fil_extrems(end)-win_extrems;
time2save_idx = dsearchn(time_fil_extrems',times2save'); % time in index positions

% wavelet analysis from 3 cycles to 5 (from 4Hz to 20Hz)
cycles_freq = linspace(1.5,2.5,length(frequency)); % number of cycles on either end of the center point (1.5 means a total of 3 cycles))
fs = 500;

phase_con_trials = zeros(pos_f_max-pos_f_min+1, chan_num, chan_num);
phase_avg_freq = zeros(length(times2save), chan_num, chan_num,size(data_fft.tfcomplex_data,3));
thres_ispc_time = zeros(length(times2save), pos_f_max-pos_f_min+1, size(data_fft.tfcomplex_data,3));

for trial = 1:size(data_fft.tfcomplex_data,3) % Loop across trials 
    for t = 1:length(times2save) % Loop across time  
        it_fr = 0;
        for freq=pos_f_min:pos_f_max % Position from 6Hz to 9Hz in the frequency vector
            it_fr = it_fr+1;
            time_window_idx = round((1000/frequency(freq))*cycles_freq(freq)/(1000/fs));
            time_pos = time2save_idx(t)-time_window_idx:time2save_idx(t)+time_window_idx;
            
            complex_2D = squeeze(data_fft.tfcomplex_data(freq,time_pos,trial,:)); % transform a 4D matrix in a 2D (no trial and no freq)
            complex_reshaped = permute(complex_2D,[2,1]); % change order dimensions to chan x time

            % Get connectivity matrix: freq x channels x channels
            % calculate connectivity value across all electrodes
            [phase_con_trials(it_fr,:,:)] = phase_connectivity_acrosstime_github(complex_reshaped);

            % thresh = thres_Freq(1,freq); IF THRESH IS ALREADY DEFINED! This is in case we want to calculate the connectivity degree    
            % If thresh is not defined:
            thresh = [];
            [thresh_out, connect_degree_out, connect_data_out, connect_binary_out] = ...
                connectivity_degree_thres_github(squeeze(phase_con_trials(it_fr,:,:)), thresh);

            thres_ispc_time(t,it_fr,trial) = thresh_out;
        end
        phase_avg_freq(t,:,:,trial) = squeeze(mean(phase_con_trials,1)); % mean across frequencies
    end
end
ispc_connectivity_time = squeeze(mean(phase_avg_freq,4)); % average across trials

%% save data
save_data2=[save_location, subject_label, '_wholebrain_time.mat'];
save (save_data2, 'ispc_connectivity_time', 'thres_ispc_time', 'times2save', '-v7.3');

exit
