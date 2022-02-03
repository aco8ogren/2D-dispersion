function [K,M] = get_system_matrices_VEC(dispersion_computation)
    dcp = dispersion_computation.dispersion_computation_parameters;
    dvi = dispersion_computation.design_variable_interpreter;
    dv = dispersion_computation.design_variable;

    N_ele_x = dcp.N_pix(2)*dcp.N_ele; % Total number of elements along x direction
    N_ele_y = dcp.N_pix(1)*dcp.N_ele; % Total number of elements along y direction

    prop_names = {'E','rho','nu'};
    for prop_idx = 1:3
        prop_name = prop_names{prop_idx};
        dv.(prop_name) = repelem(dv.(prop_name),dcp.N_ele,dcp.N_ele,1);
    end

    nu = (dvi.nu_min + dv.nu.*(dvi.nu_max - dvi.nu_min))';
    t = dvi.thickness;
    if strcmp(dvi.design_variable_to_property_mapping,'linear')
        E = (dvi.E_min + dv.E.*(dvi.E_max - dvi.E_min))';
        rho = (dvi.rho_min + dv.rho.*(dvi.rho_max - dvi.rho_min))';
    elseif strcmp(dvi.design_variable_to_property_mapping,'exponential')
        E = exp(dv.E)';
        rho = exp(dv.rho)';
    else
        error('const.design_scale not recognized as log or linear')
    end

    element_length = (dvi.lattice_length/(dcp.N_ele(1)*dcp.N_pix(1)));
    
    nodenrs = reshape(1:(1+N_ele_x)*(1+N_ele_y),1+N_ele_y,1+N_ele_x); % node numbering in a grid
    edofVec = reshape(2*nodenrs(1:end-1,1:end-1)-1,N_ele_x*N_ele_y,1); % element degree of freedom (in a vector) (global labeling)
    edofMat = repmat(edofVec,1,8)+repmat([2*(N_ele_y+1)+[0 1 2 3] 2 3 0 1],N_ele_x*N_ele_y,1); %
    row_idxs = reshape(kron(edofMat,ones(8,1))',64*N_ele_x*N_ele_y,1);
    col_idxs = reshape(kron(edofMat,ones(1,8))',64*N_ele_x*N_ele_y,1);
    AllLEle = get_element_stiffness_VEC(E(:),nu(:),t)';
    AllLMat = get_element_mass_VEC(rho(:),t,element_length)';
    value_K = AllLEle(:);
    value_M = AllLMat(:);
    
    K = sparse(row_idxs,col_idxs,value_K);
    M = sparse(row_idxs,col_idxs,value_M);
end