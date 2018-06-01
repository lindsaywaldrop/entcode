function diffusion_c(delt)

global D dx dy c 
global c_diff_matrix c_diff_RHS

NNx = size(c);
NNx = NNx(1);
NNy = size(c);
NNy = NNy(2);


%make the diffusion matrix                                                                
c_diff_matrix = make_c_diffusion_matrix(delt);

%setting the RHS                                                                          

cplusx = evaluate_plus(c,NNx,NNy,'periodic',1); 
cminusx = evaluate_minus(c,NNx,NNy,'periodic',1); 
cplusy = evaluate_plus(c,NNx,NNy,'noflux',0);
cminusy = evaluate_minus(c,NNx,NNy,'noflux',0);

c_diff_RHS(1:NNx*NNy,1)=0; 

for i=1:NNx
  for j=1:NNy
    c_diff_RHS(i+(j-1)*NNx,1)=(D*delt*(cplusx(i,j)-2*c(i,j)+cminusx(i,j))/dx^2/2)+ ...
        (D*delt*(cplusy(i,j)-2*c(i,j)+cminusy(i,j))/dy^2/2)+c(i,j);
  end 
end 

%spmd
    %c_diff_matrix_parallel = codistributed(full(c_diff_matrix));
    %c_diff_RHS_parallel = codistributed(full(c_diff_RHS)); 
    c_vector = c_diff_matrix\c_diff_RHS;
    %c_vector_parallel = c_diff_matrix_parallel\c_diff_RHS_parallel;
    %c_vector = gather(c_vector_parallel);
%end

for j=1:NNy
  c(:,j)=c_vector((j-1)*NNx+1:j*NNx);
end 

function c_diffusion_matrix = make_c_diffusion_matrix(delt)
    
global dx dy c D

%This matrix includes periodic boundary conditions in the
%x-direction and noflux in the boundary conditions in the
%y-direction

NNx = size(c);
NNx = NNx(1);
NNy = size(c);
NNy = NNy(2); 

c_diffusion_matrix = []; %sparse(NNx*NNy,NNx*NNy);

A = sparse(NNx,NNx); 

x_coeff=delt*D/2/dx^2;
y_coeff=delt*D/2/dy^2;

A = sparse(diag(ones(NNx,1)*(1+2*x_coeff+2*y_coeff))) + ...
    sparse(diag(ones(NNx-1,1)*-x_coeff,1)) + ...
    sparse(diag(ones(NNx-1,1)*-x_coeff,-1));
Acorners = sparse([1,NNx],[NNx,1],[-x_coeff, -x_coeff], NNx, NNx); 
A = A + Acorners; 

BU(1:NNx,1) = 0; 
BU(NNx+1:2*NNx,1) = -2*y_coeff; 
BU(2*NNx+1:NNx*NNy,1) = -y_coeff;

BL(1:NNx*NNy-2*NNx,1) = -y_coeff; 
BL(NNx*NNy-2*NNx+1:NNx*NNy-NNx,1) = -2*y_coeff;
BL(NNx*NNy-NNx+1:NNx*NNy,1) = 0; 

C_dm_diag = []; 
for i=1:NNy
  C_dm_diag = blkdiag(C_dm_diag,A); 
end

C_dm_upper = spdiags(BU,NNx,NNx*NNy,NNx*NNy);
C_dm_lower = spdiags(BL,-NNx,NNx*NNy,NNx*NNy); 

c_diffusion_matrix = C_dm_diag + C_dm_upper + C_dm_lower; 

