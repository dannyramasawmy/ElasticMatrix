%% example_medium_class
%
% Author    :   Danny Ramasawmy
%               rmapdrr@ucl.ac.uk
%               dannyramasawmy@gmail.com
% Date      :   2019-01-25  -   created
%
%   This script will run through the different functionalities of the
%   Medium class. A Medium object contains the geometry information for the
%   multilayered structure as well as the material properties.
%
% =========================================================================
%   INTIALISE THE MEDIUM
% =========================================================================
% The medium class provides the geometry for the ElasticMAtrix class. 
cls;

% firstly, a list of predefined available materials can be seen by ...
Medium.availableMaterials;

% To add new materials, type <edit materialList.m > and follow the format
% that is given there. 
% Taking some of the materials from the printed list, the Medium class can
% now be initialised with the class constructor. This
% takes input arguments of the material, followed by its thickness in [m].

% initalise a 4 - layered medium
myMediumObject = Medium('water',Inf, 'glass',0.001, 'aluminium',0.001, 'air', Inf);
% print the medium to the command window
printLineBreaks
disp('The Medium object has been initialised')
myMediumObject.disp;

% note the printed table gives an index for the order of the material
% layers, the name, the thickness, the density and its state. Additionally
% the 4 - key stiffness matrix parameters are printed.

printLineBreaks;
% Note, the length(myMediumObject) is 4 ...
disp(['myMediumObject has a length of : ',num2str(length(myMediumObject))])
% ... The object can be indexed, where each index corresponds to the order
% of the layers when initalised. An individual layer can be viewed by
% choosing the appropriate index, for example to display the second layer..
disp('The properties of the second layer, >> myMediumObject(2)  ')
myMediumObject(2).disp;


% =========================================================================
%   SETTING DENSITY, THICKESS AND THE NAME OF INDIVIDUAL LAYERS
% =========================================================================

% The properties of a layer can be changed using the appropriate set
% function, this takes input arguments of the layer index followed by the
% property being altered. Some examples...

% change the density [kg/m^3] of the second layer
myMediumObject.setDensity( 2, 2400 );

% change the thickness [m] of the third layer
myMediumObject.setThickness( 3, 0.0015 );

% change the name of the first layer
myMediumObject.setName(1 , 'newWater');

% view the changes
printLineBreaks;
disp('View altered properties')
myMediumObject.disp;

% =========================================================================
%   CHANGING THE STIFFNESS MATRIX OF THE MEDIUM
% =========================================================================

% The stiffness coefficients of each layer are directly related to its
% soundspeeed (isotropic case). The Medium class uses the stiffness matrix
% for its calculations. However, for an isotropic case usually only
% soundspeeds or Lame constants are known. The Medium class provides two
% static functions to generate the related stiffness matrix.

% if only the compressional sound speed, shear speed and density are known
density = 2500;
compressionalSpeed = 5600;
shearSpeed = 3400;
% get the stiffness coefficient matrix
materialStiffnessMatrix = Medium.soundSpeedDensityConversion(...
    compressionalSpeed, shearSpeed, density);

% alternatively if only the Lame constants are known
lambda = 2.0600e+10;
mu = 2.8900e+10;
% get the stiffness coefficient matrix
materialStiffnessMatrix = myMediumObject.lameConversion(lambda, mu);

% The coeffients can then be used to update one of the material layers, for
% example to update the stiffness coefficients of layer 2
myMediumObject.setStiffnessMatrix(2, materialStiffnessMatrix);
% dont forget to update the density too
myMediumObject.setDensity(2, density);




