function PLV=PhaseSI(data)
%%Phase synchronization
% input:  
%        xr,yr are two different sequence, xr and yr should be filtered by bandpass 
%      filtering
% output:
%        PLV: phase synchronization index or phase locking
%希尔伯特变换构建解析表达式
data1=hilbert(data);

%获取信号的瞬时相位 the instantaneous phases of two signal components
for a=1:length(data1(1,:));
for b=1:length(data1(1,:));
x_theta = angle(data1(:,a));     
y_theta = angle(data1(:,b));

%瞬时相位差 phase differences
xy_theta=x_theta-y_theta;

%相位锁相值 phase locking/phase synchronization index
PLV(a,b)=abs(sum(exp(i*xy_theta)))/length(data(:,a));
% PLV=sqrt((mean(cos(xy_theta)))^2+(mean(sin(xy_theta)))^2);

end
end



return




