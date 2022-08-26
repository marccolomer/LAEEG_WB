function [thresh_out, connect_degree, connect_data, connect_binary] = connectivity_degree_thres_github(data, thresh)
% data=adjacency matrix; channel x channel
% thres = 1*num_samples_freq vector in which every pos is the threshold for the
% corresponding frequency

%% calculate threshold
tempdata=data;
tempdata(tempdata==1)=[]; % clear 1's from the diagonal
tempdata = nonzeros(tempdata);

%% output threshold: one std above median connectivity value
thresh_out = std(tempdata)+median(tempdata);

%% apply threshold
% This is in case we have calculated a threshold for all subjects and
% conditions and we want to calculate the connectivity degree
connect_data=data;
connect_data(logical(eye(size(connect_data)))) = 0;

if(isempty(thresh))
    connect_data(connect_data<thresh_out)=0; % If threshold is not defined yet
else
    connect_data(connect_data<thresh)=0; % if threshold is already defined (average across subjects and conditions)
end

%% calculate degree
connect_binary =logical(connect_data); % binarize: suprathreshold=1, subthreshold=0;
connect_degree= sum(logical(connect_data)); % degree = sum of suprathreshold connections
