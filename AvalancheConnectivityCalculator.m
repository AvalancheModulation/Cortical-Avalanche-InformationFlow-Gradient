%This code is to calculate the incidence/ probability that an avalanche
%involves two ROIs and generates a 82 x 82 matrix, uses the output from
%ExtractAvalanches.m

listing=dir(['E:\Cam-Can MEG\derivatives_rest\']);
for subject=1:length(listing)-2
subjectcode=listing(subject+2).name;
a=exist(['E:\Cam-Can MEG\preprocessed\derivatives_rest\' subjectcode '\mf2pt2_' subjectcode '_ses-rest_task-rest_meg_sourcereconstruction.mat']);
b=exist(['E:\Cam-Can MEG\preprocessed\derivatives_passive\' subjectcode '\mf2pt2_' subjectcode '_ses-passive_task-passive_meg_sourcereconstruction.mat']);
c=exist(['E:\Cam-Can MEG\preprocessed\derivatives_smt\' subjectcode '\mf2pt2_' subjectcode '_ses-smt_task-smt_meg_sourcereconstruction.mat']);
if a*b*c>0

for a=1:7
if a==1
    freq='delta';
else if a==2
        freq='theta';
    else if a==3
            freq='alpha';
        else if a==4
                freq='beta';
            else if a==5
                    freq='lowgamma';
                else if a==6
                        freq='highgamma';
                    else if a==7
                            freq='wide';
                        end
                    end
                end
            end
        end
    end
end

state='rest';
load(['E:\Cam-Can MEG\preprocessed\derivatives_' state '\' subjectcode '\mf2pt2_' subjectcode '_ses-' state '_task-' state '_meg_sourcereconstruction_' freq '_Avalancheinfo_SD2.5.mat']);


clear AvalancheChannelsMatrix
clear AvalancheChannels
clear AvalancheChannelsLogical
clear index
clear index2

for avalanches=1:length(Avalanche.Start1);
for channel=1:82
    AvalancheChannels(avalanches,channel)=sum(Avalanche.localmaxima_allpeak(Avalanche.Start1(1,avalanches):Avalanche.End1(1,avalanches),channel));
end
end


AvalancheChannelsLogical=logical(AvalancheChannels);

AvalancheChannelsMatrix=zeros(82,82,length(Avalanche.Start1));



for avalanches=1:length(Avalanche.Start1);
index2=find(AvalancheChannelsLogical(avalanches,:)==1);
for index=find(AvalancheChannelsLogical(avalanches,:)==1)
    
    AvalancheChannelsMatrix(index,index2,avalanches)=1;;

end
end


for b=1:82
    for c=1:82
        AvalancheChannelsMatrixMean1(b,c,subject,a)=sum(AvalancheChannelsMatrix(b,c,:))/avalanches;
    end
end
% 



state='passive';
load(['E:\Cam-Can MEG\preprocessed\derivatives_' state '\' subjectcode '\mf2pt2_' subjectcode '_ses-' state '_task-' state '_meg_sourcereconstruction_' freq '_Avalancheinfo_SD2.5.mat']);


clear AvalancheChannelsMatrix
clear AvalancheChannels
clear AvalancheChannelsLogical
clear index
clear index2

for avalanches=1:length(Avalanche.Start1);
for channel=1:82
    AvalancheChannels(avalanches,channel)=sum(Avalanche.localmaxima_allpeak(Avalanche.Start1(1,avalanches):Avalanche.End1(1,avalanches),channel));
end
end


AvalancheChannelsLogical=logical(AvalancheChannels);

AvalancheChannelsMatrix=zeros(82,82,length(Avalanche.Start1));



for avalanches=1:length(Avalanche.Start1);
index2=find(AvalancheChannelsLogical(avalanches,:)==1);
for index=find(AvalancheChannelsLogical(avalanches,:)==1)
    
    AvalancheChannelsMatrix(index,index2,avalanches)=1;;

end
end


for b=1:82
    for c=1:82
        AvalancheChannelsMatrixMean2(b,c,subject,a)=sum(AvalancheChannelsMatrix(b,c,:))/avalanches;
    end
end




state='smt';
load(['E:\Cam-Can MEG\preprocessed\derivatives_' state '\' subjectcode '\mf2pt2_' subjectcode '_ses-' state '_task-' state '_meg_sourcereconstruction_' freq '_Avalancheinfo_SD2.5.mat']);


clear AvalancheChannelsMatrix
clear AvalancheChannels
clear AvalancheChannelsLogical
clear index
clear index2

for avalanches=1:length(Avalanche.Start1);
for channel=1:82
    AvalancheChannels(avalanches,channel)=sum(Avalanche.localmaxima_allpeak(Avalanche.Start1(1,avalanches):Avalanche.End1(1,avalanches),channel));
end
end


AvalancheChannelsLogical=logical(AvalancheChannels);

AvalancheChannelsMatrix=zeros(82,82,length(Avalanche.Start1));



for avalanches=1:length(Avalanche.Start1);
index2=find(AvalancheChannelsLogical(avalanches,:)==1);
for index=find(AvalancheChannelsLogical(avalanches,:)==1)
    
    AvalancheChannelsMatrix(index,index2,avalanches)=1;;

end
end


for b=1:82
    for c=1:82
        AvalancheChannelsMatrixMean3(b,c,subject,a)=sum(AvalancheChannelsMatrix(b,c,:))/avalanches;
    end
end
end
end
end

