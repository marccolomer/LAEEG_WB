
% FUNCTION TO SAVE DATA OF ALL SUBJECTS IN A UNIQUE MATRIX

clear all;  
%%

method = ''; %ISPC
%method = 'wPLI_'; % wPLI
age = '9m';

% If we want to calculate threshold as the median + 1SD: thres_formula = '';
thres_formula = '';
% If we want to calculate threshold as the average + 1SD: thres_formula = 'avg_';
%thres_formula = 'avg_';

addpath(genpath(strcat(pwd,'/scripts/')));
data_location_wb = strcat(pwd,'/LAEEG_', age, '/wb_output/');
save_location = strcat(pwd,'/LAEEG_', age, '/');

load(strcat(pwd,'/metadata/time.mat'));
load(strcat(pwd,'/metadata/frequency.mat'));
load(strcat(pwd,'/metadata/channel104_location.mat'));

condition_name = {'CTS_MTH', 'GTS_MTH'};  

%% Get position clusters
[ch_pos_FP, ch_pos_Fz, ch_pos_FR, ch_pos_FL, ch_pos_Cz, ch_pos_CR, ch_pos_CL, ...
    ch_pos_Pz, ch_pos_PR, ch_pos_PL, ch_pos_TR, ch_pos_TL, ch_pos_OR, ch_pos_OL, ch_pos_Oz] = define_cluster_channels_github(channel_location);

clusters_all = {ch_pos_FP, ch_pos_Fz, ch_pos_FR, ch_pos_FL, ch_pos_Cz, ch_pos_CR, ch_pos_CL, ...
    ch_pos_Pz, ch_pos_PR, ch_pos_PL, ch_pos_TR, ch_pos_TL, ch_pos_OR, ch_pos_OL, ch_pos_Oz};

n_cl = length(clusters_all);

for fr = 1 : 3 % Loop across the 3 frequencies of interest
    switch fr
        case 1
            freq_win = [4, 6]; % Theta
        case 2
            freq_win = [6, 9]; % Alpha
        case 3
            freq_win = [15, 19]; % Beta
    end

    freq_range = [num2str(freq_win(1)) '-' num2str(freq_win(2)) 'Hz'];

    % Get file name of all subjects for cane condition (just to calculate how many subjects we have)
    subnum_wb=dir([data_location_wb '*' 'CTS_MTH_wholebrain_time_' method freq_range, '.mat' '*']);
    
    sub_list_wb={subnum_wb.name}; 
    
    n_subjects = length(sub_list_wb);
    
    data_init = load([pwd '/LAEEG_9m/wb_output/LA_EEG_Pilot02_CTS_MTH_wholebrain_time_' method freq_range '.mat']);
    time_time = data_init.times2save;
    time_length = length(time_time);
    
    thres_cl_ispc = zeros(n_subjects, time_length, 2);
    thres_NOcl_ispc = zeros(n_subjects, time_length, 2);
    
    for co =1:length(condition_name) 
        % LOOP ACROSS ALL SUBJECTS AND CONDITIONS 
        subnum_wb=[]; sub_list_wb=[];
        
        % Get name of files again, but this time depending on the condition of the loop
        subnum_wb=dir([data_location_wb '*' [condition_name{co} '_wholebrain_time_' method freq_range, '.mat'] '*']);    
    
        sub_list_wb={subnum_wb.name}; 
    
        phaseconnectivity_ispc = zeros(n_subjects, time_length, length(channel_location), length(channel_location));
        
        connectivity_cluster_ispc = zeros(n_subjects, time_length, n_cl, n_cl);
        for s=1:n_subjects
            subject  = sub_list_wb{s}           
            %% ispc
            data_subj2 = load([data_location_wb, sub_list_wb{s}]);
            
            data_subj2.thres_ispc = data_subj2.thres_ispc_time;       
            
            phaseconnectivity_ispc(s,:,:,:) = data_subj2.ispc_connectivity_time(:,:,:);
            
           [thres_NOcl_ispc(s,:,co)] = connectivity_cluster_thres_github(squeeze(phaseconnectivity_ispc(s,:,:,:)), thres_formula);
            
           % Before calculating whole-brain connectivity value, 
           % average connectivity within clusters and then calculate the threshold
            for cl1 = 1:n_cl
                for cl2 = 1:n_cl      
    
                    chan_1 = clusters_all{cl1};
                    chan_2 = clusters_all{cl2};
    
                    if(cl1==cl2) % diagonal
                        %break;
                    else
                        connectivity_cluster_ispc(s,:,cl1,cl2) = squeeze(mean(mean(phaseconnectivity_ispc(s,:,chan_1,chan_2),4),3));
                    end
                end
            end 
            
            % Calculate threshold of whole brain connectivity
           [thres_cl_ispc(s,:,co)] = connectivity_cluster_thres_github(squeeze(connectivity_cluster_ispc(s,:,:,:)), thres_formula);
              
        end
        
        save_data1=[save_location, 'wholebrain_all_acrosstime_', method, age, '_', condition_name{co}, '_', freq_range, '.mat'];               
        save (save_data1, 'phaseconnectivity_ispc', 'connectivity_cluster_ispc', 'sub_list_wb', '-v7.3');
    end
    
    save_data2=[save_location, 'threshold_all_acrosstime_' method, thres_formula, age, '_', freq_range, '.mat'];    
    save (save_data2, 'thres_cl_ispc', 'thres_NOcl_ispc', '-v7.3');

end
