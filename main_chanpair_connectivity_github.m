% Calculate connectivity between areas or clusters of interest

clear all;
clc
addpath(genpath([pwd '/scripts']));

% Type: 1 is ISPC-trial, 2 is ISPC-time
type = 2; 

%% Define clusters of interest
F3 = {'E19', 'E20', 'E23', 'E24', 'E27', 'E28'};
F4 = {'E3', 'E4', 'E117', 'E118', 'E123', 'E124'};

C3 = {'E29', 'E30', 'E35', 'E36', 'E37', 'E41', 'E42'};
C4 = {'E87', 'E93', 'E103', 'E104', 'E105', 'E110', 'E111'};

P3 = {'E47', 'E51', 'E52', 'E53', 'E59', 'E60'};
P4 = {'E85', 'E86', 'E91', 'E92', 'E97', 'E98'};

O1 = {'E66', 'E69', 'E70', 'E71', 'E74'};
O2 = {'E76', 'E82', 'E83', 'E84', 'E89'};

% Initialize time/frequency variables and channel information

load(strcat(pwd,'/metadata/channel104_location.mat'));
load(strcat(pwd,'/metadata/frequency.mat'));
load(strcat(pwd,'/metadata/time.mat'));
win_extrems = 500;
times2save = time(1)+win_extrems:10:time(end)-win_extrems;
time2save_idx = dsearchn(time',times2save'); % time in index positions

% wavelet analysis from 3 cycles to 5
timewindow = linspace(1.5,2.5,length(frequency)); % number of cycles on either end of the center point (1.5 means a total of 3 cycles))
fs = 500;
%%
for age = 1:2
    
    switch age
        case 1
            age_lab = '9m';
            p_1 = 3; % position of the under score  in the file name
            p_2 = 5;
        case 2
            age_lab = '12m';
            p_1 = 4;
            p_2 = 6;
    end
    
    data_location = [pwd '/LAEEG_' age_lab '/avg_trial_complex_data2/'];
    save_location = [pwd '/LAEEG_' age_lab '/chanpair/'];

    subnum=dir([data_location '*.mat']);
    sub_list={subnum.name};
    for i =1:length(sub_list)
        % Loop through all subjects and save a new list with name subj + condition
        sub2 = sub_list{i};
        pos_ = strfind(sub2,'_');
        pos_dot = strfind(sub2,'.');
        condi = sub2(pos_(p_2):pos_dot(1)-1);
        sub_save{i} = strcat(sub2(1:pos_(p_1)-1), condi);
        condition_label{i} = condi;
        
    end
       
    % find indices of the channels
    for i=1:length(F3)
        F3_indx (i)= find(strcmp({channel_location.labels}, F3{i}));
        F4_indx (i)= find(strcmp({channel_location.labels}, F4{i}));
        P3_indx (i)= find(strcmp({channel_location.labels}, P3{i}));
        P4_indx (i)= find(strcmp({channel_location.labels}, P4{i})); 
        if(i<6)
            O1_indx(i)= find(strcmp({channel_location.labels}, O1{i}));
            O2_indx(i)= find(strcmp({channel_location.labels}, O2{i}));       
        end
    end
    for i=1:length(C3)
        C3_indx (i)= find(strcmp({channel_location.labels}, C3{i}));
        C4_indx (i)= find(strcmp({channel_location.labels}, C4{i}));    
    end


    for s = 1:length(sub_list)
        subject = sub_list{s};
        disp(sub_save{s});
        lab = condition_label{s};

        %% Load data
        load([data_location subject]);
        
        F3_data=squeeze(mean(data_fft.tfcomplex_data(:,:,:,F3_indx),4));
        F4_data=squeeze(mean(data_fft.tfcomplex_data(:,:,:,F4_indx),4));
        P3_data=squeeze(mean(data_fft.tfcomplex_data(:,:,:,P3_indx),4));
        P4_data=squeeze(mean(data_fft.tfcomplex_data(:,:,:,P4_indx),4));
        C3_data=squeeze(mean(data_fft.tfcomplex_data(:,:,:,C3_indx),4));
        C4_data=squeeze(mean(data_fft.tfcomplex_data(:,:,:,C4_indx),4));
        O1_data=squeeze(mean(data_fft.tfcomplex_data(:,:,:,O1_indx),4));
        O2_data=squeeze(mean(data_fft.tfcomplex_data(:,:,:,O2_indx),4));
        
        switch type
            case 2
                %% Connectivity over-time
                % Dimensions: Frequency, Time and Trials
                M_dim = zeros(size(F3_data, 1), length(times2save), size(F3_data,3));
                % Dimensions: Same as before, but with 2 extra for the two hemispheres
                M_dim2 = zeros(size(F3_data, 1), length(times2save), size(F3_data,3), 2);
                ispc_F3C3 = M_dim; ispc_F4C4 = M_dim;
                ispc_P3C3 = M_dim; ispc_P4C4 = M_dim;
                ispc_O1C3 = M_dim; ispc_O2C4 = M_dim; 
                ispc_F3O1 = M_dim; ispc_F4O2 = M_dim;
                ispc_P3O1 = M_dim; ispc_P4O2 = M_dim;

                ispc_FC = M_dim2; ispc_PC = M_dim2; ispc_OC = M_dim2;  
                ispc_FO = M_dim2; ispc_PO = M_dim2; 
                
                for t = 1:size(F3_data,3) % t IS TRIAL
                    for freq=1:size(F3_data, 1)
                        time_window_idx = round((1000/frequency(freq))*timewindow(freq)/(1000/fs));                        
        
                        for ti=1:length(times2save) % sliding windows to compute connectivity over-time
                            time_pos = time2save_idx(ti)-time_window_idx:time2save_idx(ti)+time_window_idx;
                            
                            %% Control Networks:
                            [ispc_F3C3(freq,ti,t)]=phase_connectivity_chanpair_Trials_Time_github(F3_data(:,time_pos,:), C3_data(:,time_pos,:), t, freq, type);
                            [ispc_F4C4(freq,ti,t)]=phase_connectivity_chanpair_Trials_Time_github(F4_data(:,time_pos,:), C4_data(:,time_pos,:), t, freq, type);
        
                            [ispc_P3C3(freq,ti,t)]=phase_connectivity_chanpair_Trials_Time_github(P3_data(:,time_pos,:), C3_data(:,time_pos,:), t, freq, type);
                            [ispc_P4C4(freq,ti,t)]=phase_connectivity_chanpair_Trials_Time_github(P4_data(:,time_pos,:), C4_data(:,time_pos,:), t, freq, type);                            
                            
                            [ispc_F3O1(freq,ti,t)]=phase_connectivity_chanpair_Trials_Time_github(F3_data(:,time_pos,:), O1_data(:,time_pos,:), t, freq, type);
                            [ispc_F4O2(freq,ti,t)]=phase_connectivity_chanpair_Trials_Time_github(F4_data(:,time_pos,:), O2_data(:,time_pos,:), t, freq, type);
        
                            [ispc_P3O1(freq,ti,t)]=phase_connectivity_chanpair_Trials_Time_github(P3_data(:,time_pos,:), O1_data(:,time_pos,:), t, freq, type);
                            [ispc_P4O2(freq,ti,t)]=phase_connectivity_chanpair_Trials_Time_github(P4_data(:,time_pos,:), O2_data(:,time_pos,:), t, freq, type);
                            
                            %% Visual-Motor Network
                            [ispc_O1C3(freq,ti,t)]=phase_connectivity_chanpair_Trials_Time_github(O1_data(:,time_pos,:), C3_data(:,time_pos,:), t, freq, type);
                            [ispc_O2C4(freq,ti,t)]=phase_connectivity_chanpair_Trials_Time_github(O2_data(:,time_pos,:), C4_data(:,time_pos,:), t, freq, type);
                        end
                    end
                end
                ispc_FC(:,:,:,1) =  ispc_F3C3; 
                ispc_FC(:,:,:,2) =  ispc_F4C4;
                ispc_PC(:,:,:,1) =  ispc_P3C3; 
                ispc_PC(:,:,:,2) =  ispc_P4C4;                
                ispc_FO(:,:,:,1) =  ispc_F3O1; 
                ispc_FO(:,:,:,2) =  ispc_F4O2;
                ispc_PO(:,:,:,1) =  ispc_P3O1; 
                ispc_PO(:,:,:,2) =  ispc_P4O2;
                ispc_OC(:,:,:,1) =  ispc_O1C3; 
                ispc_OC(:,:,:,2) =  ispc_O2C4;
               
                %% save data
                times=data_fft.time; freqs=data_fft.frequency;
                save_data=[save_location, 'connect_overtime_' sub_save{s} '_chanpair_' age_lab '.mat'];
                save (save_data, 'ispc_FC', 'ispc_PC', 'ispc_FO', 'ispc_PO', 'ispc_OC', '-v7.3');
        
            case 1
                %% Connectivity over-trials
                type = 1;
                % Dimensions: Frequency, Time
                M_dim = zeros(size(F3_data, 1), size(F3_data,2));
                % Dimensions: Frequency, Time, Hemisphere
                M_dim2 = zeros(size(F3_data, 1), size(F3_data,2), 2);
                ispc_F3C3 = M_dim; ispc_F4C4 = M_dim;
                ispc_P3C3 = M_dim; ispc_P4C4 = M_dim;
                ispc_O1C3 = M_dim; ispc_O2C4 = M_dim; 
                ispc_F3O1 = M_dim; ispc_F4O2 = M_dim;
                ispc_P3O1 = M_dim; ispc_P4O2 = M_dim;

                ispc_FC = M_dim2; ispc_PC = M_dim2; ispc_OC = M_dim2;  
                ispc_FO = M_dim2; ispc_PO = M_dim2;  

                for t = 1:size(F3_data,2) % HERE t IS TIME!
                    for freq=1:size(F3_data, 1)
                    [ispc_F3C3(freq,t)]=phase_connectivity_chanpair_Trials_Time_github(F3_data, C3_data, t, freq, type);
                    [ispc_F4C4(freq,t)]=phase_connectivity_chanpair_Trials_Time_github(F4_data, C4_data, t, freq, type);
        
                    [ispc_P3C3(freq,t)]=phase_connectivity_chanpair_Trials_Time_github(P3_data, C3_data, t, freq, type);
                    [ispc_P4C4(freq,t)]=phase_connectivity_chanpair_Trials_Time_github(P4_data, C4_data, t, freq, type); 

                    [ispc_F3O1(freq,t)]=phase_connectivity_chanpair_Trials_Time_github(F3_data, O1_data, t, freq, type);
                    [ispc_F4O2(freq,t)]=phase_connectivity_chanpair_Trials_Time_github(F4_data, O2_data, t, freq, type);
        
                    [ispc_P3O1(freq,t)]=phase_connectivity_chanpair_Trials_Time_github(P3_data, O1_data, t, freq, type);
                    [ispc_P4O2(freq,t)]=phase_connectivity_chanpair_Trials_Time_github(P4_data, O2_data, t, freq, type);

                    [ispc_O1C3(freq,t)]=phase_connectivity_chanpair_Trials_Time_github(O1_data, C3_data, t, freq, type);
                    [ispc_O2C4(freq,t)]=phase_connectivity_chanpair_Trials_Time_github(O2_data, C4_data, t, freq, type); 
                    end
                end
                ispc_FC(:,:,1) =  ispc_F3C3; 
                ispc_FC(:,:,2) =  ispc_F4C4;
                ispc_PC(:,:,1) =  ispc_P3C3; 
                ispc_PC(:,:,2) =  ispc_P4C4;                
                ispc_FO(:,:,1) =  ispc_F3O1; 
                ispc_FO(:,:,2) =  ispc_F4O2;
                ispc_PO(:,:,1) =  ispc_P3O1; 
                ispc_PO(:,:,2) =  ispc_P4O2;
                ispc_OC(:,:,1) =  ispc_O1C3; 
                ispc_OC(:,:,2) =  ispc_O2C4;
                
                save_data2=[save_location, 'connect_overtrial_' sub_save{s} '_chanpair_' age_lab '.mat'];
                save (save_data2, 'ispc_FC', 'ispc_PC', 'ispc_FO', 'ispc_PO', 'ispc_OC', '-v7.3');  
        end
    end
end