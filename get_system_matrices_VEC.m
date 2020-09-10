function [K,M] = get_system_matrices_VEC(const)

N_ele_x = const.N_pix*const.N_ele; % Total number of elements along x direction
N_ele_y = const.N_pix*const.N_ele; % Total number of elements along y direction

if size(const.design,1)==1
    const.design = repmat(const.design,N_ele_x,N_ele_y);
end   

% [idx_x,idx_y] = meshgrid(1:N_ele_x,1:N_ele_y);
E = const.E_min + const.design(:,:,1).*(const.E_max - const.E_min);
nu = const.poisson_min + const.design(:,:,3).*(const.poisson_max - const.poisson_min);
t = const.t;
rho = const.rho_min + const.design(:,:,2).*(const.rho_max - const.rho_min);

nodenrs = reshape(1:(1+N_ele_x)*(1+N_ele_y),1+N_ele_y,1+N_ele_x);
edofVec = reshape(2*nodenrs(1:end-1,1:end-1)-1,N_ele_x*N_ele_y,1);
edofMat = repmat(edofVec,1,8)+repmat([2*(N_ele_y+1)+[0 1 2 3] 2 3 0 1],N_ele_x*N_ele_y,1);
row_idxs = reshape(kron(edofMat,ones(8,1))',64*N_ele_x*N_ele_y,1);
col_idxs = reshape(kron(edofMat,ones(1,8))',64*N_ele_x*N_ele_y,1);
AllLEle = get_element_stiffness_VEC(E(:),nu(:),t)';
AllLMat = get_element_mass_VEC(rho(:),t,const)';
value_K = AllLEle(:);
value_M = AllLMat(:);

K = sparse(row_idxs,col_idxs,value_K);
M = sparse(row_idxs,col_idxs,value_M);
%     K = K+K'; M = M+M';
end