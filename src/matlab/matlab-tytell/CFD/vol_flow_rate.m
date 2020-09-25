function [VFlow, Umax, i1, i2, j1, j2] = vol_flow_rate(x,y,Vinterp,xl,yl,GridSize,Lmin,Lmax)

% x             x-coordinate of the data in Vinterp
% y             y-coordinate of the data in Vinterp
% Vinterp       interpolated data returned from importsamrai.m
% xl            x-coordinate of Lagrangian data returned from positionread.m
% yl            y-coordinate of Lagrangian data returned from positionread.m
% GridSize      Finest grid size
% Lmin          Lower end of Cartesian domain
% Lmax          Upperend of Cartesian domain
% VFlow         Volumetric flow rate
% Umax          Maximum velocity
% i1            column index of the first velocity we want to pull
% i2            column index of the last velocity we want to pull
% j1            row index of the first velocity we want to pull
% j2            row index of the last velocity we want to pull

%Note that we assume the input files are pperitop, pperibottom (as the
%first and second file)
pperitop=308;   %The number of points along the top of the tube
pperibot=308;   %The number of points along the bottom of the tube

Xend1 = xl(pperitop);   %x-coordinate of the end of the top tube
Yend1 = yl(pperitop);   %y-coordinate of the end of the top tube

Xend2 = xl(pperitop);   %x-coordinate of the end of the bottom tube
Yend2 = yl(pperitop+pperibot);  %y-coordinate of the end of the bottom tube
Length = Lmax-Lmin;             %length of the domain

dx = (Length/GridSize);             %spatial grid size
i1 = floor((Xend1+(Length/2))/dx)   % column index of the first velocity we want to pull
j1 = floor((Yend1+(Length/2))/dx)   % row index of the first velocity we want to pull

i2 = floor((Xend2+(Length/2))/dx)   % column index of the last velocity
j2 = ceil((Yend2+(Length/2))/dx)    % row index of the last velocity

k=1;                %use for counting
Nl = j1-j2+1        %number of velocities pulled
umag=zeros(Nl,1);   % create vector to hold velocity magnitudes
VFlow = 0;          %zero the volumetric flow place holder
    
U0=Vinterp.U_x;     %smooth2a(Vinterp.U_x,2,2);
U1=Vinterp.U_y;     %smooth2a(Vinterp.U_y,2,2);

%Calculate all of the signed velocity magnitudes (positive is out of tube)
for j = j2:j1,
    umag(k) = umag(k)+sign(U0(j,i1))*sqrt(U0(j,i1)*U0(j,i1)+U1(j,i1)*U1(j,i1));
    k=k+1;
end
%calculate the maximum velocity
Umax = max(umag);

%The next lines determine the volumetric flow rate
for i = 1:Nl,
    VFlow = VFlow + umag(i);
end
VFlow = VFlow/Nl;
VFlow = VFlow/abs(Yend1-Yend2);

end

