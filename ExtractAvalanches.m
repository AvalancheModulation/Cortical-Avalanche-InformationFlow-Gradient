%%%%%%%%%%%%%%%%%%%%%%%%%%%
%NOTE:
%Bandpassed source reconstructed data should be saved as bptimeseries.normalized
%bptimeseries.normalized should be a N x C matrix, N being the number of timepoints and C being the number of source reconstructed regions
%Avalanche.Bin extracts combined number of suprathreshold events for each 4ms bin.
%1,2 and 4 corresponds to 4, 8 and 16 ms bins.
%Avalanche.Start and Avalanche.End correspond to index of start and end of each avalanche
%Avalanche.Property(:,1)-> avalanche number
%Avalanche.Property(:,2)-> average avalanche size
%Avalanche.Property(:,3)-> maximum avalanche size
%Avalanche.Property(:,4)-> average avalanche duration
%Avalanche.Property(:,5)-> maximum avalanche duration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
state='rest';
% state='passive';
%state='smt';
listing=dir(['E:\Cam-Can MEG\derivatives_' state '\']);

for threshold=2.5;
for subject=1:length(listing)-2
subjectcode=listing(subject+2).name;


if exist(['E:\Cam-Can MEG\preprocessed\derivatives_' state '\' subjectcode '\mf2pt2_' subjectcode '_ses-' state '_task-' state '_meg_sourcereconstruction.mat'])>0;
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


load(['E:\Cam-Can MEG\preprocessed\derivatives_' state '\' subjectcode '\mf2pt2_' subjectcode '_ses-' state '_task-' state '_meg_sourcereconstruction_' freq '.mat']);


Avalanche=[];
abs_ztimeseries=abs(bptimeseries.normalized);
abs_ztimeseries_peak=abs_ztimeseries;
abs_ztimeseries_peak(find(abs_ztimeseries_peak<threshold) )=0;


for channel=1:82
    Avalanche.localmaxima_allpeak(:,channel)=islocalmax(abs_ztimeseries_peak(:,channel));
end

for timepoint=1:length(abs_ztimeseries(:,1));
    Avalanche.Bin(timepoint,1)=sum(Avalanche.localmaxima_allpeak(timepoint,1:82));
    
end

%Bin1
z=rot90(Avalanche.Bin);
Avalanche.Start1 = strfind([0,z>0],[0 1]);
Avalanche.End1 = strfind([z>0,0],[1 0]);
Avalanche.Duration1= Avalanche.End1 - Avalanche.Start1 + 1;

for avalanchebins=1:length(Avalanche.Duration1)
Avalanche.Sizes1(avalanchebins,1)=sum(Avalanche.Bin((Avalanche.Start1(1,avalanchebins):Avalanche.End1(1,avalanchebins)),1));
end

for size=1:82;
    Avalanche.Distribution(size,1)=sum(Avalanche.Sizes1(:)==size);
end


%Bin2
for bins=1:floor(length(abs_ztimeseries(:,1))/2)
    Avalanche.BinTwo(bins,1)=sum(Avalanche.Bin(2*bins-1:2*bins,1));   
    
end

z=rot90(Avalanche.BinTwo);
Avalanche.Start2 = strfind([0,z>0],[0 1]);
Avalanche.End2 = strfind([z>0,0],[1 0]);
Avalanche.Duration2= Avalanche.End2 - Avalanche.Start2 + 1;

for avalanchebins=1:length(Avalanche.Duration2)
Avalanche.Sizes2(avalanchebins,1)=sum(Avalanche.BinTwo((Avalanche.Start2(1,avalanchebins):Avalanche.End2(1,avalanchebins)),1));
end

for size=1:82;
    Avalanche.Distribution(size,2)=sum(Avalanche.Sizes2(:)==size);
end



%Bin4
for bins=1:floor(length(abs_ztimeseries(:,1))/4);
    Avalanche.BinFour(bins,1)=Avalanche.BinTwo(2*bins-1,1)+Avalanche.BinTwo(2*bins,1);
end

z=rot90(Avalanche.BinFour);
Avalanche.Start4 = strfind([0,z>0],[0 1]);
Avalanche.End4 = strfind([z>0,0],[1 0]);
Avalanche.Duration4= Avalanche.End4 - Avalanche.Start4 + 1;

for avalanchebins=1:length(Avalanche.Duration4)
Avalanche.Sizes4(avalanchebins,1)=sum(Avalanche.BinFour((Avalanche.Start4(1,avalanchebins):Avalanche.End4(1,avalanchebins)),1));
end

for size=1:82;
    Avalanche.Distribution(size,3)=sum(Avalanche.Sizes4(:)==size);
end


if strcmp(state,'smt');
denominator=250;
else
 denominator=500;
end



% load(['E:\Cam-Can MEG\preprocessed\derivatives_' state '\' subjectcode '\mf2pt2_' subjectcode '_ses-' state '_task-' state '_meg_sourcereconstruction_' freq '_Avalancheinfo.mat']);
for trials=1:length(Avalanche.Bin)/denominator
    clear index
    TrialAvalancheProperty(trials,1)=sum(Avalanche.Start1>=(denominator*trials-(denominator-1)) & Avalanche.Start1<=(denominator*trials));
    index=find(Avalanche.Start1>=(denominator*trials-(denominator-1)) & Avalanche.Start1<=(denominator*trials));
    if isempty(index)==1
        TrialAvalancheProperty(trials,1:5)=0;
    else
    TrialAvalancheProperty(trials,2)=mean(Avalanche.Sizes1(index));
               TrialAvalancheProperty(trials,3)=max(Avalanche.Sizes1(index));
        A=rot90(Avalanche.Start1,-1);
          index=find(A>=(denominator*trials-(denominator-1)) & A<=(denominator*trials));
    TrialAvalancheProperty(trials,4)=mean(Avalanche.Duration1(index));
    TrialAvalancheProperty(trials,5)=max(Avalanche.Duration1(index));
    end
end
Avalanche.Property=TrialAvalancheProperty;
  save(['E:\Cam-Can MEG\preprocessed\derivatives_' state '\' subjectcode '\mf2pt2_' subjectcode '_ses-' state '_task-' state '_meg_sourcereconstruction_' freq '_Avalancheinfo_SD' num2str(threshold) '.mat'],'Avalanche');

end
clearvars -except threshold state listing subject AvalancheChannelsMatrixMean1 AvalancheChannelsMatrixMean2 AvalancheDifference
else
end
end
end