function [ch_pos_FP, ch_pos_Fz, ch_pos_FR, ch_pos_FL, ch_pos_Cz, ch_pos_CR, ch_pos_CL, ...
    ch_pos_Pz, ch_pos_PR, ch_pos_PL, ch_pos_TR, ch_pos_TL, ch_pos_OR, ch_pos_OL, ch_pos_Oz] = define_cluster_channels_github(channel_location)
% CLUSTERS
% clear all
%load([pwd '/metadata/channel_location.mat']);

% Clusters: 10-10 Positions	GSN electrodes
%% FRONTAL
FP = {'E1', 'E8', 'E9', 'E14', 'E15', 'E21', 'E22', 'E25', 'E32'};
FL = {'E20','E23','E24', 'E26','E27', 'E28', 'E33', 'E34'};

Fz = {'E4', 'E5', 'E10','E11', 'E12','E16', 'E18','E19'};
FR = {'E2', 'E3', 'E116','E117', 'E118','E122', 'E123', 'E124'};

%% TEMPORAL
TL = {'E39', 'E40', 'E45', 'E46', 'E47', 'E50', 'E51', 'E57', 'E58'};
TR = {'E96', 'E97', 'E98', 'E100', 'E101', 'E102', 'E108', 'E109', 'E115'};

%% CENTRAL
CL = {'E29', 'E30', 'E35', 'E36', 'E37', 'E41', 'E42'};
CR = {'E87','E93', 'E103', 'E104', 'E105', 'E110', 'E111'};
Cz = {'E6', 'E7', 'E13', 'E31', 'E80', 'E106', 'E112'};

%% PARIETAL
PL = {'E52', 'E53', 'E59', 'E60', 'E65'};
PR = {'E85','E86', 'E90', 'E91', 'E92'};
Pz = {'E54', 'E55', 'E61', 'E62', 'E78', 'E79'};

%% OCCIPITAL
%OI = {'E66','E67','E69', 'E70', 'E71', 'E72', 'E74', 'E75', 'E76', 'E77', ...
%'E82', 'E83', 'E84', 'E89', 'E95'};

OL = {'E66', 'E69', 'E70', 'E71', 'E74'};
OR = {'E76', 'E82', 'E83', 'E84', 'E89'};
Oz = {'E67','E72','E75','E77'};

%% CHECK THAT THERE ARE NO REPEATED CHANNELS
% ch_all = {FP{:}, FL{:}, Fz{:}, FR{:}, TL{:}, TR{:}, CL{:}, CR{:}, Cz{:}, PL{:}, PR{:}, Pz{:}, OI{:}};
% 
% [c,i1,i2] = unique(ch_all, 'stable');
% pos = [];
% for i=1:length(i1)-1
%    if(i1(i+1)-i1(i)==1)
%    else
%       pos = [pos i+1]; 
%    end
% end

%% PREPARE DATA TO PLOT CHANNEL LOCATION
%% Frontal
ch_pos_FR = [];
ch_pos_FL = [];
ch_pos_Fz = [];
ch_pos_FP = [];
for ch_cluster = 1:length(FL)
 for ch_it = 1:104
    if(strcmp(channel_location(ch_it).labels,FL{ch_cluster}))
         ch_pos_FL = [ch_pos_FL, ch_it];
    end
 end
end
for ch_cluster = 1:length(FR)
 for ch_it = 1:104
    if(strcmp(channel_location(ch_it).labels,FR{ch_cluster}))
         ch_pos_FR = [ch_pos_FR, ch_it];
    end
 end
end
for ch_cluster = 1:length(Fz)
 for ch_it = 1:104
    if(strcmp(channel_location(ch_it).labels,Fz{ch_cluster}))
         ch_pos_Fz = [ch_pos_Fz, ch_it];
    end
 end
end

for ch_cluster = 1:length(FP)
 for ch_it = 1:104
    if(strcmp(channel_location(ch_it).labels,FP{ch_cluster}))
         ch_pos_FP = [ch_pos_FP, ch_it];
    end
 end
end


%% Central
ch_pos_CR = [];
ch_pos_CL = [];
ch_pos_Cz = [];
for ch_cluster = 1:length(CL)
 for ch_it = 1:104
    if(strcmp(channel_location(ch_it).labels,CL{ch_cluster}))
         ch_pos_CL = [ch_pos_CL, ch_it];
    end
 end
end
for ch_cluster = 1:length(CR)
 for ch_it = 1:104
    if(strcmp(channel_location(ch_it).labels,CR{ch_cluster}))
         ch_pos_CR = [ch_pos_CR, ch_it];
    end
 end
end
for ch_cluster = 1:length(Cz)
 for ch_it = 1:104
    if(strcmp(channel_location(ch_it).labels,Cz{ch_cluster}))
         ch_pos_Cz = [ch_pos_Cz, ch_it];
    end
 end
end


%% Parietal
ch_pos_PR = [];
ch_pos_PL = [];
ch_pos_Pz = [];
for ch_cluster = 1:length(PL)
 for ch_it = 1:104
    if(strcmp(channel_location(ch_it).labels,PL{ch_cluster}))
         ch_pos_PL = [ch_pos_PL, ch_it];
    end
 end
end
for ch_cluster = 1:length(PR)
 for ch_it = 1:104
    if(strcmp(channel_location(ch_it).labels,PR{ch_cluster}))
         ch_pos_PR = [ch_pos_PR, ch_it];
    end
 end
end
for ch_cluster = 1:length(Pz)
 for ch_it = 1:104
    if(strcmp(channel_location(ch_it).labels,Pz{ch_cluster}))
         ch_pos_Pz = [ch_pos_Pz, ch_it];
    end
 end
end

%% Temporal
ch_pos_TR = [];
ch_pos_TL = [];
for ch_cluster = 1:length(TL)
 for ch_it = 1:104
    if(strcmp(channel_location(ch_it).labels,TL{ch_cluster}))
         ch_pos_TL = [ch_pos_TL, ch_it];
    end
 end
end
for ch_cluster = 1:length(TR)
 for ch_it = 1:104
    if(strcmp(channel_location(ch_it).labels,TR{ch_cluster}))
         ch_pos_TR = [ch_pos_TR, ch_it];
    end
 end
end


%% OCCIPITAL
% ch_pos_Oz = [];
% for ch_cluster = 1:length(OI)
%  for ch_it = 1:104
%     if(strcmp(channel_location(ch_it).labels,OI{ch_cluster}))
%          ch_pos_Oz = [ch_pos_Oz, ch_it];
%     end
%  end
% end

ch_pos_OR = [];
ch_pos_OL = [];
ch_pos_Oz = [];
for ch_cluster = 1:length(OL)
 for ch_it = 1:104
    if(strcmp(channel_location(ch_it).labels,OL{ch_cluster}))
         ch_pos_OL = [ch_pos_OL, ch_it];
    end
 end
end
for ch_cluster = 1:length(OR)
 for ch_it = 1:104
    if(strcmp(channel_location(ch_it).labels,OR{ch_cluster}))
         ch_pos_OR = [ch_pos_OR, ch_it];
    end
 end
end
for ch_cluster = 1:length(Oz)
 for ch_it = 1:104
    if(strcmp(channel_location(ch_it).labels,Oz{ch_cluster}))
         ch_pos_Oz = [ch_pos_Oz, ch_it];
    end
 end
end

% %% PLOT CLUSTERS
% % Prepare coordinates to change size and color dots cluster from the topoplot
% % addpath(genpath([pwd '/Toolbox']));
% [y,x] = pol2cart(pi*[channel_location(:).theta]/180,[channel_location(:).radius]);
% 
% Rd = max([channel_location(:).radius]);
% plotrad = min(1.0,max(Rd)*1.02);
% plotrad = max(plotrad,0.5);
% 
% x =  x * 0.5 / plotrad;
% y =  y * 0.5 / plotrad;
% h = 2.1;
% 
% topoplot(ones(1,124),channel_location,'plotrad',.55,'electrodes','on');
% hold on;
% 
% size_mark = 7;
% %% FRONTAL
% plot3(x(ch_pos_FR),y(ch_pos_FR),h*ones(length(ch_pos_FR)),...
% 'o','Markersize',size_mark,'MarkerEdgeColor','none','MarkerFaceColor','r');
% plot3(x(ch_pos_FL),y(ch_pos_FL),h*ones(length(ch_pos_FL)),...
% 'o','Markersize',size_mark,'MarkerEdgeColor','none','MarkerFaceColor','r');
% plot3(x(ch_pos_Fz),y(ch_pos_Fz),h*ones(length(ch_pos_Fz)),...
% 'o','Markersize',size_mark,'MarkerEdgeColor','none','MarkerFaceColor','g');
% plot3(x(ch_pos_FP),y(ch_pos_FP),h*ones(length(ch_pos_FP)),...
% 'o','Markersize',size_mark,'MarkerEdgeColor','none','MarkerFaceColor','y');
% 
% %% CENTRAL
% plot3(x(ch_pos_CR),y(ch_pos_CR),h*ones(length(ch_pos_CR)),...
% 'o','Markersize',size_mark,'MarkerEdgeColor','none','MarkerFaceColor','b');
% plot3(x(ch_pos_CL),y(ch_pos_CL),h*ones(length(ch_pos_CL)),...
% 'o','Markersize',size_mark,'MarkerEdgeColor','none','MarkerFaceColor','b');
% plot3(x(ch_pos_Cz),y(ch_pos_Cz),h*ones(length(ch_pos_Cz)),...
% 'o','Markersize',size_mark,'MarkerEdgeColor','none','MarkerFaceColor','y');
% 
% %% PARIETAL
% plot3(x(ch_pos_PR),y(ch_pos_PR),h*ones(length(ch_pos_PR)),...
% 'o','Markersize',size_mark,'MarkerEdgeColor','none','MarkerFaceColor','c');
% plot3(x(ch_pos_PL),y(ch_pos_PL),h*ones(length(ch_pos_PL)),...
% 'o','Markersize',size_mark,'MarkerEdgeColor','none','MarkerFaceColor','c');
% plot3(x(ch_pos_Pz),y(ch_pos_Pz),h*ones(length(ch_pos_Pz)),...
% 'o','Markersize',size_mark,'MarkerEdgeColor','none','MarkerFaceColor','g');
% 
% %% PARIETAL
% plot3(x(ch_pos_TR),y(ch_pos_TR),h*ones(length(ch_pos_TR)),...
% 'o','Markersize',size_mark,'MarkerEdgeColor','none','MarkerFaceColor','m');
% plot3(x(ch_pos_TL),y(ch_pos_TL),h*ones(length(ch_pos_TL)),...
% 'o','Markersize',size_mark,'MarkerEdgeColor','none','MarkerFaceColor','m');
% 
% %% OCCIPITAL
% plot3(x(ch_pos_OR),y(ch_pos_OR),h*ones(length(ch_pos_OR)),...
% 'o','Markersize',size_mark,'MarkerEdgeColor','none','MarkerFaceColor','b');
% plot3(x(ch_pos_OL),y(ch_pos_OL),h*ones(length(ch_pos_OL)),...
% 'o','Markersize',size_mark,'MarkerEdgeColor','none','MarkerFaceColor','b');
% plot3(x(ch_pos_Oz),y(ch_pos_Oz),h*ones(length(ch_pos_Oz)),...
% 'o','Markersize',size_mark,'MarkerEdgeColor','none','MarkerFaceColor','y');
% 
% hold off;