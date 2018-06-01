function diffusion_c(delt,initial,diffusionrhsbc)

global D dx dy c 
global c_diff_matrix_l c_diff_matrix_u c_diff_RHS c_diff_matrix usegmres
global cplusx_dbc

NNx = size(c);
NNx = NNx(1);
NNy = size(c);
NNy = NNy(2);

if strcmp(diffusionrhsbc,'dirichlet') 
%dirichlet boundary conditions on rhs wall
     if (initial)
        %make the diffusion matrix    
        [c_diff_matrix,c_diff_matrix_u] = make_c_diffusion_matrix_noflux_noflux_dirichlet(delt);
     end
    
    %setting the RHS                                                                          
    cplusx = evaluate_plus(c,NNx,NNy,'dirichlet',1,1,0*c,cplusx_dbc); 
    cminusx = evaluate_minus(c,NNx,NNy,'noflux',1); 
    cplusy = evaluate_plus(c,NNx,NNy,'noflux',0);
    cminusy = evaluate_minus(c,NNx,NNy,'noflux',0);
    
    c_diff_RHS(1:NNx*NNy,1)=0; 
    %previous_c_vector(1:NNx*NNy,1)=0;

    for i=1:NNx-1
      for j=1:NNy
        c_diff_RHS(i+(j-1)*NNx,1)=(D*delt*(cplusx(i,j)-2*c(i,j)+cminusx(i,j))/dx^2/2)+ ...
            (D*delt*(cplusy(i,j)-2*c(i,j)+cminusy(i,j))/dy^2/2)+c(i,j);
        previous_c_vector(i+(j-1)*NNx,1) = c(i,j); 
      end 
    end 
    
    i=NNx; 
    for j=1:NNy
        c_diff_RHS(i+(j-1)*NNx,1)=(D*delt*(cplusx(i,j)-2*c(i,j)+cminusx(i,j))/dx^2/2)+ ...
            (D*delt*(cplusy(i,j)-2*c(i,j)+cminusy(i,j))/dy^2/2)+c(i,j)+(D*delt*cplusx_dbc/dx^2/2);
        previous_c_vector(i+(j-1)*NNx,1) = c(i,j); 
    end 
    
elseif strcmp(diffusionrhsbc,'noflux') 
%no flux bcs on rhs wall 
    if (initial)
        %make the diffusion matrix    
        'making diffusion matrix'
        [c_diff_matrix,c_diff_matrix_u] = make_c_diffusion_matrix_noflux_noflux(delt);
        %[c_diff_matrix] = make_c_diffusion_matrix_noflux_noflux(delt);
        'done making diffuion matrix' 
    end
    %c_diff_matrix_l = c_diff_matrix_u';

    %setting the RHS                                                                          
    cplusx = evaluate_plus(c,NNx,NNy,'noflux',1); 
    cminusx = evaluate_minus(c,NNx,NNy,'noflux',1); 
    cplusy = evaluate_plus(c,NNx,NNy,'noflux',0);
    cminusy = evaluate_minus(c,NNx,NNy,'noflux',0);
    % cplusx = evaluate_plus(c,NNx,NNy,'dirichlet',1); 
    % cminusx = evaluate_minus(c,NNx,NNy,'dirichlet',1); 
    % cplusy = evaluate_plus(c,NNx,NNy,'dirichlet',0);
    % cminusy = evaluate_minus(c,NNx,NNy,'dirichlet',0);
    % cplusx = evaluate_plus(C,NNx,NNy,'periodic',1); 
    % cminusx = evaluate_minus(C,NNx,NNy,'periodic',1); 
    % cplusy = evaluate_plus(C,NNx,NNy,'noflux',0);
    % cminusy = evaluate_minus(C,NNx,NNy,'noflux',0);

    c_diff_RHS(1:NNx*NNy,1)=0; 
    %previous_c_vector(1:NNx*NNy,1)=0;

    for i=1:NNx
      for j=1:NNy
        c_diff_RHS(i+(j-1)*NNx,1)=(D*delt*(cplusx(i,j)-2*c(i,j)+cminusx(i,j))/dx^2/2)+ ...
            (D*delt*(cplusy(i,j)-2*c(i,j)+cminusy(i,j))/dy^2/2)+c(i,j);
        previous_c_vector(i+(j-1)*NNx,1) = c(i,j); 
      end 
    end 

    %spmd
        %c_diff_matrix_parallel = codistributed(full(c_diff_matrix));
        %c_diff_RHS_parallel = codistributed(full(c_diff_RHS)); 
        %c_vector = c_diff_matrix\c_diff_RHS;
        %c_vector_parallel = c_diff_matrix_parallel\c_diff_RHS_parallel;
        %c_vector = gather(c_vector_parallel);
    %end
end


if (usegmres) 
    %GMRES
    c_vector = gmres(c_diff_matrix,c_diff_RHS,[],1e-12,1000,[],[],previous_c_vector);
else
    c_vector = c_diff_matrix_u\(c_diff_matrix\c_diff_RHS);
    %c_vector = c_diff_matrix\c_diff_RHS;
end


for j=1:NNy
  c(:,j)=c_vector((j-1)*NNx+1:j*NNx);
end 

function [c_diffusion_matrix_l,c_diffusion_matrix_u] = make_c_diffusion_matrix_periodic_noflux(delt)
    
global dx dy c D usegmres

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

%spmd 
%    c_diffusion_matrix_parallel=codistributed(full(c_diffusion_matrix));
%    [c_diffusion_matrix_l_parallel,c_diffusion_matrix_u_parallel] = lu(c_diffusion_matrix_parallel);
%    c_diffusion_matrix_l=gather(c_diffusion_matrix_l_parallel);
%    c_diffusion_matrix_u=gather(c_diffusion_matrix_u_parallel); 
%end

%might be able to use cholesky....see below
[c_diffusion_matrix_l,c_diffusion_matrix_u] = lu(c_diffusion_matrix);

function [c_diffusion_matrix,c_diffusion_matrix_u] = make_c_diffusion_matrix_noflux_noflux(delt)
%function [c_diffusion_matrix] = make_c_diffusion_matrix_noflux_noflux(delt)

global dx dy c D usegmres

%This matrix includes noflux boundary conditions in the
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
    sparse(diag([2;ones(NNx-2,1)]*-x_coeff,1)) + ...
    sparse(diag([ones(NNx-2,1);2]*-x_coeff,-1));

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
c_diffusion_matrix_u = 0; 

%spmd 
%    c_diffusion_matrix_parallel=codistributed(full(c_diffusion_matrix));
%    [c_diffusion_matrix_l_parallel,c_diffusion_matrix_u_parallel] = lu(c_diffusion_matrix_parallel);
%    c_diffusion_matrix_l=gather(c_diffusion_matrix_l_parallel);
%    c_diffusion_matrix_u=gather(c_diffusion_matrix_u_parallel); 
%end

if (~usegmres) 
    'conducting lu'
    [c_diffusion_matrix,c_diffusion_matrix_u] = lu(c_diffusion_matrix);
    'done conducting lu' 
end

function [c_diffusion_matrix,c_diffusion_matrix_u] = make_c_diffusion_matrix_noflux_noflux_dirichlet(delt)
%function [c_diffusion_matrix] = make_c_diffusion_matrix_noflux_noflux(delt)

global dx dy c D usegmres

%This matrix includes noflux boundary conditions in the
%x-direction on the left wall and dirichlet bcs on the right wall
%and noflux in the boundary conditions in the
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
    sparse(diag([2;ones(NNx-2,1)]*-x_coeff,1)) + ...
    sparse(diag([ones(NNx-2,1);1]*-x_coeff,-1));

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
c_diffusion_matrix_u = 0; 

%spmd 
%    c_diffusion_matrix_parallel=codistributed(full(c_diffusion_matrix));
%    [c_diffusion_matrix_l_parallel,c_diffusion_matrix_u_parallel] = lu(c_diffusion_matrix_parallel);
%    c_diffusion_matrix_l=gather(c_diffusion_matrix_l_parallel);
%    c_diffusion_matrix_u=gather(c_diffusion_matrix_u_parallel); 
%end

if (~usegmres) 
    [c_diffusion_matrix,c_diffusion_matrix_u] = lu(c_diffusion_matrix);
end

function [c_diffusion_matrix_u] = make_c_diffusion_matrix_dirichlet_dirichlet(delt)
    
global dx dy c D

%This matrix includes dirichlet boundary conditions (zero) in the x-direction 
%and dirichlet boundary conditions (zero) in the y-direction

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

BU(1:NNx,1) = 0; 
BU(NNx+1:NNx*NNy,1) = -y_coeff; 

BL(1:NNx*NNy-NNx,1) = -y_coeff; 
BL(NNx*NNy-NNx+1:NNx*NNy,1) = 0; 

C_dm_diag = []; 
for i=1:NNy
  C_dm_diag = blkdiag(C_dm_diag,A); 
end

C_dm_upper = spdiags(BU,NNx,NNx*NNy,NNx*NNy);
C_dm_lower = spdiags(BL,-NNx,NNx*NNy,NNx*NNy); 

c_diffusion_matrix = C_dm_diag + C_dm_upper + C_dm_lower; 

%spmd 
%    c_diffusion_matrix_parallel=codistributed(full(c_diffusion_matrix));
%    [c_diffusion_matrix_l_parallel,c_diffusion_matrix_u_parallel] = lu(c_diffusion_matrix_parallel);
%    c_diffusion_matrix_l=gather(c_diffusion_matrix_l_parallel);
%    c_diffusion_matrix_u=gather(c_diffusion_matrix_u_parallel); 
%end
[c_diffusion_matrix_u] = chol(c_diffusion_matrix);

