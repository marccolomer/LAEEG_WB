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

% The process is organized in 4 steps (see below).
% Input data: preprocessed artifact-free EEG data transformed to time-frequency

% Analysis:
% 1. Whole-Brain: wholebrain_github.m (step 1) -- calculate adjacency matrices for each participant, 
% wholebrain_allsubjects_clusters_github.m (step 2) -- organize adjacency matrices of all participants together,
% export_wholebrain_ISPCtime_github.m (step 3) -- export whole-brain data on organized tables to be analyzed in R.
% Connectivity_analysis_LAEEG_FINAL_rev.Rmd (step 4) -- plot whole-brain data and do statistical analysis

% 2. Inter-site network (FO, FC, PO, PC, OC):
% main_analysis_chanpair_github.m (step 1) -- calculate connectivity between two areas of interest
% main_analysis_chanpair_acrosstime_github.m -- organize data of all participants together (step 2), 
% and export data (step 3) to be analyzed in R.
% Connectivity_analysis_LAEEG_FINAL_rev.Rmd (step 4) -- plot inter-site connectivity data (normalized by whole-brain) and do statistical analysis


%%%%%%%%%%
%% STEP 1. Connectivity analysis
%%%%%%%%%%
    %% Channel Pair (connectivity between specific pairs): run main_analysis_chanpair_github.m
        % Don't need to run it through the Terminal (in parallel). You can just run
        % the matlab code, which will analyze the subjects sequently.
        % Save data at LAEEG_age/chanpair/
        % Calculates connectivity either over trials (type = 1) or over time (type = 2)
        % between the clusters of interest (O-C, F-C, P-C, F-O, P-O) using ISPC
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

    % IMPORTANT: You need to specify manually the frequency range of
    % interest (theta, alpha, beta), and the age group to analyze (9m or 12m)
    % In order to have all the data, you will have to run the script 6
    % times: 3 for 9-month-olds (3 freqs) and 3 for 12-month-olds (3 freqs)
            
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
        % median. To do that, define thres_formula as 'avg_' rather than ''.
        % The analysis will be performed for theta, alpha and beta.
        
        % Ouput: LAEEG_age/wholebrain_all_acrosstime_age_condition
       
        % Outcome1: adjacency matrices for each participant and time point 
        % When clustering, dimensions are: subject, time, cluster, cluster
        % When not clustering: subject, time, channel, channel
        
        % Outcome2: threshold (data we will used to normalize the connectivity
        % of the channel pair and for whole brain analysis)
        % Dimensions: subject x time x condition 
        % (condition 1 = CANE (novel); condition 2 = GRASP (familiar))

        % IMPORTANT: Change the age of the participants depending on which
        % group you want to analyze. Perform analysis both for 9m and 12m
        
        
    %% For channel pair connectivity: 
        % organizes connectivity between channel pairs of all subjects. Also, it 
        % creates a table that will be used to analyze data in R. 
        % The analysis will be performed for theta, alpha and beta.
        
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

% Script: export_wholebrain_ISPCtime_github.m
% Output: .csv file with the data of the 12mo and 9mo (threshold whole-brain)
        
%%%%%%%%%%
%% STEP 4. Open data in R to do plots and statistical analysis
%%%%%%%%%% 

% Define the frequency band of interest and run the analysis.
% In some cases, you may need to change some parameters, such as in which 
% time window you want to perform the analysis (e.g. Use window from -1000 
% to -500 ms to test the relation between ISPC during anticipation and
% grasp latency.
% The code also includes some additional analysis not included in the
% manuscript.   
