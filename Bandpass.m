clear all
state='rest';
listing=dir(['E:\Cam-Can MEG\derivatives_' state '\']);
for subject=1:length(listing)-2
subjectcode=listing(subject+2).name;
clear ztimeseries
clear bptimeseries
clear combinedtimeseries
if exist(['E:\Cam-Can MEG\preprocessed\derivatives_' state '\' subjectcode '\mf2pt2_' subjectcode '_ses-' state '_task-' state '_meg_sourcereconstruction.mat'])>0;
load(['E:\Cam-Can MEG\preprocessed\derivatives_' state '\' subjectcode '\mf2pt2_' subjectcode '_ses-' state '_task-' state '_meg_sourcereconstruction.mat']);
fs=250;
trialnumber=length(virtualchannel_raw.trial);
for channel=1:82
for trial=1:trialnumber
    combinedtimeseries(500*trial-499:500*trial,channel)=virtualchannel_raw.trial{trial}(channel,:);
end
end
bptimeseries=[];

freq='delta';
bptimeseries.raw=bandpass(combinedtimeseries,[1 4],fs);
bptimeseries.normalized=zscore(bptimeseries.raw);
bptimeseries.raw=[];
save(['E:\Cam-Can MEG\preprocessed\derivatives_' state '\' subjectcode '\mf2pt2_' subjectcode '_ses-' state '_task-' state '_meg_sourcereconstruction_' freq '.mat'],'bptimeseries');


freq='theta';
bptimeseries.raw=bandpass(combinedtimeseries,[4 8],fs);
bptimeseries.normalized=zscore(bptimeseries.raw);
bptimeseries.raw=[];
save(['E:\Cam-Can MEG\preprocessed\derivatives_' state '\' subjectcode '\mf2pt2_' subjectcode '_ses-' state '_task-' state '_meg_sourcereconstruction_' freq '.mat'],'bptimeseries');


freq='alpha';
bptimeseries.raw=bandpass(combinedtimeseries,[8 12],fs);
bptimeseries.normalized=zscore(bptimeseries.raw);
bptimeseries.raw=[];
save(['E:\Cam-Can MEG\preprocessed\derivatives_' state '\' subjectcode '\mf2pt2_' subjectcode '_ses-' state '_task-' state '_meg_sourcereconstruction_' freq '.mat'],'bptimeseries');


freq='beta';
bptimeseries.raw=bandpass(combinedtimeseries,[12 30],fs);
bptimeseries.normalized=zscore(bptimeseries.raw);
bptimeseries.raw=[];
save(['E:\Cam-Can MEG\preprocessed\derivatives_' state '\' subjectcode '\mf2pt2_' subjectcode '_ses-' state '_task-' state '_meg_sourcereconstruction_' freq '.mat'],'bptimeseries');


freq='lowgamma';
bptimeseries.raw=bandpass(combinedtimeseries,[30 50],fs);
bptimeseries.normalized=zscore(bptimeseries.raw);
bptimeseries.raw=[];
save(['E:\Cam-Can MEG\preprocessed\derivatives_' state '\' subjectcode '\mf2pt2_' subjectcode '_ses-' state '_task-' state '_meg_sourcereconstruction_' freq '.mat'],'bptimeseries');


freq='highgamma';
bptimeseries.raw=bandpass(combinedtimeseries,[50 100],fs);
bptimeseries.normalized=zscore(bptimeseries.raw);
bptimeseries.raw=[];
save(['E:\Cam-Can MEG\preprocessed\derivatives_' state '\' subjectcode '\mf2pt2_' subjectcode '_ses-' state '_task-' state '_meg_sourcereconstruction_' freq '.mat'],'bptimeseries');


freq='wide';
bptimeseries.raw=bandpass(combinedtimeseries,[1 100],fs);
bptimeseries.normalized=zscore(bptimeseries.raw);
bptimeseries.raw=[];
save(['E:\Cam-Can MEG\preprocessed\derivatives_' state '\' subjectcode '\mf2pt2_' subjectcode '_ses-' state '_task-' state '_meg_sourcereconstruction_' freq '.mat'],'bptimeseries');

clear ztimeseries
clear abs_ztimeseries
clear abs_ztimeseries_peak
clear Avalanche
clear TrialAvalanche
clear TrialAvalancheProperty
clear ztimeseries_negpeak
clear ztimeseries_pospeak




else
end
end
