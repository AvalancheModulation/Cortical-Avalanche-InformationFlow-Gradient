function PLV=PhaseSI(data)
%%Phase synchronization
% input:  
%        xr,yr are two different sequence, xr and yr should be filtered by bandpass 
%      filtering
% output:
%        PLV: phase synchronization index or phase locking
%ϣ�����ر任�����������ʽ
data1=hilbert(data);

%��ȡ�źŵ�˲ʱ��λ the instantaneous phases of two signal components
for a=1:length(data1(1,:));
for b=1:length(data1(1,:));
x_theta = angle(data1(:,a));     
y_theta = angle(data1(:,b));

%˲ʱ��λ�� phase differences
xy_theta=x_theta-y_theta;

%��λ����ֵ phase locking/phase synchronization index
PLV(a,b)=abs(sum(exp(i*xy_theta)))/length(data(:,a));
% PLV=sqrt((mean(cos(xy_theta)))^2+(mean(sin(xy_theta)))^2);

end
end



return




