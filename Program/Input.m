function [CrossSection_DataSource, Surface_Sources_type, Spatial_distribution, Number_of_histories_test, Tallies] = Input()

%% data used by the solver

%% data used by the CrossSections. Here, we don't need to have the address, because we input the data manually
CrossSection_DataSource = 'HW';


%% Surface source type: boundary condition
Surface_Sources_type = 'Vacuum'; % can be chosen from 'Discrete', 'Isotropic_surface', 'Linear', 'Vacuum'

%% spatial distribution of materials

% % Condition for pure absorber
% Material = {'Pure Absorber'};
% Thickness = 100; % unit: cm
% Spatial_distribution = table(Material, Thickness);

% Condition for Problem 2
% Material = {'Absorber'};
% Thickness = 100; % unit: cm
% Spatial_distribution = table(Material, Thickness);

% % Condition for Problem 3
% Material    = cell(100,1);
% Material(:) = {'Scatterer'};
% Thickness = ones(100,1);
% Spatial_distribution = table(Material, Thickness);

% Condition for Problem 4
Material = {'Absorber';'Reflector';'Isotropic';'Scatterer';'Fuel';'Scatterer';'Isotropic';'Reflector';'Absorber'};
Thickness = [1    ;10    ;1     ;4     ;10     ;4       ;1     ;10    ;1]; % unit: cm
Spatial_distribution = table(Material, Thickness);

%% number of histories
Number_of_histories_test = [1000,10000,25000,50000,100000]; % can be modified to an array

%% location of tallies: manully input where and what you are interested % No use. Different tallies is calculated based on the HW requirement. But, the code can be modified later.
Tallies = {'Zeroth spatial moments of the scalar flux';
    'first spatial moments of the scalar flux';
    'current on the right surface'};

end
