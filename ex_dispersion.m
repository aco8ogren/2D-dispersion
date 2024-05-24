clear; close all;
% Compute dispersion relations of pre-defined unit cells loaded from a file

% Initialize
orig_cd = cd;
cd('C:\Users\alex\OneDrive - California Institute of Technology\Documents\Graduate\Research\2D-dispersion')
datetime_var = datetime;
mfilename_fullpath_var = mfilename('fullpath');
mfilename_var = mfilename;

% Define the unit cells as an array of size [N_pix(1) N_pix(2) 3 N_design]
design_path = "C:\Users\alex\OneDrive - California Institute of Technology\Documents\Graduate\Research\Shared with jag\MetaDesignsForAlex\MetaDesignsForAlex_41.mat";
% design_path = "C:\Users\alex\OneDrive - California Institute of Technology\Documents\Graduate\Research\Shared with jag\MetaDesignsForAlex\MetaDesignsForAlex_79.mat";
design_data = load(design_path);
designs_cell = design_data.MetaDesigns;
designs = cat(4,designs_cell{:});
designs = repmat(designs,1,1,3,1); % One pane for each of modulus, density, poisson
designs = 1 - designs; % My code uses opposite 0/1-->soft/stiff convention as you

% Set flags
isSaveOutput = false;
isSaveEigenvectors = true;
isProfile = true;

% Set some parameters
N_design = size(designs,4);

const.N_ele = 1; % number of elements along the side of each pixel (i.e. N_ele = 2 --> 4 elements per pixel, N_ele = 3 --> 9 elements per pixel)
const.N_pix = size(designs,1); % Currently still requires unit cell to have same number of pixels along each side I think
const.N_wv = [25 NaN]; const.N_wv(2) = ceil(const.N_wv(1)/2); % Used for full IBZ calculations. Defines number of wavevectors in each direction of the IBZ discretization.
const.N_k = []; % Used for IBZ contour calculations. Defines number of wavevectors along each segment of the IBZ contour.

const.N_eig = 6; % number of dispersion bands to comptue
const.sigma_eig = 1; % leave as 1, eigensolver looks for eigenvalues around this value. Unless material properties get crazy (super high density, super low modulus), this should work fine.
const.design_scale = 'linear'; % leave this as 'linear'
const.isUseGPU = false; % leave this as false
const.isUseImprovement = true; % leave this as true
const.isUseSecondImprovement = false; % leave this as false
const.isUseParallel = true; % leave this as true (parallelize dispersion loop, not structure loop)
const.isSaveEigenvectors = isSaveEigenvectors; % whether or not to save the eigenvectors

% Define material properties & unit cell size
const.a = 1; % [m], side length of the unit cell
const.E_min = 200e6; % [Pa]
const.E_max = 200e9; % [Pa]
const.rho_min = 8e2; % [kg/m^3]
const.rho_max = 8e3; % [kg/m^3]
const.poisson_min = 0; % [-]
const.poisson_max = .5; % [-]
const.t = 1; % Irrelevant parameter for dynamics, leave as 1.

% Set symmetry and wavevector parameters
const.symmetry_type = 'none'; IBZ_shape = 'rectangle'; num_tesselations = 1; % #TODO we are not currently leveraging symmetry to reduce computation time
const.wavevectors = get_IBZ_wavevectors(const.N_wv,const.a,const.symmetry_type,num_tesselations);

% Plot the wavevectors
fig = figure();
ax = axes(fig);
plot_wavevectors(const.wavevectors,ax)
xlabel(ax,'wavevector - x [1/m]')
ylabel(ax,'wavevector - y [1/m]')
title(ax,'wavevectors')
axis(ax,'padded')

% If profiling, view the results
if isProfile
    mpiprofile on
end

% If not saving, warn user
if ~isSaveOutput
    warning('isSaveOutput is set to false. Output will not be saved.')
end

% Plot a design
design_idx_to_plot = 1;
property_idx_to_plot = 1; % 1,2,3 --> modulus,density,poisson
cmap = 'gray';
fig = figure();
ax = axes(fig);
imagesc(ax,designs(:,:,property_idx_to_plot,design_idx_to_plot))
daspect(ax,[1 1 1])
ax.YDir = 'normal';
ax.Visible = 'off';
ax.XAxis.Label.Visible = 'on';
ax.YAxis.Label.Visible = 'on';
ax.Title.Visible = 'on';
colormap(ax,cmap);
xlabel(ax,'spatial coord - x')
ylabel(ax,'spatial coord - y')
title(ax,'a design')

%% Compute dispersion relation for each design
% Initialize storage
WAVEVECTOR_DATA = repmat(const.wavevectors,1,1,N_design);
EIGENVALUE_DATA = zeros(prod(const.N_wv),const.N_eig,N_design);
EIGENVECTOR_DATA = zeros(((const.N_pix*const.N_ele)^2)*2,prod(const.N_wv),const.N_eig,N_design);
ELASTIC_MODULUS_DATA = zeros(const.N_pix,const.N_pix,N_design);
DENSITY_DATA = zeros(const.N_pix,const.N_pix,N_design);
POISSON_DATA = zeros(const.N_pix,const.N_pix,N_design);

% Loop over designs
wb = waitbar(0,['Processing: 0/' num2str(N_design)]);
for design_idx = 1:N_design   
    % Assign the current design to const
    const.design = designs(:,:,:,design_idx);

    % Solve the dispersion problem
    [wv,fr,ev] = dispersion(const,const.wavevectors);
    EIGENVALUE_DATA(:,:,design_idx) = real(fr);
    if isSaveEigenvectors
        EIGENVECTOR_DATA(:,:,:,design_idx) = ev;
    end
    
    % Save the material properties
    ELASTIC_MODULUS_DATA(:,:,design_idx) = const.E_min + (const.E_max - const.E_min)*const.design(:,:,1);
    DENSITY_DATA(:,:,design_idx) = const.rho_min + (const.rho_max - const.rho_min)*const.design(:,:,2);
    POISSON_DATA(:,:,design_idx) = const.poisson_min + (const.poisson_max - const.poisson_min)*const.design(:,:,3);

    % Increment waitbar
    waitbar(design_idx/N_design,wb,['Processing: ' num2str(design_idx) '/' num2str(N_design)])
end
close(wb);

if isProfile
    mpiprofile viewer
end

% Plot a dispersion relation
design_idx_to_plot = 1;
eig_idx_to_plot = 1;
fig = figure();
ax = axes(fig);
X = const.wavevectors(:,1);
Y = const.wavevectors(:,2);
Z = reshape(EIGENVALUE_DATA(:,eig_idx_to_plot,design_idx_to_plot),flip(const.N_wv));
imagesc(ax,X,Y,Z)
ax.YDir = 'normal';
daspect(ax,[1 1 1])
xlabel(ax,'wavevector - x')
ylabel(ax,'wavevector - y')
title(ax,'a dispersion relation')

% Launch the mode plotter
design_idx_to_plot = 1;
wv = WAVEVECTOR_DATA(:,:,design_idx_to_plot);
fr = EIGENVALUE_DATA(:,:,design_idx_to_plot);
ev = EIGENVECTOR_DATA(:,:,:,design_idx_to_plot);
plot_mode_ui(wv,fr,ev,const)

%% Set up save locations
script_start_time = replace(char(datetime_var),':','-');
if isSaveOutput
    output_folder = ['OUTPUT/output ' script_start_time];
    mkdir(output_folder);
    copyfile([mfilename_fullpath_var '.m'],[output_folder '/' mfilename_var '.m']);
end

%% Save the results
vars_to_save = {'WAVEVECTOR_DATA','EIGENVALUE_DATA','CONSTITUTIVE_DATA','const','designs','N_design'};
if isSaveEigenvectors
    vars_to_save{end+1} = 'EIGENVECTOR_DATA';
end
if isSaveOutput
    CONSTITUTIVE_DATA = containers.Map({'modulus','density','poisson'},...
        {ELASTIC_MODULUS_DATA, DENSITY_DATA, POISSON_DATA});
    output_file_path = [output_folder '/DATA' ...
        ' N_pix' num2str(const.N_pix) 'x' num2str(const.N_pix)...
        ' N_ele' num2str(const.N_ele) 'x' num2str(const.N_ele)...
        ' N_wv' num2str(const.N_wv(1)) 'x' num2str(const.N_wv(2))...
        ' N_design' num2str(N_design)...
        ' N_eig' num2str(const.N_eig)...
        ' ' script_start_time '.mat'];
    
        save(output_file_path,vars_to_save{:},'-v7.3');
end

% Go back to the directory you started in
cd(orig_cd)
