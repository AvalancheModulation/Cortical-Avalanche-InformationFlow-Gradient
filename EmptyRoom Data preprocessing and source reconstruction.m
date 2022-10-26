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
subjectcode2=subjectcode(5:12);
cfg            = [];
cfg.dataset    = ['E:\Cam-Can MEG\empty room\' subjectcode '\emptyroom\emptyroom_' subjectcode2 '.fif']; % note that you may need to add the full path to the .ds directory
cfg.continuous = 'yes';
cfg.channel    = 'MEG';
cfg.demean='yes';
data           = ft_preprocessing(cfg);

cfg=[];
cfg.resamplefs=250;
data2=ft_resampledata(cfg,data);

cfg         = [];
cfg.length  = 2;
cfg.overlap = 0;
data4        = ft_redefinetrial(cfg, data2);


cfg=[];
cfg.bpfilter='yes';
cfg.bpfreq=[1 124];
cfg.bsfilter='yes';
cfg.bsfreq(1,1:2)=[48 51];
cfg.bsfreq(2,1:2)=[99 101];
cfg.bsfreq(3,1:2)=[87 89];
cfg.bsfreq(4,1:2)=[25 26];
data4=ft_preprocessing(cfg,data4);


trials=length(data4.trial);



cfg=[];
cfg.channel='meg';
cfg.covariance='yes';
cfg.preproc.bpfilter='yes';
cfg.preproc.bpfreq=[1 100];
cfg.preproc.demean='yes';
cfg.preproc.baselinewindow=[-inf 0];
cfg.keeptrials='no';
cfg.vartrllength=2;
timelock=ft_timelockanalysis(cfg,data4);



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


for i=1:length(data4.trial);
    for region=1:82
    virtualchannel_raw.time{i}(region,:)=data4.time{i};
    virtualchannel_raw.trial{i}(region,:)=lcmv.avg.filter{region}*data4.trial{i}(:,:);
    end
end 
mkdir(['E:\Cam-Can MEG\preprocessed\emptyroom\' subjectcode '\']);
save(['E:\Cam-Can MEG\preprocessed\emptyroom\' subjectcode '\mf2pt2_' subjectcode '_ses-emptyroom_task-emptyroom_meg_sourcereconstruction.mat'],'virtualchannel_raw');
for channel=1:82;
for trial=1:length(virtualchannel_raw.trial)
    combinedtimeseries_ref(500*trial-499:500*trial,channel)=virtualchannel_raw.trial{trial}(channel,:);
end
end
else
end
clearvars -except template_grid state listing subject
end
