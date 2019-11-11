%% Example: Medium Class
% The Medium class is used to define the material properties and
% thickness of each layer. 

%% Initialize a Medium Object
% A Medium object is initialized by calling the class constructor with
% input arguments of the material name followed by its thickness. The
% thickness of the first and last layers are semi-infinite and their values
% should be set with the Inf keyword.

% To initialize a 4-layered geometry:
my_medium = Medium('water', Inf, 'blank', 0.001, ...
    'PVDF', 0.001, 'air', Inf);

% To display the object:
my_medium.disp; 

% Here, my_medium is an object array and every index in the object array
% corresponds to a different layer in the medium. In the current example
% my_medium(3) will return an object with the material properties and
% thickness associated with PVDF.
my_medium(3).disp;

% The `blank' argument can used for a material which is not predefined. The
% material properties and names can be set using their respective set
% functions. This is described in the following section.

%% Defining New Materials
% A list of predefined materials can be printed to screen using the static
% function:
Medium.availableMaterials;

% A new material can be added to the script materialList.m, if it has not
% been predefined.

%% Setting Material Properties
% The properties of a layer can be changed using the appropriate set
% function, this takes input arguments of the layer index followed by the
% property being altered.

% Change the density [kg/m^3] of the second layer:
my_medium.setDensity(2, 2400);

% Change the thickness [m] of the third layer:
my_medium.setThickness(3, 0.0015);

% Change the name of the first layer:
my_medium.setName(1, 'newName');

% Print the new properties:
my_medium.disp;

%% Setting the Stiffness Matrix
% The stiffness coefficients of a material are directly related to the bulk
% wave phase speed. The Medium class uses the stiffness matrix for its
% calculations, this allows transverse-isotropic materials to be defined.
% Usually for an isotropic material only sound-speeds or Lame constants are
% known. The Medium class provides two static functions to generate the
% related stiffness matrix.

% If the compressional sound speed, shear speed and density are known:
density = 2500;
compressional_speed = 5600;
shear_speed = 3400;

% The stiffness matrix:
stiffness_matrix_1 = Medium.soundSpeedDensityConversion(...
    compressional_speed, shear_speed, density);

% If only the Lame constants are known:
lambda = 2.0600e+10;
mu = 2.8900e+10;

% The stiffness matrix:
stiffness_matrix_2 = Medium.lameConversion(lambda, mu);

% Update the stiffness matrix of one of the layers:
my_medium.setStiffnessMatrix(2, stiffness_matrix_2);

% Remember to update the density too:
my_medium.setDensity(2, density);


