%%%%%%%%%%%%%%%%%%%%%%%%%%%
%NOTE:
%"databandpassed" output from Preprocessing_2.m should be bandpassed and saved as bptimeseries.normalized
%bptimeseries.normalized should be a N x C matrix, N being the number of timepoints and C being the number of source reconstructed regions
%dPTE is directed phase transfer entropy, PLV is phase locking value

%NetworkConfiguration.dPTE.DynamicdPTE_AllPathways-> dPTE of each segment for each edge
%(ROI,ROI,trial,freq);

% NetworkConfiguration.dPTE.AveragedPTE_AllPathways-> average dPTE of each edge
%(ROI,ROI,freq);

% NetworkConfiguration.dPTE.AveragedPTE_ROI-> average of net dPTE of each ROI 
%(ROI,freq)

% NetworkConfiguration.dPTE.DynamicdPTE_ROI-> net dPTE of each segment for each ROI 
%(trial,ROI,freq)

% NetworkConfiguration.PLV.DynamicPLV_AllPathways-> PLV of each segment for each edge
%(ROI,ROI,trial,freq);

% NetworkConfiguration.PLV.AveragePLV_AllPathways-> average PLV of each edge
%(ROI,ROI,freq);

% NetworkConfiguration.PLV.AveragePLV_ROI-> average of net PLV of each ROI 
%(ROI,freq)

% NetworkConfiguration.PLV.DynamicPLV_ROI-> net PLV of each segment for each ROI 
%(trial,ROI,freq)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
state='rest';
% state='passive';
%state='smt';
listing=dir(['E:\Cam-Can MEG\derivatives_rest\']);


for subject=1:length(listing)-2
subjectcode=listing(subject+2).name;
if exist(['E:\Cam-Can MEG\preprocessed\derivatives_' state '\' subjectcode '\mf2pt2_' subjectcode '_ses-' state '_task-' state '_meg_sourcereconstruction.mat'])>0;



  
for c=1:7

if c==1
    freq='delta';
else if c==2
        freq='theta';
    else if c==3
            freq='alpha';
        else if c==4
                freq='beta';
            else if c==5
                    freq='lowgamma';
                else if c==6
                        freq='highgamma';
                    else if c==7
                            freq='wide';
                        end
                    end
                end
            end
        end
    end
end


%%%%load source reconstruction
load(['E:\Cam-Can MEG\preprocessed\derivatives_' state '\' subjectcode '\mf2pt2_' subjectcode '_ses-' state '_task-' state '_meg_sourcereconstruction_' freq '.mat']);

if strcmp(state,'smt');
denominator=250;
else
 denominator=500;
end




trialnumber=length(bptimeseries.normalized)/denominator;

for trial=1:trialnumber
segment=bptimeseries.normalized(denominator*trial-(denominator-1):denominator*trial,1:82);
TransferEntropy(:,:,trial,c)=PhaseTE_MF(segment,[ ],'scott');
end

for a=1:82
    for b=1:82
TransferEntropyMean(a,b,c)=mean(TransferEntropy(a,b,:,c));
    end
end
for a=1:82
    ChannelNetEntropy(a,c)=mean(TransferEntropyMean(a,:,c));
end

for trial=1:trialnumber
    for a=1:82
    Y(trial,a,c)=mean(TransferEntropy(a,:,trial,c));
    end
end



for trial=1:trialnumber
segment=bptimeseries.normalized(denominator*trial-(denominator-1):denominator*trial,1:82);

PhaseLocking(:,:,trial,c)=PhaseSI(segment);

end



for a=1:82
    for b=1:82
PhaseLockingMean(a,b,c)=mean(PhaseLocking(a,b,:,c));
    end
end
for a=1:82
    ChannelNetPhaseLocking(a,c)=mean(PhaseLockingMean(a,:,c));
end

for trial=1:trialnumber
    for a=1:82
    Z(trial,a,c)=mean(PhaseLocking(a,:,trial,c));
    end
end
end


NetworkConfiguration=[];
NetworkConfiguration.dPTE.DynamicdPTE_AllPathways=TransferEntropy;
NetworkConfiguration.dPTE.AveragedPTE_AllPathways=TransferEntropyMean;
NetworkConfiguration.dPTE.AveragedPTE_ROI=ChannelNetEntropy;
NetworkConfiguration.dPTE.DynamicdPTE_ROI=Y;
NetworkConfiguration.PLV.DynamicPLV_AllPathways=PhaseLocking;
NetworkConfiguration.PLV.AveragePLV_AllPathways=PhaseLockingMean;
NetworkConfiguration.PLV.AveragePLV_ROI=ChannelNetPhaseLocking;
NetworkConfiguration.PLV.DynamicPLV_ROI=Z;

save(['E:\Cam-Can MEG\preprocessed\derivatives_' state '\' subjectcode '\mf2pt2_' subjectcode '_ses-' state '_task-' state '_meg_networkparameters.mat'],'NetworkConfiguration');

clearvars -except state listing subject

else
end
end

