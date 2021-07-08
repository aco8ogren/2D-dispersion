function m_ele = get_element_mass(rho,t,const)
% node and goes counterclockwise, as is standard in FEM
% ELEMENT INFORMATION: Q4 bilinear quad element full integration


m = rho*t*(const.a/(const.N_ele*const.N_pix))^2; % total mass of this element

if const.Nod_dof == 2 %Plane stress PSV
    % dof are [ u1 v1 u2 v2 u3 v3 u4 v4 ] (indexing starts with lower left
    m_ele = (1/36)*m*...
        [...
        [4 0 2 0 1 0 2 0];
        [0 4 0 2 0 1 0 2];
        [2 0 4 0 2 0 1 0];
        [0 2 0 4 0 2 0 1];
        [1 0 2 0 4 0 2 0];
        [0 1 0 2 0 4 0 2];
        [2 0 1 0 2 0 4 0];
        [0 2 0 1 0 2 0 4]...
        ];
elseif const.Nod_dof == 1 % SH (out-of-plane shear)
    % dof are [ w1 w2 w3 w4 ] (indexing starts with lower left
    m_ele = m/36*...
    [[4, 2, 1, 2]; [2, 4, 2, 1]; [1, 2, 4, 2]; [2, 1, 2, 4]];
elseif const.Nod_dof == 3 % (PSV + SH)
    fprintf('Case not coded yet.')
    return
else
    fprintf('Number of degrees of freedom per node can only be 1, 2, or 3.')
    return
end
end