%Bandpass + Faulty Component Removal


clear all
state='rest';
% state='passive';
%state='smt';
listing=dir(['E:\Cam-Can MEG\derivatives_' state '\']); %path to raw MEG files

subject=1;
    
subjectcode=listing(subject+2).name;

load(['E:\Cam-Can MEG\derivatives_' state '\' subjectcode '\mf2pt2_' subjectcode '_ses-' state '_task-' state '_meg_artifactcomponent.mat']);
load(['E:\Cam-Can MEG\derivatives_' state '\' subjectcode '\mf2pt2_' subjectcode '_ses-' state '_task-' state '_meg_ICAinfo.mat'],'comp');
 
for component=1:length(comp.label);
for trial=1:length(comp.trial)
    comptimeseries(trial,component)=mean(abs(comp.trial{trial}(component,:)));
end
end

%%%%% VISUALLY INSPECT FAULTY COMPONENTS 
%%%%% MANUALLY ADD BACK FAULTY COMPONENTS TO artifactcomponents VARIABLE

cfg=[];
cfg.component=artifactcomponents;
[dataprocessed]=ft_rejectcomponent(cfg, comp)

cfg=[];
cfg.bpfilter='yes';
cfg.bpfreq=[1 124];
cfg.bsfilter='yes';
cfg.bsfreq(1,1:2)=[48 51];
cfg.bsfreq(2,1:2)=[99 101];
cfg.bsfreq(3,1:2)=[87 89];
cfg.bsfreq(4,1:2)=[25 26];
databandpassed=ft_preprocessing(cfg,dataprocessed);


%%%%%Reject bad trial segments for smt data
if strcmp(state,'smt');
    
for a=1:length(databandpassed.trial);
    for channel=1:length(databandpassed.label);
datatimeseries(a,channel)=mean(abs(databandpassed.trial{a}(channel,:)));
    end
datatimeseries2(a,1)=mean(datatimeseries(a,:));
end


for a=1:120
    F(a,1)=datatimeseries2(a,1)/mean(datatimeseries2(:,1));
end
G=find(F>1.35);
trials=1:120
for a=1:length(G);
trials(1,G(a,1))=0;
end
trials(find(trials==0))=[];
cfg=[];
cfg.trials=trials;
databandpassed=ft_selectdata(cfg,databandpassed);
else
end

mkdir(['E:\Cam-Can MEG\derivatives_' state '\' subjectcode '\']);
save(['E:\Cam-Can MEG\derivatives_' state '\' subjectcode '\mf2pt2_' subjectcode '_ses-' state '_task-' state '_meg_preprocessed.mat'],'databandpassed');



