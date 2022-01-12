%% READ ME

% Scripts to perform functional connectivity analysis. The scripts were
% used in the paper: "Action experience in infancy predicts visual-motor 
% functional connectivity during action anticipation"

% IMPORTANT NOTE: These scripts use Acropolis, a server from the University 
% of Chicago. However, the scripts can be easily adapted to analyze the 
% data outside of Acropolis.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% To run jobs in parallel in ACROPOLIS - for Step 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Go to the folder in which you have a submitloop (.sh) file
% Open a terminal there and run the loop: ./nameloop.sh

% The loop will find all the files of a format you have specified (e.g. *.set)
% in a folder you have specified. For each file, it will run the .qsub file of interest
% (that is, several jobs will be sent to the cluster in parallel, one for each input file). 

% The .qsub file will save in the environment a variable called
% MATLABSUBJECT that will have the name of the analyzed file (with its
% path). Then .qsub will indicate to run a specific script in matlab. This
% script will read the name of the current file of analysis via sub = getenv('MATLABSUBJECT');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Things to change on the .sh and .qsub scripts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% .sh: path folder with input files, file format of interest & name .qsub script
% .qsub: # of processors and RAM memory to use + name matlab script to run

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% General structure for connectivity analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The process is organized in 4 steps. 
% Input data: preprocessed artifact-free EEG data transformed to time-frequency
% Analyzed data: channel pairs and whole brain

% ONLY step 1 in the case of whole brain is performed in ACROPOLIS

%%%%%%%%%%
%% STEP 1. Connectivity analysis
%%%%%%%%%%
    %% Channel Pair (connectivity between specific pairs): run main_chanpair_connectivity_github.m
        % It does not require going through the cluster. You run it directly through matlab
        % Save data at LAEEG_age/chanpair/
        % Calculates connectivity either over trials (type = 1) or over time (type = 2)
        % between the clusters of interest (O-C, F-C, P-C) using ISPC
            % Dimensions conn over time: frequency, time, trial, condition
                % IMPORTANT: time frequency has been transformated, so it's
                % not the same as the standard saved for conn over trial.
            % Dimensions conn over trial: frequency, time, condition
            
    
    %% Whole Brain connectivity: 
    % Here you run the jobs (wholebrain_github.m) in Acropolis (in parallel) through submitloop_wb
        % Save data at LAEEG_age/wb_output/
        % Calculates adjecency matrices (ISPC-time) between all electrode 
        % pairs + the threshold of whole brain connectivity (1 median + 1 SD).
        % For each subj, you obtain 2 files: 2 conditions
            % Outputs:
            % ispc_connectivity: adjacency matrix (time x chan x chan)
            % thres_... is the threshold value for each time point and
            % New time vector
            
%%%%%%%%%%
%% STEP 2. OPEN DATA OF ALL SUBJECTS & CONDITIONS AND SAVE IT TOGETHER
%%%%%%%%%%
    % No need to use the terminal (run directly in matlab)
    
    %% For whole brain connectivity:
        % wholebrain_allsubjects_clusters_github.m (saves the threshold of
        % connectivity calculated without clustering (NOcl) and also with
        % clustering (cl), in which case the connectivity is first averaged
        % across all the electrodes in the cluster and then the median + 1
        % SD is calculated based on data of the 15 resulting clusters.
        % You can also decide to calculate the average rather than the
        % median. To do that, define thres_formula as 'avg_' rather than ''
        
        % Ouput: LAEEG_age/wholebrain_all_acrosstime_age_condition
       
        % Outcome1: adjacency matrices for each participant and time point 
        % When clustering, dimensions are: subject, time, cluster, cluster
        % When not clustering: subject, time, channel, channel
        
        % Outcome2: threshold (data we will use to normalize the connectivity
        % of the channel pair and for whole brain analysis)
        % Dimensions: subject x time x condition 
        % (condition 1 = CANE (novel); condition 2 = GRASP (familiar))
        
        
    %% For channel pair connectivity: 
    % organizes connectivity between channel pairs of all subjects. Also, it 
    % creates a table that will be used to analyze data in R.
    
    % Main scripts:
        % main_analysis_chanpair_acrosstime_github.m
        
        % Ouputs: 
            % Connectivity matrix for each channel pair: subject x time x
            % condition (e.g. ispc_OC_all.mat)
            % Connectivity matrix for each channel pair with trial
            % information: subject x time x trial x condition (e.g. ispc_OC_trial.mat)
            % List of subjects included
            % Number of subjects who provided 3 trials, 4 trials and 5
            % trials (e.g. sum_4trials.mat)
            % It also creates a .csv for each channel pair with trial or
            % without trial information that will be used to analyze data in R
                          
%%%%%%%%%%
%% STEP 3. Save whole brain data (threshold) for analysis in R
%%%%%%%%%% 

% Script: Export wholebrain_ISPCtime_github.m
% Output: .csv file with the data of the 12mo and 9mo (threshold whole-brain)
        
%%%%%%%%%%
%% STEP 4. Open data in R and do plots and analysis
%%%%%%%%%% 
