%Data extraction + ICA component analysis/ EOG EMG noise removal


clear all
state='rest';
% state='passive';
%state='smt';
listing=dir(['E:\Cam-Can MEG\derivatives_' state '\']); %path to raw MEG files-> finds the full list of subjects

for subject=1:length(listing)-2
    
subjectcode=listing(subject+2).name;


if strcmp(state,'smt');
cfg            = [];
cfg.dataset    = ['E:\Cam-Can MEG\derivatives_' state '\' subjectcode '\mf2pt2_' subjectcode '_ses-' state '_task-' state '_meg.fif']; 
cfg.trialdef.eventtype='Trigger';
cfg.trialdef.eventvalue=[1 2 3];
cfg.trialdef.prestim=0;
cfg.trialdef.poststim=1;

trialinfo           = ft_definetrial(cfg);

cfg            = [];
cfg.dataset    = ['E:\Cam-Can MEG\derivatives_' state '\' subjectcode '\mf2pt2_' subjectcode '_ses-' state '_task-' state '_meg.fif']; 
cfg.trl=trialinfo.trl;
cfg.continuous='no';
cfg.channel    = {'eog','ecg'};
ref_data           = ft_preprocessing(cfg);
else
    
  cfg            = [];
cfg.dataset    = ['E:\Cam-Can MEG\derivatives_' state '\' subjectcode '\mf2pt2_' subjectcode '_ses-' state '_task-' state '_meg.fif']; % note that you may need to add the full path to the .ds directory
cfg.continuous = 'yes';
cfg.channel    = {'eog','ecg'};
ref_data           = ft_preprocessing(cfg);

cfg         = [];
cfg.trials='all';
cfg.length  = 2;
cfg.overlap = 0;
ref_data        = ft_redefinetrial(cfg, ref_data); 

if strcmp(state,'rest');
cfg=[];
cfg.trials='all';
% cfg.trials=1:150
cfg.trials=50:199;
ref_data=ft_selectdata(cfg,ref_data);
else
end
end

cfg=[];
cfg.resamplefs=250;
ref_data2=ft_resampledata(cfg,ref_data);

Z=fopen(['E:\Cam-Can MEG\derivatives_' state '\' subjectcode '\mf2pt2_' subjectcode '_ses-' state '_task-' state '_meg.log']);
for a=1:100
tline=fgetl(Z);
k=strfind(tline,'Static bad channels');
if length(k)>0
    break
end
end

 faultychannels=sscanf(tline,'%*[^0123456789]%d');
 faultychannels(1,:)=[];
totalchannel{1}='MEG';
 for channel=1:length(faultychannels);
  
  totalchannel{channel+1}=['-MEG' num2str(faultychannels(channel,1),'%04.f')];
 end
 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



if strcmp(state,'rest');
cfg         = [];
cfg.toilim=[100 400];
data        = ft_redefinetrial(cfg, data);
data.sampleinfo=[1 300001];
else 

end


zthreshold=20;
 options_zscore = {'zthreshold',         zthreshold};
[badsegment_zscore,    dataclean]=hcp_qc_zscore(data,options_zscore);



cfg=[];
cfg.resamplefs=250;
data2=ft_resampledata(cfg,data);

 



cfg         = [];
cfg.length  = 2;
cfg.overlap = 0;
data4        = ft_redefinetrial(cfg, data2);



artCfg=[];
 artCfg.artfctdef.reject='complete'; 
artCfg.artfctdef.zvalue.artifact =ceil(badsegment_zscore/4);
 data5 = ft_rejectartifact(artCfg, data4);
ref_data2=ft_rejectartifact(artCfg,ref_data2);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Z=fopen(['E:\Cam-Can MEG\derivatives_' state '\' subjectcode '\mf2pt2_' subjectcode '_ses-' state '_task-' state '_meg.log']);
for a=1:100
tline=fgetl(Z);
k=strfind(tline,'SSS:');
if length(k)>0
    break
end
end
 components=sscanf(tline,'%*[^0123456789]%d');
numcomponent=components(1,1);

cfg=[];
cfg.numcomponent=numcomponent;
cfg.runica.maxsteps=50;
comp=ft_componentanalysis(cfg,data5);
save(['E:\Cam-Can MEG\derivatives_' state '\' subjectcode '\mf2pt2_' subjectcode '_ses-' state '_task-' state '_meg_ICAinfo.mat'],'comp');




% combine ECG and EOG data with ICA components

ref_data2.time=comp.time;
comp_ecg      = ft_appenddata([], ref_data2, comp);

% compute a frequency decomposition of all components and the ECG
cfg            = [];
cfg.method     = 'mtmfft';
cfg.output     = 'fourier';
cfg.foilim     = [0 100];
cfg.taper      = 'hanning';
cfg.pad        = 'maxperlen';
freq           = ft_freqanalysis(cfg, comp_ecg);

% compute coherence between all components and the ECG

for component=1:numcomponent
    if component<10
cfg            = [];
cfg.channelcmb = {['runica00' num2str(component) ] 'EOG061'};
cfg.jackknife  = 'no';
cfg.method     = 'coh';
fdcomp         = ft_connectivityanalysis(cfg, freq);
    else
        cfg            = [];
cfg.channelcmb = {['runica0' num2str(component) ] 'EOG061'};
cfg.jackknife  = 'no';
cfg.method     = 'coh';
fdcomp         = ft_connectivityanalysis(cfg, freq);
    end
    
    A(component,:,1)=fdcomp.cohspctrm(1,2:40);

end

for component=1:numcomponent
    if component<10
cfg            = [];
cfg.channelcmb = {['runica00' num2str(component) ] 'EOG062'};
cfg.jackknife  = 'no';
cfg.method     = 'coh';
fdcomp         = ft_connectivityanalysis(cfg, freq);
    else
        cfg            = [];
cfg.channelcmb = {['runica0' num2str(component) ] 'EOG062'};
cfg.jackknife  = 'no';
cfg.method     = 'coh';
fdcomp         = ft_connectivityanalysis(cfg, freq);
    end
    
    A(component,:,2)=fdcomp.cohspctrm(1,2:40);

end

for component=1:numcomponent
    if component<10
cfg            = [];
cfg.channelcmb = {['runica00' num2str(component) ] 'ECG'};
cfg.jackknife  = 'no';
cfg.method     = 'coh';
fdcomp         = ft_connectivityanalysis(cfg, freq);
    else
        cfg            = [];
cfg.channelcmb = {['runica0' num2str(component) ] 'ECG'};
cfg.jackknife  = 'no';
cfg.method     = 'coh';
fdcomp         = ft_connectivityanalysis(cfg, freq);
    end
    
    A(component,:,3)=fdcomp.cohspctrm(1,2:40);

end


for component=1:numcomponent
    for artifact=1:3
B(component,artifact)=mean(A(component,:,artifact));
    end
end
for artifact=1:3
    E(:,artifact)=zscore(B(:,artifact));
end

Thresholdedcorrelation=E;
Thresholdedcorrelation(find(E<3))=0;
for component=1:numcomponent
Thresholdedcorrelationsum(1,component)=sum(Thresholdedcorrelation(component,:));
end
artifactcomponents=find(Thresholdedcorrelationsum>0);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


save(['E:\Cam-Can MEG\derivatives_' state '\' subjectcode '\mf2pt2_' subjectcode '_ses-' state '_task-' state '_meg_artifactcomponent.mat'],'artifactcomponents');

clearvars -except subject state listing
end





 


