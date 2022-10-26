clear all
state='smt';
listing=dir(['E:\Cam-Can MEG\derivatives_' state '\']);
for subject=1:length(listing)-2
subjectcode=listing(subject+2).name;
if exist(['E:\Cam-Can MEG\preprocessed\derivatives_' state '\' subjectcode '\mf2pt2_' subjectcode '_ses-' state '_task-' state '_meg_sourcereconstruction.mat'])>0;
load(['E:\Cam-Can MEG\preprocessed\derivatives_' state '\' subjectcode '\mf2pt2_' subjectcode '_ses-' state '_task-' state '_meg_sourcereconstruction.mat']);
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
    
    
    
for trial=1:length(virtualchannel_raw.trial);
    
for channel=1:82
    combinedtimeseries_trial(1:250,channel)=virtualchannel_raw.trial{trial}(channel,:);
end
data1=combinedtimeseries_trial;
  
    if a==1
        %filter setting
        fs = 250;ws = 4; ws=ws/(fs/2); %fs-sample rate; ws-lowpass freq
        wp=1;wp=wp/(fs/2);
        N=length(data1); t=(1:N)/fs;
%         [fb,fa]=butter(4,ws); % 根据ws和wp，来设计butterworth滤波器
        [fb,fa]=butter(4,[wp,ws],'bandpass');
        [h,w]=freqz(fb,fa); % 得到滤波器具体参数，与后面分析无关
        %figure(81);plot(w/pi*fs/2,abs(h));%filter figure
    end
    if a==2
        %filter setting
        fs = 250;ws = 8; ws=ws/(fs/2); %fs-sample rate; ws-lowpass freq
        wp=4;wp=wp/(fs/2);
        N=length(data1); t=(1:N)/fs;
        %[fb,fa]=butter(4,ws);
        [fb,fa]=butter(4,[wp,ws],'bandpass');
        [h,w]=freqz(fb,fa);
        %figure(81);plot(w/pi*fs/2,abs(h));%filter figure
    end
    if a==3
        %filter setting
        fs = 250;ws = 12; ws=ws/(fs/2); %fs-sample rate; ws-lowpass freq
        wp=8;wp=wp/(fs/2);
        N=length(data1); t=(1:N)/fs;
        %[fb,fa]=butter(4,ws);
        [fb,fa]=butter(4,[wp,ws],'bandpass');
        [h,w]=freqz(fb,fa);
        %figure(81);plot(w/pi*fs/2,abs(h));%filter figure
    end
    if a==4
        %filter setting
        fs = 250;ws = 30; ws=ws/(fs/2); %fs-sample rate; ws-lowpass freq
        wp=12;wp=wp/(fs/2);
        N=length(data1); t=(1:N)/fs;
        %[fb,fa]=butter(4,ws);
        [fb,fa]=butter(4,[wp,ws],'bandpass');
        [h,w]=freqz(fb,fa);
        %figure(81);plot(w/pi*fs/2,abs(h));%filter figure
    end
    if a==5
        %filter setting
        fs = 250;ws = 48; ws=ws/(fs/2); %fs-sample rate; ws-lowpass freq
        wp=30;wp=wp/(fs/2);
        N=length(data1); t=(1:N)/fs;
        %[fb,fa]=butter(4,ws);
        [fb,fa]=butter(4,[wp,ws],'bandpass');
        [h,w]=freqz(fb,fa);
        %figure(81);plot(w/pi*fs/2,abs(h));%filter figure
    end
    if a==6 
        %filter setting
        fs = 250;ws = 100; ws=ws/(fs/2); %fs-sample rate; ws-lowpass freq
        wp=52;wp=wp/(fs/2);
        N=length(data1); t=(1:N)/fs;
        %[fb,fa]=butter(4,ws);
        [fb,fa]=butter(4,[wp,ws],'bandpass');
        [h,w]=freqz(fb,fa);
        %figure(81);plot(w/pi*fs/2,abs(h));%filter figure
    end
    if a==7
        %filter setting
        fs = 250;ws = 100; ws=ws/(fs/2); %fs-sample rate; ws-lowpass freq
        wp=1;wp=wp/(fs/2);
        N=length(data1); t=(1:N)/fs;
%         [fb,fa]=butter(4,ws);
        [fb,fa]=butter(4,[wp,ws],'bandpass');
        [h,w]=freqz(fb,fa);
    end
    
        
    for channel=1:82
    filter_x=filter(fb,fa,data1(:,channel));
    detrend_x = detrend(filter_x);
    trend = filter_x - detrend_x;  
    data2(:,channel)=detrend_x; 
    end

    
bptimeseries.raw(250*trial-249:250*trial,:)=data2;

end
   bptimeseries.normalized=zscore(bptimeseries.raw);
bptimeseries.raw=[];
save(['E:\Cam-Can MEG\preprocessed\derivatives_' state '\' subjectcode '\mf2pt2_' subjectcode '_ses-' state '_task-' state '_meg_sourcereconstruction_' freq '.mat'],'bptimeseries');
end
else
end
clearvars -except template_grid state listing subject
end