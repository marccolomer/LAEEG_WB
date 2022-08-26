
clear all;
clc;

thres_formula = ''; % if median + 1SD
%thres_formula = 'avg_'; % if average
method = '';
%method = '_wPLI';

load(strcat(pwd,'/metadata/frequency.mat'));
load(strcat(pwd,'/metadata/time.mat'));
load(strcat(pwd,'/metadata/channel104_location.mat'));

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


    data_th9 = load([pwd, '/LAEEG_9m/threshold_all_acrosstime' method '_', thres_formula, '9m_', freq_range, '.mat']);
    data_th12 = load([pwd, '/LAEEG_12m/threshold_all_acrosstime' method '_', thres_formula, '12m_',  freq_range, '.mat']);
    
    %% Set parameters
    addpath(genpath('/mnt/acropolis/woodwardlab/colomer/Toolbox/'));
    savepath = strcat(pwd,'/plots/');
    condition_name = {'CTS_MTH', 'GTS_MTH'};  
    data_chanpair_9m = load([pwd, '/all_subj_con_acrosstime', method, '_9m_' freq_range '.mat']);
    data_chanpair_12m = load([pwd, '/all_subj_con_acrosstime', method, '_12m_' freq_range '.mat']);
    
    %% EXPORT THRESHOLD TO R
    win_extrems = 500;
    time_fil_extrem = time(time>=-1500 & time <1500);
    times2save = time_fil_extrem(1)+win_extrems:10:time_fil_extrem(end)-win_extrems;
    n_subj_9 = size(data_th9.thres_cl_ispc,1);
    n_subj_12 = size(data_th12.thres_cl_ispc,1);
    n_time = length(times2save);
    n_age = 2;
    n_cond = 2;
    n_rows = n_cond*n_time;
    n_columns = n_subj_9 + 3; % Time, Age, Condition + subjects
    data_ispc_9m = cell(n_rows,n_columns);
    
    n_columns = n_subj_12 + 3; % Time, Age, Condition + subjects
    data_ispc_12m = cell(n_rows,n_columns);
    
    [c_cond{1:n_time,1}] = deal('Cane');
    [c_cond{1:n_time,2}] = deal('Grasp');
    c_time = [times2save'; times2save'];
    
    % 9m
    [c_age_9m{1:n_time*2,1}] = deal('9m');
    thres_out_ispccl = [squeeze(data_th9.thres_cl_ispc(:,:,1))'; squeeze(data_th9.thres_cl_ispc(:,:,2))'];
    vnames_9m = {'Time','Condition','Age',data_chanpair_9m.subjects_included{:}};
    data_ispc_9m(:, 1) = num2cell(c_time);
    data_ispc_9m(:, 2) = [c_cond(:,1); c_cond(:,2)]; 
    data_ispc_9m(:, 3) = c_age_9m(:,1);
    data_ispc_9m(:, 4:4+n_subj_9-1) = num2cell(thres_out_ispccl);
    T_thres_cluster_9m = cell2table(data_ispc_9m, 'VariableNames',vnames_9m);
    writetable(T_thres_cluster_9m, [pwd '/For R/T_thres_acrosstime', method, '_cl_', thres_formula, '9m_ispc_' freq_range, '.csv']);
    
    % 12m
    [c_age_12m{1:n_time*2,1}] = deal('12m');
    thres_out_ispccl = [squeeze(data_th12.thres_cl_ispc(:,:,1))'; squeeze(data_th12.thres_cl_ispc(:,:,2))'];
    vnames_12m = {'Time','Condition','Age',data_chanpair_12m.subjects_included{:}};
    data_ispc_12m(:, 1) = num2cell(c_time);
    data_ispc_12m(:, 2) = [c_cond(:,1); c_cond(:,2)]; 
    data_ispc_12m(:, 3) = c_age_12m(:,1);
    data_ispc_12m(:, 4:4+n_subj_12-1) = num2cell(thres_out_ispccl);
    T_thres_cluster_12m = cell2table(data_ispc_12m, 'VariableNames',vnames_12m);
    writetable(T_thres_cluster_12m, [pwd '/For R/T_thres_acrosstime', method, '_cl_', thres_formula, '12m_ispc_' freq_range, '.csv']);
end
