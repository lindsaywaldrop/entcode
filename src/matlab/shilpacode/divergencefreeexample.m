function divergencefreeexample()

clear all
close all

%divergencefree example

dx = 0.01; 
dy = 0.01; 

xlength = 2;
ylength = 3; 

x = 0:dx:2;
y = 0:dy:3;

[xpts,ypts] = ndgrid(x,y);

%example1
%bu = xpts + sin(2*pi*xpts/xlength);
%bv = -ypts + sin(2*pi*ypts/ylength); 
%example2 - integrability is not satisfied
bu = 3*xpts; 
bv = ypts; 

divu = divergence(xpts',ypts',bu',bv');
divu = divu'; 

%divuexact = 2*pi*cos(2*pi*xpts/xlength)/xlength + 2*pi*cos(2*pi*ypts/ylength)/ylength; 
divuexact = 4; 

'divergence error'
max(max((divu-divuexact)))

'integral of divergence'
intdivu = trapz(y,trapz(x,divu,1))
'neumannc'
%neumannc1 = intdivu/2/(xlength+ylength)
%neumannc2 = intdivu/2/(xlength+ylength)
%neumannc3 = intdivu/2/(xlength+ylength)
%neumannc4 = intdivu/2/(xlength+ylength)
neumannc1 = 0;
neumannc2 = 2*xlength; 
neumannc3 = 0; 
neumannc4 = 2*ylength;

intdivuexact = 4*xlength*ylength; 
'integral of divergence error'
intdivu - intdivuexact

pause

NNx = size(divu);
NNx = NNx(1);
NNy = size(divu);
NNy = NNy(2);
    
%assumes dx = dy 
[poisson_matrix_l,poisson_matrix_u,poisson_matrix] = make_poisson_matrix_noflux_noflux(divu,dx,dy);

%setting the RHS
divu_RHS(1:NNx*NNy,1)=0; 
for i=1:NNx
  for j=1:NNy
      divu_RHS(i+(j-1)*NNx,1)= divu(i,j);
  end
end
%allowing neumann bc to be a constant
for i=1:NNy 
    divu_RHS((i-1)*NNx+1)=divu_RHS((i-1)*NNx+1)-2*neumannc1/dx; 
    divu_RHS(i*NNx)=divu_RHS(i*NNx)-2*neumannc2/dx;;
end
for i=1:NNx
    divu_RHS(i) = divu_RHS(i)-2*neumannc3/dy;
    divu_RHS((NNy-1)*NNx+i) = divu_RHS((NNy-1)*NNx+i)-2*neumannc4/dy;
end

%choosing one point and seeting it - to deal with multiple solutions
%for phi
%divu_RHS(1,1) = -xlength/2/pi - ylength/2/pi;
divu_RHS(1,1) = 0;

%phi_vector = poisson_matrix_u\(poisson_matrix_l\divu_RHS);
phi_vector = poisson_matrix\divu_RHS;
    
for j=1:NNy
   phi(:,j)=phi_vector((j-1)*NNx+1:j*NNx);
   %phi2(:,j)=phi_vector((j-1)*NNx+1:j*NNx);
end 

%exactphi = (-xlength/2/pi)*cos(2*pi*xpts/xlength) + (-ylength/2/pi)*cos(2*pi*ypts/ylength); %+ xlength/2/pi + ylength/2/pi;
%exactphi = (xpts).^2 + (ypts).^2;
phierror = phi-exactphi; 
'phierror'
max(max(abs(phierror)))

figure(10)
mesh(xpts,ypts,divu)

figure(11)
mesh(xpts,ypts,phi)
 
%figure(12)
%mesh(xpts,ypts,phi2)

figure(13) 
mesh(xpts,ypts,phierror)

pause
    
%Note dphix = 0 on the left and right walls
%     dphiy = 0 on the top and bottom walls 
%phiplusx = zeros(NNx,NNy); 
%phiminusx = zeros(NNx,NNy); 
%phiplusy = zeros(NNx,NNy); 
%phiminusy = zeros(NNx,NNy);
%phiplusx(2:NNx-1,1:NNy) = phi(3:NNx,1:NNy); 
%phiminusx(2:NNx-1,1:NNy) = phi(1:NNx-2,1:NNy); 
%phiplusy(1:NNx,2:NNy-1) = phi(1:NNx,3:NNy);
%phiminusy(1:NNx,2:NNy-1) = phi(1:NNx:NNy-2); 
    
%dphix = (phiplusx - phiminusx)/2/dx;
%dphiy = (phiplusy - phiminusy)/2/dy;
    
[dphiy,dphix] = gradient(phi,dx,dy); 
%dphix(1,:) = 0;
%dphix(end,:) = 0;
%dphiy(:,1) = 0;
%dphiy(:,end) = 0; 

%exactdphix = sin(2*pi*xpts/xlength);
%exactdphiy = sin(2*pi*ypts/ylength); 
exactdphix = 2*xpts; 
exactdphiy = 2*ypts; 

'gradient of phi error'
max(max(abs(dphix - exactdphix)))
max(max(abs(dphiy - exactdphiy)))

figure(14)
mesh(xpts,ypts,dphix-exactdphix)

figure(15)
mesh(xpts,ypts,dphiy-exactdphiy)

figure(16)
mesh(xpts,ypts,dphix)

figure(17)
mesh(xpts,ypts,dphiy)

pause

und = bu - dphix;
vnd = bv - dphiy;

exactund = xpts;
exactvnd = -ypts; 

max(max(abs(und-exactund)))
max(max(abs(vnd-exactvnd)))

divufinal = divergence(xpts',ypts',und',vnd');
divufinal = divufinal';

figure(18) 
mesh(xpts,ypts,und-exactund)

figure(19)
mesh(xpts,ypts,vnd-exactvnd)

figure(20)
mesh(xpts,ypts,und)

figure(21)
mesh(xpts,ypts,vnd)
    
figure(22) 
mesh(xpts,ypts,divufinal)



%--------------------------------------------------------------------------

function [matrix_l,matrix_u,poisson_matrix] = make_poisson_matrix_noflux_noflux(divu,dx,dy)

%This matrix includes noflux boundary conditions in the
%x-direction and noflux in the boundary conditions in the
%y-direction

NNx = size(divu);
NNx = NNx(1);
NNy = size(divu);
NNy = NNy(2);

x_coeff=1/(dx^2);
y_coeff=1/(dy^2);

%x_coeff=1;
%y_coeff=1;

poisson_matrix = []; %sparse(NNx*NNy,NNx*NNy);

A = sparse(NNx,NNx); 

A = sparse(diag(ones(NNx,1)*-(2*x_coeff+2*y_coeff))) + ...
    sparse(diag([2;ones(NNx-2,1)]*x_coeff,1)) + ...
    sparse(diag([ones(NNx-2,1);2]*x_coeff,-1));

%full(A)

BU(1:NNx,1) = 0; 
BU(NNx+1:2*NNx,1) = 2*y_coeff; 
BU(2*NNx+1:NNx*NNy,1) = y_coeff;

BL(1:NNx*NNy-2*NNx,1) = y_coeff; 
BL(NNx*NNy-2*NNx+1:NNx*NNy-NNx,1) = 2*y_coeff;
BL(NNx*NNy-NNx+1:NNx*NNy,1) = 0; 

C_dm_diag = []; 
for i=1:NNy
  C_dm_diag = blkdiag(C_dm_diag,A); 
end

C_dm_upper = spdiags(BU,NNx,NNx*NNy,NNx*NNy);
C_dm_lower = spdiags(BL,-NNx,NNx*NNy,NNx*NNy); 

poisson_matrix = C_dm_diag + C_dm_upper + C_dm_lower;
%sets the first row to a fixed constant
%poisson_matrix(1,:) = 0;
%poisson_matrix(1,1) = 1; 

%full(poisson_matrix)

%[matrix_l,matrix_u] = lu(poisson_matrix);
matrix_l = 0;
matrix_u = 0; 

