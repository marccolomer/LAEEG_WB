%% Main analysis connectivity

clear all;
clc;

num_trials = 5; % To analyze trial by trial (only do it with the first 5 trials)
addpath(genpath([pwd '/scripts']));
cond_lab = {'cane', 'grasp'};
lab_age = '12m';

data_location = [pwd '/LAEEG_' lab_age '/chanpair/'];
subnum_cane=dir([data_location '*CTS_MTH_chanpair*']);
subnum_grasp=dir([data_location '*GTS_MTH_chanpair*']);
sub_list_cane={subnum_cane.name};
sub_list_grasp={subnum_grasp.name};
index1 = find(cellfun('length',regexp(sub_list_cane,'connect_overtime')) == 1);
index2 = find(cellfun('length',regexp(sub_list_grasp,'connect_overtime')) == 1);
sub_list_cane = sub_list_cane(index1);
sub_list_grasp = sub_list_grasp(index2);
num_subj = length(sub_list_cane);

load(strcat(pwd,'/metadata/time.mat'));
load(strcat(pwd,'/metadata/frequency.mat'));
win_extrems = 500;
time_time = time(1)+win_extrems:10:time(end)-win_extrems; % for ICPC across time
freq_win = [6, 9];
pos_freq = frequency>=freq_win(1) & frequency<=freq_win(2);

% to count number subjects with 3 trials, 4 trials or more
sum_3trials = zeros(1,2); 
sum_4trials = zeros(1,2);
sum_5trials = zeros(1,2);

%% loop across subjects
it = 0;
for s = 1:2:num_subj*2
    it = it+1;
    
    list1 = eval(['sub_list_' cond_lab{1}]); % cane
    list2 = eval(['sub_list_' cond_lab{2}]); % grasp

    sub1 = list1{it}
    sub2 = list2{it}
    data_1 = load([data_location sub1]); % cane
    data_2 = load([data_location sub2]); % grasp
        
    % ISPC
    ispc_FC_all(it,:,1) = squeeze(mean(mean(mean(data_1.ispc_FC(pos_freq,:,:,:),4),3),1));
    ispc_FC_all(it,:,2) = squeeze(mean(mean(mean(data_2.ispc_FC(pos_freq,:,:,:),4),3),1));
    ispc_PC_all(it,:,1) = squeeze(mean(mean(mean(data_1.ispc_PC(pos_freq,:,:,:),4),3),1));
    ispc_PC_all(it,:,2) = squeeze(mean(mean(mean(data_2.ispc_PC(pos_freq,:,:,:),4),3),1));
    ispc_OC_all(it,:,1) = squeeze(mean(mean(mean(data_1.ispc_OC(pos_freq,:,:,:),4),3),1));
    ispc_OC_all(it,:,2) = squeeze(mean(mean(mean(data_2.ispc_OC(pos_freq,:,:,:),4),3),1));

    %% ISPC including separate trials (up to 5)
    %% Condition 1
    if(size(data_1.ispc_FC,3) < num_trials)
        if(size(data_1.ispc_FC,3) > 3) % 4 trials
            sum_4trials(1) = sum_4trials(1) + 1;
            ispc_FC_trial(it,:,1:4,1) = squeeze(mean(mean(data_1.ispc_FC(pos_freq,:,1:4,:),4),1));
            ispc_PC_trial(it,:,1:4,1) = squeeze(mean(mean(data_1.ispc_PC(pos_freq,:,1:4,:),4),1));
            ispc_OC_trial(it,:,1:4,1) = squeeze(mean(mean(data_1.ispc_OC(pos_freq,:,1:4,:),4),1));
            
            ispc_FC_trial(it,:,5,1) = NaN;
            ispc_PC_trial(it,:,5,1) = NaN;
            ispc_OC_trial(it,:,5,1) = NaN;
        else % 3 trials
            sum_3trials(1) = sum_3trials(1) + 1;
            ispc_FC_trial(it,:,1:3,1) = squeeze(mean(mean(data_1.ispc_FC(pos_freq,:,1:3,:),4),1));
            ispc_PC_trial(it,:,1:3,1) = squeeze(mean(mean(data_1.ispc_PC(pos_freq,:,1:3,:),4),1));
            ispc_OC_trial(it,:,1:3,1) = squeeze(mean(mean(data_1.ispc_OC(pos_freq,:,1:3,:),4),1));
            
            ispc_FC_trial(it,:,4:5,1) = NaN;
            ispc_PC_trial(it,:,4:5,1) = NaN;
            ispc_OC_trial(it,:,4:5,1) = NaN;
            
        end        
    else % 5 trials or more
        sum_5trials(1) = sum_5trials(1) + 1;        
        ispc_FC_trial(it,:,:,1) = squeeze(mean(mean(data_1.ispc_FC(pos_freq,:,1:num_trials,:),4),1));
        ispc_PC_trial(it,:,:,1) = squeeze(mean(mean(data_1.ispc_PC(pos_freq,:,1:num_trials,:),4),1));
        ispc_OC_trial(it,:,:,1) = squeeze(mean(mean(data_1.ispc_OC(pos_freq,:,1:num_trials,:),4),1));
    end
    
    %% Condition 2
    if(size(data_2.ispc_FC,3) < num_trials)
        if(size(data_2.ispc_FC,3) > 3) % 4 trials
            sum_4trials(2) = sum_4trials(2) + 1;
            ispc_FC_trial(it,:,1:4,2) = squeeze(mean(mean(data_2.ispc_FC(pos_freq,:,1:4,:),4),1));
            ispc_PC_trial(it,:,1:4,2) = squeeze(mean(mean(data_2.ispc_PC(pos_freq,:,1:4,:),4),1));
            ispc_OC_trial(it,:,1:4,2) = squeeze(mean(mean(data_2.ispc_OC(pos_freq,:,1:4,:),4),1));
            
            ispc_FC_trial(it,:,5,2) = NaN;
            ispc_PC_trial(it,:,5,2) = NaN;
            ispc_OC_trial(it,:,5,2) = NaN;
        else % 3 trials
            sum_3trials(2) = sum_3trials(2) + 1;
            ispc_FC_trial(it,:,1:3,2) = squeeze(mean(mean(data_2.ispc_FC(pos_freq,:,1:3,:),4),1));
            ispc_PC_trial(it,:,1:3,2) = squeeze(mean(mean(data_2.ispc_PC(pos_freq,:,1:3,:),4),1));
            ispc_OC_trial(it,:,1:3,2) = squeeze(mean(mean(data_2.ispc_OC(pos_freq,:,1:3,:),4),1));  
            
            ispc_FC_trial(it,:,4:5,2) = NaN;
            ispc_PC_trial(it,:,4:5,2) = NaN;
            ispc_OC_trial(it,:,4:5,2) = NaN;
            
        end        
    else % 5 trials or more
        sum_5trials(2) = sum_5trials(2) + 1;
        
        ispc_FC_trial(it,:,:,2) = squeeze(mean(mean(data_2.ispc_FC(pos_freq,:,1:num_trials,:),4),1));
        ispc_PC_trial(it,:,:,2) = squeeze(mean(mean(data_2.ispc_PC(pos_freq,:,1:num_trials,:),4),1));
        ispc_OC_trial(it,:,:,2) = squeeze(mean(mean(data_2.ispc_OC(pos_freq,:,1:num_trials,:),4),1));
    end    
    
    subjects_included{it} = list1{it};

end

save_data=[pwd, '/all_subj_', 'con_acrosstime_' lab_age '.mat'];    
save (save_data, 'ispc_FC_all', 'ispc_PC_all', 'ispc_OC_all', 'ispc_FC_trial', 'ispc_PC_trial', 'ispc_OC_trial',...
    'subjects_included', 'sum_4trials','sum_3trials', 'sum_5trials', '-v7.3');

% load(strcat(pwd,'/metadata/time.mat'));
% load(strcat(pwd,'/metadata/frequency.mat'));
load(strcat(pwd,'/metadata/channel104_location.mat'));

freqs = frequency;
num_subj = length(subjects_included);

%% Save data (average trials)
n_subj = size(ispc_FC_all,1);
n_time = size(ispc_FC_all,2);
n_cond = 2;
n_rows = n_cond*n_time;
n_columns = n_subj + 4; % Time, Age, Pair, Condition + subjects
data_FC_ispc = cell(n_rows,n_columns);
data_PC_ispc = cell(n_rows,n_columns);
data_OC_ispc = cell(n_rows,n_columns);

c_time = time_time';
[c_age{1:n_time,1}] = deal(lab_age);

[c_cond{1:n_time,1}] = deal(cond_lab{1});
[c_cond{1:n_time,2}] = deal(cond_lab{2});

[c_chpair{1:n_time,1}] = deal('FC');
[c_chpair{1:n_time,2}] = deal('PC');
[c_chpair{1:n_time,3}] = deal('OC');

vnames = {'Time','Condition','Age','ChannelPair',subjects_included{:}};

it = 1;
for c = 1:2  

%% IF WE WANT TO EXPORT THE DATA TO R AND PLOT IT THERE

  % Create cell matrix that we will use at the end to create a
  % table
  
  %%%% ISPC
  data_FC_ispc(it:it+n_time-1 , 1) = num2cell(c_time);
  data_FC_ispc(it:it+n_time-1 , 2) = c_cond(:,c); 
  data_FC_ispc(it:it+n_time-1 , 3) = c_age(:,1);
  data_FC_ispc(it:it+n_time-1 , 4) = c_chpair(:,1); % FC
  data_FC_ispc(it:it+n_time-1 , 5:5+n_subj-1) = num2cell(ispc_FC_all(:,:,c)');

  data_PC_ispc(it:it+n_time-1 , 1) = num2cell(c_time);
  data_PC_ispc(it:it+n_time-1 , 2) = c_cond(:,c); 
  data_PC_ispc(it:it+n_time-1 , 3) = c_age(:,1);
  data_PC_ispc(it:it+n_time-1 , 4) = c_chpair(:,2); % PC
  data_PC_ispc(it:it+n_time-1 , 5:5+n_subj-1) = num2cell(ispc_PC_all(:,:,c)');
  
  data_OC_ispc(it:it+n_time-1 , 1) = num2cell(c_time);
  data_OC_ispc(it:it+n_time-1 , 2) = c_cond(:,c); 
  data_OC_ispc(it:it+n_time-1 , 3) = c_age(:,1);
  data_OC_ispc(it:it+n_time-1 , 4) = c_chpair(:,3); % OC
  data_OC_ispc(it:it+n_time-1 , 5:5+n_subj-1) = num2cell(ispc_OC_all(:,:,c)');
  
  it = it+n_time;
                   
end

%% Save data (save data 5 first trials separately)
n_cond = 2;
n_trials = num_trials;
n_rows = n_cond*n_time*n_trials;
n_factors = 5;
n_columns = n_subj + n_factors; % Time, Condition, Age, ChanPair, #trial + subjects
data_FC_ispc_tr = cell(n_rows,n_columns);
data_PC_ispc_tr = cell(n_rows,n_columns);
data_OC_ispc_tr = cell(n_rows,n_columns);

c_time = time_time';

[c_trial{1:n_time,1}] = deal('Trial1');
[c_trial{1:n_time,2}] = deal('Trial2');
[c_trial{1:n_time,3}] = deal('Trial3');
[c_trial{1:n_time,4}] = deal('Trial4');
[c_trial{1:n_time,5}] = deal('Trial5');

vnames_tr = {'Time','Condition','Age','ChannelPair','TrialNum',subjects_included{:}};

it = 1;
for trial = 1:n_trials
    for c = 1:2  
    %% IF WE WANT TO EXPORT THE DATA TO R AND PLOT IT THERE

      % Create cell matrix that we will use at the end to create a table
      %%%% ISPC
      data_FC_ispc_tr(it:it+n_time-1 , 1) = num2cell(c_time);
      data_FC_ispc_tr(it:it+n_time-1 , 2) = c_cond(:,c); 
      data_FC_ispc_tr(it:it+n_time-1 , 3) = c_age(:,1);
      data_FC_ispc_tr(it:it+n_time-1 , 4) = c_chpair(:,1); % FC
      data_FC_ispc_tr(it:it+n_time-1 , 5) = c_trial(:,trial); % trial
      data_FC_ispc_tr(it:it+n_time-1 , n_factors+1:n_factors+n_subj) = num2cell(ispc_FC_trial(:,:,trial,c)');

      data_PC_ispc_tr(it:it+n_time-1 , 1) = num2cell(c_time);
      data_PC_ispc_tr(it:it+n_time-1 , 2) = c_cond(:,c); 
      data_PC_ispc_tr(it:it+n_time-1 , 3) = c_age(:,1);
      data_PC_ispc_tr(it:it+n_time-1 , 4) = c_chpair(:,2); % PC
      data_PC_ispc_tr(it:it+n_time-1 , 5) = c_trial(:,trial); % trial
      data_PC_ispc_tr(it:it+n_time-1 , n_factors+1:n_factors+n_subj) = num2cell(ispc_PC_trial(:,:,trial,c)');

      data_OC_ispc_tr(it:it+n_time-1 , 1) = num2cell(c_time);
      data_OC_ispc_tr(it:it+n_time-1 , 2) = c_cond(:,c); 
      data_OC_ispc_tr(it:it+n_time-1 , 3) = c_age(:,1);
      data_OC_ispc_tr(it:it+n_time-1 , 4) = c_chpair(:,3); % OC
      data_OC_ispc_tr(it:it+n_time-1 , 5) = c_trial(:,trial); % trial
      data_OC_ispc_tr(it:it+n_time-1 , n_factors+1:n_factors+n_subj) = num2cell(ispc_OC_trial(:,:,trial,c)');

      it = it+n_time;
    end                   
end


%% SAVE CSV FILES TO ANALYZE AND PLOT DATA WITH R
% Create output tables
T_FC_ispc = cell2table(data_FC_ispc, 'VariableNames',vnames);
writetable(T_FC_ispc, [pwd '/For R/T_FC_ispc_time_' lab_age '.csv']);
T_PC_ispc = cell2table(data_PC_ispc, 'VariableNames',vnames);
writetable(T_PC_ispc, [pwd '/For R/T_PC_ispc_time_' lab_age '.csv']);
T_OC_ispc = cell2table(data_OC_ispc, 'VariableNames',vnames);
writetable(T_OC_ispc, [pwd '/For R/T_OC_ispc_time_' lab_age '.csv']);

T_FC_ispc_tr = cell2table(data_FC_ispc_tr, 'VariableNames',vnames_tr);
writetable(T_FC_ispc_tr, [pwd '/For R/T_FC_ispc_time_tr_' lab_age '.csv']);
T_PC_ispc_tr = cell2table(data_PC_ispc_tr, 'VariableNames',vnames_tr);
writetable(T_PC_ispc_tr, [pwd '/For R/T_PC_ispc_time_tr_' lab_age '.csv']);
T_OC_ispc_tr = cell2table(data_OC_ispc_tr, 'VariableNames',vnames_tr);
writetable(T_OC_ispc_tr, [pwd '/For R/T_OC_ispc_time_tr_' lab_age '.csv']);