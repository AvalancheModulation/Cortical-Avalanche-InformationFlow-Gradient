load('fieldtrip-20210912\template\sourcemodel\standard_sourcemodel3d4mm.mat'); 

%link to download Mars atlas Colin27 template: http://meca-brain.org/software/marsatlas/
atlas=ft_read_atlas('Mars\colin27_MNI_MarsAtlas.nii'); %Mars Atlas Colin27 raw file%
atlas.tissue=atlas.parcellation;
cfg=[];
cfg.interpmethod='nearest';
cfg.parameter='tissue';
sourcemodel2=ft_sourceinterpolate(cfg,atlas,sourcemodel);

for region=1:41
indx=find(sourcemodel2.tissue==region);

clear coordinates 

for a=1:length(indx);
coordinates(a,:)=sourcemodel.pos(indx(a,1),:);
end

clear coordinatedistance

for a=1:length(indx);
coordinatedistance(a,:)=sqrt((coordinates(:,1)-coordinates(a,1)).^2+(coordinates(:,2)-coordinates(a,2)).^2+(coordinates(:,3)-coordinates(a,3)).^2);
end

for a=1:length(indx);
coordinatedistance(a,length(indx)+1)=mean(coordinatedistance(a,1:length(indx)));
end

 [x,y]=find(coordinatedistance(:,length(indx)+1)==min(coordinatedistance(:,length(indx)+1)));
 
ROICoordinatesIndex(region,1)=indx(x,1);
ROICoordinates(region,:)=sourcemodel.pos(indx(x,1),:);
end

for region=101:141
indx=find(sourcemodel2.tissue==region);

clear coordinates 

for a=1:length(indx);
coordinates(a,:)=sourcemodel.pos(indx(a,1),:);
end

clear coordinatedistance

for a=1:length(indx);
coordinatedistance(a,:)=sqrt((coordinates(:,1)-coordinates(a,1)).^2+(coordinates(:,2)-coordinates(a,2)).^2+(coordinates(:,3)-coordinates(a,3)).^2);
end

for a=1:length(indx);
coordinatedistance(a,length(indx)+1)=mean(coordinatedistance(a,1:length(indx)));
end

 [x,y]=find(coordinatedistance(:,length(indx)+1)==min(coordinatedistance(:,length(indx)+1)));
 
ROICoordinatesIndex(41+region-100,1)=indx(x,1);
ROICoordinates(41+region-100,:)=sourcemodel.pos(indx(x,1),:);
end