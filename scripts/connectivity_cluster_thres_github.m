function [thres_out] = connectivity_cluster_thres_github(data, thres_formula)
%% calculate threshold
for t=1:size(data,1)

    tempdata = squeeze(data(t,:,:));
    tempdata(tempdata == 1) = []; % clear 1's from the diagonal
    tempdata    = nonzeros(tempdata); % Remove 0 from data to calcualate threshold

    %% threshold is one std above median connectivity value
    if(strcmp(thres_formula, 'avg_'))
        thres_out(t)    = std(tempdata)+mean(tempdata);
    else
        thres_out(t)    = std(tempdata)+median(tempdata);        
    end
end