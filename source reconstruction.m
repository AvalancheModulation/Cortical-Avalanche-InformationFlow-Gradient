
load('fieldtrip-20210912\template\sourcemodel\standard_sourcemodel3d4mm.mat');
%Load template grid and convert units from cm to mm
template_grid=sourcemodel;
template_grid.pos=template_grid.pos*10
template_grid.unit='mm';
state='rest';
listing=dir(['E:\Cam-Can MEG\derivatives_' state '\']);
for subject=1:length(listing)-2
subjectcode=listing(subject+2).name;

if exist(['E:\Cam-Can MRI\' subjectcode '\anat\' subjectcode '_T1w.nii.gz'])>0;



%Do timelock analysis to get covariance 
load(['E:\Cam-Can MEG\preprocessed\derivatives_' state '\' subjectcode '\mf2pt2_' subjectcode '_ses-' state '_task-' state '_meg_preprocessed.mat']);
trials=length(databandpassed.trial);

trialdivided=floor(trials/3);
cfg=[];
cfg.trials=1:trialdivided;
data3=ft_selectdata(cfg,databandpassed);
cfg=[];
cfg.channel='meg';
cfg.covariance='yes';
cfg.preproc.bpfilter='yes';
cfg.preproc.bpfreq=[1 100];
cfg.preproc.demean='yes';
cfg.preproc.baselinewindow=[-inf 0];
cfg.keeptrials='no';
cfg.vartrllength=2;
timelock=ft_timelockanalysis(cfg,data3);

cfg=[];
cfg.trials=trialdivided+1:trialdivided*2
data3=ft_selectdata(cfg,databandpassed);
cfg=[];
cfg.channel='meg';
cfg.covariance='yes';
cfg.preproc.bpfilter='yes';
cfg.preproc.bpfreq=[1 100];
cfg.preproc.demean='yes';
cfg.preproc.baselinewindow=[-inf 0];
cfg.keeptrials='no';
cfg.vartrllength=2;
timelock2=ft_timelockanalysis(cfg,data3);

cfg=[];
cfg.trials=trialdivided*2+1:trials;
data3=ft_selectdata(cfg,databandpassed);
cfg=[];
cfg.channel='meg';
cfg.covariance='yes';
cfg.preproc.bpfilter='yes';
cfg.preproc.bpfreq=[1 100];
cfg.preproc.demean='yes';
cfg.preproc.baselinewindow=[-inf 0];
cfg.keeptrials='no';
cfg.vartrllength=2;
timelock3=ft_timelockanalysis(cfg,data3);

for a=1:length(timelock.cov(:,1));
    for b=1:length(timelock.cov(:,1));
timelock.cov(a,b)=(timelock.cov(a,b)+timelock2.cov(a,b)+timelock3.cov(a,b))/3;
    end
end




%Do beamforming usign lcmv method
load(['E:\Cam-Can MRI\' subjectcode '\anat\' subjectcode '_templategrid.mat']);
load(['E:\Cam-Can MRI\' subjectcode '\anat\' subjectcode '_headmodel.mat']);
load('C:\Users\yinsh\Desktop\NeuronalAvalancheProject\AvalancheProcessingCode\ROICoordinatesIndicesTemplateSourceModelMars.mat');
cfg=[];
cfg.method='lcmv';
cfg.headmodel=headmodel;
cfg.sourcemodel.pos=grid.pos(ROICoordinatesIndex,:);
cfg.sourcemodel.inside=true(82,1);
cfg.unit=template_grid.unit;
cfg.lcmv.keepfilter='yes';
cfg.lcmv.fixedori='yes';
lcmv=ft_sourceanalysis(cfg,timelock);

%Reconstruct source channels


for i=1:length(databandpassed.trial);
    for region=1:82
    virtualchannel_raw.time{i}(region,:)=databandpassed.time{i};
    virtualchannel_raw.trial{i}(region,:)=lcmv.avg.filter{region}*databandpassed.trial{i}(:,:);
    end
end 

% 
for channel=1:82;
for trial=1:length(virtualchannel_raw.trial)
    combinedtimeseries_ref(500*trial-499:500*trial,channel)=virtualchannel_raw.trial{trial}(channel,:);
end
end

save(['E:\Cam-Can MEG\preprocessed\derivatives_' state '\' subjectcode '\mf2pt2_' subjectcode '_ses-' state '_task-' state '_meg_sourcereconstruction.mat'],'virtualchannel_raw');
else
end
clearvars -except template_grid state listing subject
end