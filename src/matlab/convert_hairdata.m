function [p] = convert_hairdata(pathbase_data,hairNum,run_id)
%
%
p.hdia = 0.002;

hairdata = csvread(strcat(pathbase_data,'/csv-files/',num2str(hairNum),...
    'hair_files/hairs',num2str(run_id),'.csv'),1,0,[1 0 3 hairNum]);
C1 = 0;
C2 = 1;
numPoints = hairdata(1,2);

for h = 1:hairNum
    disp(num2str(h))
    R1 = 1+hairdata(1,1)+numPoints*(h-1);
    R2 = hairdata(1,1)+numPoints*h;
    hair_temp = dlmread(strcat(pathbase_data,'/vertex-files/',num2str(hairNum),...
        'hair_files/hairs',num2str(run_id),'.vertex'),' ',[R1 C1 R2 C2]);
    disp('centers')
    eval(['p.hair',num2str(h),'Centerx = hairdata(2,h+1);']);
    eval(['p.hair',num2str(h),'Centery = hairdata(3,h+1);']);
    disp('vertices')
    eval(['p.h',num2str(h),'_x = hair_temp(:,1);']);
    eval(['p.h',num2str(h),'_y = hair_temp(:,2);']);
end
