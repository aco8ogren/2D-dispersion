function dk_eleddesign = get_element_stiffness_sensitivity(E,nu,t,const)
    % dof are [ u1 v1 u2 v2 u3 v3 u4 v4 ] (indexing starts with lower left
    % node and goes counterclockwise, as is standard in FEM)
    % ELEMENT INFORMATION: PLANE STRESS Q4 bilinear quad element full integration
    dk_eleddesign = (1/48)*t/(1-nu^2)*...
        [...
        [24-8*nu , 6*nu+6  , -12-4*nu, 18*nu-6 , -12+4*nu, -6*nu-6 , 8*nu    , -18*nu+6];
        [6*nu+6  , 24-8*nu , -18*nu+6, 8*nu    , -6*nu-6 , -12+4*nu, 18*nu-6 , -12-4*nu];
        [-12-4*nu, -18*nu+6, 24-8*nu , -6*nu-6 , 8*nu    , 18*nu-6 , -12+4*nu, 6*nu+6  ];
        [18*nu-6 , 8*nu    , -6*nu-6 , 24-8*nu , -18*nu+6, -12-4*nu, 6*nu+6  , -12+4*nu];
        [-12+4*nu, -6*nu-6 , 8*nu    , -18*nu+6, 24-8*nu , 6*nu+6  , -12-4*nu, 18*nu-6 ];
        [-6*nu-6 , -12+4*nu, 18*nu-6 , -12-4*nu, 6*nu+6  , 24-8*nu , -18*nu+6, 8*nu    ];
        [8*nu    , 18*nu-6 , -12+4*nu, 6*nu+6  , -12-4*nu, -18*nu+6, 24-8*nu , -6*nu-6 ];
        [-18*nu+6, -12-4*nu, 6*nu+6  , -12+4*nu, 18*nu-6 , 8*nu    , -6*nu-6 , 24-8*nu ]...
        ];
%     dk_eleddesign = cat(3,dk_eleddesign, zeros(size(dk_eleddesign)));

end