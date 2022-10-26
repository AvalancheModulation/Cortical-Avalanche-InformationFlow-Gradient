%This code creates an output HurstROI in the form of subject x ROI x freq
%the hurst exponent of each subject's ROI amplitude fluctuations at different frequencies is calculated 

clear all
state='rest';
listing=dir(['E:\Cam-Can MEG\derivatives_' state '\']);
for subject=1:length(listing)-2
subjectcode=listing(subject+2).name;


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


load(['normalized bandpassed source reconstruction output']);
 for segment=1:length(bptimeseries.normalized)/5;
for channel=1:82
localmaximaaddition(segment,channel)=mean(abs(bptimeseries.normalized(5*segment-4:5*segment,channel)));
end
end
for channel=1:82
HurstROI(subject,channel,a)=hurst(localmaximaaddition(:,channel));
end


end

end