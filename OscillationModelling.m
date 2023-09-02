 t=1;%0-1, strength of connection between lattice 1 and lattice 2
 %To change latttice 1 and 2 between periodic and aperiodic oscillator,interchange between mod(a,1)==0 [periodic] and mod(a,1)>0 [aperiodic]

 %AvalancheSeries1 is the activation status of all neural units in lattice1, 
 %AvalancheSeries2 is the activation status of all neural units in lattice2
 %sequence(:,1) is the total no. of units activated in lattice 1
  %sequence(:,2) is the total no. of units activated in lattice 2
  
ROI5=900
ROI3=ROI5^2;
ROI4=sqrt(sqrt(ROI3));

for a=1:ROI4;
     ROI(a*ROI4-(ROI4-1):a*ROI4,1)=a;
  for b=1:ROI4;
    ROI(a*ROI4-ROI4+b,2)=b;
    end
end

for ROI1=1:sqrt(ROI3)
    for ROI2=1:sqrt(ROI3)
 Coordinates(1,:)=ROI(ROI1,:);
 Coordinates(2,:)=ROI(ROI2,:);
 DistanceMatrix(ROI1,ROI2)=pdist(Coordinates);
      
    end
    
end
DistanceMatrix2=1-(DistanceMatrix./(max(max(DistanceMatrix(:)))));
DistanceMatrix3=(DistanceMatrix2.^2);

%lattice1
matrix=zeros(sqrt(ROI3),sqrt(ROI3));
for a=1:sqrt(ROI3)
    for b=1:sqrt(ROI3)

if a==b;
    matrix(a,b)==1;
else
    if a>b;
        matrix(a,b)==0;

    else
    if b>a

if mod(a,1)==0; %mod(a,1)==0 -> periodic, mod(a,1)>0 -> aperiodic
    adjust=1;
    connect=0.15;
    exponent=1;
else
    adjust=0.6;
    connect=0.4;
    exponent=3.25;
end

   xmin=-1*((DistanceMatrix3(a,b)^exponent)*connect);
xmax=1*((DistanceMatrix3(a,b)^exponent)*connect*adjust);        
p=6;
matrix(a,b)=xmin+((xmax-xmin)*(sum(rand(1,p),2)/p));  

end

     end
end
    end
end
matrix=triu(matrix)+triu(matrix,1)';

%lattice2
matrix2=zeros(sqrt(ROI3),sqrt(ROI3));
for a=1:sqrt(ROI3)
    for b=1:sqrt(ROI3)

if a==b;
    matrix2(a,b)==1;
else
    if a>b;
        matrix2(a,b)==0;

    else
    if b>a

if mod(a,1)==0; %mod(a,1)==0 -> periodic, mod(a,1)>0 -> aperiodic
    adjust=1;
    connect=0.15;
    exponent=1;
else
    adjust=0.6;
    connect=0.4;
    exponent=3.25;
end

   xmin=-1*((DistanceMatrix3(a,b)^exponent)*connect);
xmax=1*((DistanceMatrix3(a,b)^exponent)*connect*adjust);        
p=6;
matrix2(a,b)=xmin+((xmax-xmin)*(sum(rand(1,p),2)/p));  

end

     end
end
    end
end
matrix2=triu(matrix2)+triu(matrix2,1)';




AvalancheSeries=zeros(sqrt(ROI3),10000);
AvalancheSeries2=zeros(sqrt(ROI3),10000);

AvalancheSeries(1:100,1)=1;
AvalancheSeries2(1:100,1)=1;
 
for time=1:10000
    
    %lattice1
for a=1:sqrt(ROI3)
if AvalancheSeries(a,time)==1;

for b=1:sqrt(ROI3)
   x=rand;
   if x<abs(matrix(a,b));
       if matrix(a,b)>0;
   AvalanchePlaceholder(b,a)=1;
       else
           AvalanchePlaceholder(b,a)=-1;
       end
   else
       AvalanchePlaceholder(b,a)=0;
   end
end
    
else
    AvalanchePlaceholder(:,a)=0;
        
end



end


%lattice2
for a=1:sqrt(ROI3)
if AvalancheSeries2(a,time)==1;

for b=1:sqrt(ROI3)
   x=rand;
   if x<abs(matrix2(a,b));
       if matrix2(a,b)>0;
   AvalanchePlaceholder3(b,a)=1;
       else
           AvalanchePlaceholder3(b,a)=-1;
       end
   else
       AvalanchePlaceholder3(b,a)=0;
   end
end
    
else
    AvalanchePlaceholder3(:,a)=0;
        
end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%matrix1
for b=1:sqrt(ROI3)
    AvalanchePlaceholder2(b,time)=sum(AvalanchePlaceholder(b,:));
    if AvalancheSeries(b,time)==1;
        AvalanchePlaceholder2(b,time)=0;       
    else
    end
    if  b>0
repol=7;
    end
        
     if time>repol;
           if sum(AvalancheSeries(b,time-repol:time))>0
               AvalanchePlaceholder2(b,time)=0;
           else
           end
     end
       if time<repol+1
         if sum(AvalancheSeries(b,1:time))>0
             AvalanchePlaceholder2(b,time)=0;
         else
         end
     end  
      
end

 for a=1:sqrt(ROI3)
lag=1;
      if AvalanchePlaceholder2(a,time)>0
     AvalancheSeries(a,time+lag)=1; 
      else
          AvalancheSeries(a,time+lag)=0;
      end
      
      if time>3
       if mod(a,1)==0;
           
      if  AvalanchePlaceholder2(a,time-3)>0 ||AvalanchePlaceholder2(a,time-2)>0 || AvalanchePlaceholder2(a,time-1)>0;
     AvalancheSeries(a,time+lag)=1; 
      else
          AvalancheSeries(a,time+lag)=0;
      end
      else
    if  AvalanchePlaceholder2(a,time-1) >0;
     AvalancheSeries(a,time+lag)=1; 
    end      
       end
   else
      end
   
  end
%matrix2
for b=1:sqrt(ROI3)
    AvalanchePlaceholder4(b,time)=sum(AvalanchePlaceholder3(b,:));
    if AvalancheSeries2(b,time)==1;
        AvalanchePlaceholder4(b,time)=0;       
    else
    end
    if  b>0
 repol=7;

    end
        
     if time>repol;
           if sum(AvalancheSeries2(b,time-repol:time))>0
               AvalanchePlaceholder4(b,time)=0;
           else
           end
     end
       if time<repol+1
         if sum(AvalancheSeries2(b,1:time))>0
             AvalanchePlaceholder4(b,time)=0;
         else
         end
     end  
     
    
end


  for a=1:sqrt(ROI3)
lag=1;
      if AvalanchePlaceholder4(a,time)>0
     AvalancheSeries2(a,time+lag)=1; 
      else 
          AvalancheSeries2(a,time+lag)=0;
      end
      
       if time>3
       if mod(a,1)==0;
      if  AvalanchePlaceholder2(a,time-3)>0 ||AvalanchePlaceholder2(a,time-2)>0 || AvalanchePlaceholder2(a,time-1)>0;
     AvalancheSeries2(a,time+lag)=1;  
      else
          AvalancheSeries2(a,time+lag)=0;
      end
      else
    if  AvalanchePlaceholder4(a,time-1) >0;
     AvalancheSeries2(a,time+lag)=1; 
    end
       end
   else
       end
  end


    for a=1:sqrt(ROI3)   
     %%%%
   if time>3
       if mod(a,1)==0;
      if AvalanchePlaceholder2(a,time-3)>0 
          x=rand;

          if x<t;
       AvalancheSeries2(a,time+lag)=0;
          else
          end
      else
      end
       else
       end
   else
   end
      %%%%
      %%%%
   if time>3
        if mod(a,1)==0;
      if AvalanchePlaceholder4(a,time-3)>0;
          x=rand;
          if x<0;
       AvalancheSeries(a,time+lag)=1;
          else
          end
      else
      end
      else
       end
   else
   end
      %%%%     
  end
 

  
  
end
for time=1:10000
sequence(time,1)=sum(AvalancheSeries(1:sqrt(ROI3),time));
sequence(time,2)=sum(AvalancheSeries2(1:sqrt(ROI3),time));
end
