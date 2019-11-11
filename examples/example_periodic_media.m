%% Example: Periodic Media
% The Medium class overloads the times, mtimes and plus operators to help
% define large periodic structures.

%% Initialize a Medium Object
% Firstly define a Medium object with the 'unit cell' of the periodic
% structure. 
my_unit_cell = Medium('PMMA', 0.001, 'glass', 0.002);

% If we want 3 alternating layers of PMMA and glass:
my_periodic_structure = 3 * my_unit_cell;

% We can then use the plus operator to define the surrounding half-spaces:
my_medium = Medium('water',Inf) + my_periodic_structure + Medium('water',Inf);
my_medium.disp;
