   % Topoplot connectivity degree (what areas are more connected to the
    % rest of the brain? Note that we don't know where these areas are
    % connected.
    
clear all;
clc;

thres_formula = ''; % if median + 1SD
%thres_formula = 'avg_'; % if average

load(strcat(pwd,'/metadata/frequency.mat'));
load(strcat(pwd,'/metadata/time.mat'));
load(strcat(pwd,'/metadata/channel104_location.mat'));

data_th9 = load([pwd, '/LAEEG_9m/threshold_all_acrosstime_', thres_formula, '9m.mat']);
data_th12 = load([pwd, '/LAEEG_12m/threshold_all_acrosstime_', thres_formula, '12m.mat']);

%% Set parameters
addpath(genpath('/mnt/acropolis/woodwardlab/colomer/Toolbox/'));
savepath = strcat(pwd,'/plots/');
condition_name = {'CTS_MTH', 'GTS_MTH'};  
data_chanpair_9m = load([pwd, '/all_subj_con_acrosstime_9m.mat']);
data_chanpair_12m = load([pwd, '/all_subj_con_acrosstime_12m.mat']);

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
writetable(T_thres_cluster_9m, [pwd '/For R/T_thres_acrosstime_cl_', thres_formula, '9m_ispc.csv']);

% 12m
[c_age_12m{1:n_time*2,1}] = deal('12m');
thres_out_ispccl = [squeeze(data_th12.thres_cl_ispc(:,:,1))'; squeeze(data_th12.thres_cl_ispc(:,:,2))'];
vnames_12m = {'Time','Condition','Age',data_chanpair_12m.subjects_included{:}};
data_ispc_12m(:, 1) = num2cell(c_time);
data_ispc_12m(:, 2) = [c_cond(:,1); c_cond(:,2)]; 
data_ispc_12m(:, 3) = c_age_12m(:,1);
data_ispc_12m(:, 4:4+n_subj_12-1) = num2cell(thres_out_ispccl);
T_thres_cluster_12m = cell2table(data_ispc_12m, 'VariableNames',vnames_12m);
writetable(T_thres_cluster_12m, [pwd '/For R/T_thres_acrosstime_cl_', thres_formula, '12m_ispc.csv']);
