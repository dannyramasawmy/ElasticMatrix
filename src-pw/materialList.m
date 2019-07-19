function all_materials = materialList()
%MATERIALLIST - Contains a list of predefined materials.
%
% DESCRIPTION
%   MATERIALLIST store a list of all the predefined materials that can be
%   used with the Medium class. Please add any new materials in the same
%   format seen below. The relevant properties are c (compressional speed)
%   [ms^-1], cs (shear speed) [ms^-1] and rho (density) [kgm^-3]. For
%   anisotropic materials store the 6X6 stiffness matrix (stiffnessMatrix).
%   However, in the current implementation of ElasticMAtrix only C(1,1),
%   C(1,3), C(3,3), C(4,4) and C(5,5) are used as these correspond to x_1
%   and x_3 coordinate axes. 
%
%   Possible states are:
%   'Unknown', 'Vacuum', 'Gas', 'Liquid', 'Isotropic', 'Anisotropic' These
%   states are taken into account when plotting slowness profiles, and in
%   future will be taken into account in the partial wave code execution.
%
%   To add any of Gas, Vacuum, Liquid, Isotropic materials:
%       allMaterialStruct.NAME.c                     =  ...      ;
%       allMaterialStruct.NAME.cs                    =  ...      ;
%           (set to 0.01 for Vacuum/Gas/Liquid)
%       allMaterialStruct.NAME.rho                   =  ...      ;
%       allMaterialStruct.NAME.state                 =  ...      ;
%
%   To add orthotropic, cubic, transverse isotropic or isotropic materials:
%       allMaterialStruct.NAME.rho                   =  ...      ;
%       allMaterialStruct.NAME.state                 =  'Anisotropic' ;
%       allMaterialStruct.NAME.stiffnessMatrix       =  [6 x 6 matrix];
%
% USEAGE
%   materialList;
%
% INPUTS
%   []                  - there are no inputs []
%
% OPTIONAL INPUTS
%   []                  - there are no optional inputs []
%
% OUTPUTS
%   all_materials       - a structure containing all of the materials []
%
% DEPENDENCIES
%   []              - there are no dependencies     []
%
% ABOUT
%   author          - Danny Ramasawmy
%   contact         - dannyramasawmy+elasticmatrix@gmail.com
%   date            - 01 - January  - 2019
%   last update     - 19 - July     - 2019
%
% This file is part of the ElasticMatrix toolbox.
% Copyright (c) 2019 Danny Ramasawmy.
%
% This file is part of ElasticMatrix. ElasticMatrix is free software:
% you can redistribute it and/or modify it under the terms of the GNU
% Lesser General Public License as published by the Free Software
% Foundation, either version 3 of the License, or (at your option) any
% later version.
%
% ElasticMatrix is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
% Lesser General Public License for more details.
%
% You should have received a copy of the GNU Lesser General Public
% License along with ElasticMatrix. If not, see
% <http://www.gnu.org/licenses/>.

% clearing step (if the list has been updated)
try
    clear('all_materials')
end

% =========================================================================
%   LIQUIDS / GASES / UNKNOWNS
% =========================================================================

% Blank ===================================================================
all_materials.blank.c                       =   1       ;
all_materials.blank.cs                      =   1       ;
all_materials.blank.rho                     =   1       ;
all_materials.blank.state                   = 'Unknown' ;

% vacuum ==================================================================
all_materials.vacuum.c                      = 0.01      ;
all_materials.vacuum.cs                     = 0.01      ;
all_materials.vacuum.rho                    = 0.01      ;
all_materials.vacuum.state                  = 'Vacuum'  ;

% Air =====================================================================
all_materials.air.c                         =   330     ;
all_materials.air.cs                        =   0.001   ;
all_materials.air.rho                       =   1       ;
all_materials.air.state                     = 'Gas'     ;

% Olive Oil ===============================================================
all_materials.olive_oil.c                   =   1440    ;
all_materials.olive_oil.cs                  =   0.001   ;
all_materials.olive_oil.rho                 =   860     ;
all_materials.olive_oil.state               = 'Liquid'  ;
% quoted 800-920 at ...
% http://www.engineeringtoolbox.com/liquids-densities-d_743.html

% water ===================================================================
all_materials.water.c                       =   1480    ;
all_materials.water.cs                      =   0.001   ;
all_materials.water.rho                     =   1000    ;
all_materials.water.state                   = 'Liquid'  ;

% iodine ==================================================================
all_materials.iodine.c                      =   2000    ;
all_materials.iodine.cs                     =   1       ;
all_materials.iodine.rho                    =   4940    ;
all_materials.iodine.state                  = 'Liquid'  ;

% =========================================================================
%   ISOTROPIC
% =========================================================================

% PET =====================================================================
all_materials.PET.c                         =   2200     ;
all_materials.PET.cs                        =   1000     ;
all_materials.PET.rho                       =   1350     ;
all_materials.PET.state                     = 'Isotropic';
%PET  %shear wave speed could be 800-1200 m/s)

% PVDF ====================================================================
all_materials.PVDF.c                        =   2250     ;
all_materials.PVDF.cs                       =   1410     ;
all_materials.PVDF.rho                      =   1780     ;
all_materials.PVDF.state                    = 'Isotropic';

% PVDF2 ===================================================================
% this is from Rose, Ultrasonic guided waves in solid media
all_materials.PVDF2.c                       =   2670     ;
all_materials.PVDF2.cs                      =   1120     ;
all_materials.PVDF2.rho                     =   1180     ;
all_materials.PVDF2.state                   = 'Isotropic';

% Glass ===================================================================
all_materials.glass.c                       =   5570     ;
all_materials.glass.cs                      =   3430     ;
all_materials.glass.rho                     =   2500     ;
all_materials.glass.state                   = 'Isotropic';
% from Rose, Ultrasonic guided waves in solid media

% Aluminium oxide =========================================================
all_materials.aluminium_oxide.c             =   10775       ;
all_materials.aluminium_oxide.cs            =   6414        ;
all_materials.aluminium_oxide.rho           =   3986        ;
all_materials.aluminium_oxide.state         = 'Isotropic'   ;

% Polycarbonate ===========================================================
all_materials.polycarbonate.c               =   2300     ;
all_materials.polycarbonate.cs              =   1100     ;
all_materials.polycarbonate.rho             =   1180     ;
all_materials.polycarbonate.state           = 'Isotropic';
% density could range between 900-1300

% borosillicate glass pryrex ==============================================
all_materials.borosilicate_glass_pyrex.c        =   5640        ;
all_materials.borosilicate_glass_pyrex.cs       =   3280        ;
all_materials.borosilicate_glass_pyrex.rho      =   2240        ;
all_materials.borosilicate_glass_pyrex.state    = 'Isotropic'   ;

% Epoxy Resin =============================================================
all_materials.epoxy_resin.c                =   2650     ;
all_materials.epoxy_resin.cs               =   1100     ;
all_materials.epoxy_resin.rho              =   1175     ;
all_materials.epoxy_resin.state            = 'Isotropic';

% Perspex =================================================================
all_materials.perspex.c                     =   2700        ;
all_materials.perspex.cs                    =   1330        ;
all_materials.perspex.rho                   =   1150        ;
all_materials.perspex.state                 = 'Isotropic'   ;

% PMMA ====================================================================
all_materials.PMMA.c                        =   2700        ;
all_materials.PMMA.cs                       =   1330        ;
all_materials.PMMA.rho                      =   1150        ;
all_materials.PMMA.state                    = 'Isotropic'   ;

% titanium ================================================================
all_materials.titanium.c                    =   6060        ;
all_materials.titanium.cs                   =   3230        ;
all_materials.titanium.rho                  =   4460        ;
all_materials.titanium.state                = 'Isotropic'   ;

% gold ====================================================================
all_materials.gold.c                        =   3240        ;
all_materials.gold.cs                       =   1182        ;
all_materials.gold.rho                      =   19300       ;
all_materials.gold.state                    = 'Isotropic'   ;

% protactinium ============================================================
all_materials.protactinium.c                =   3070        ;
all_materials.protactinium.cs               =   1           ;
all_materials.protactinium.rho              =   12023       ;
all_materials.protactinium.state            = 'Isotropic'   ;

% tungsten ================================================================
all_materials.tungsten.c                    =   5147        ;
all_materials.tungsten.cs                   =   2891        ;
all_materials.tungsten.rho                  =   19250       ;
all_materials.tungsten.state                = 'Isotropic'   ;

% tissue (flesh) ==========================================================
all_materials.tissue.c                      =   1578    ;
all_materials.tissue.cs                     =   0.01    ;
all_materials.tissue.rho                    =   1050    ;
all_materials.tissue.state                  = 'Liquid'  ;

% Aluminium ===============================================================
all_materials.aluminium.c                   =   6400        ;
all_materials.aluminium.cs                  =   3100        ;
all_materials.aluminium.rho                 =   2700        ;
all_materials.aluminium.state               = 'Isotropic'   ;

% Aluminium ==============================================================
% this is from Rose, Ultrasonic guided waves in solid media
all_materials.aluminium2.c                  =   6250;
all_materials.aluminium2.cs                 =   3100        ;
all_materials.aluminium2.rho                =   2700        ;
all_materials.aluminium2.state              = 'Isotropic'   ;

% steel ===================================================================
all_materials.steel1020.c                   =   5890        ;
all_materials.steel1020.cs                  =   3240        ;
all_materials.steel1020.rho                 =   7870        ;
all_materials.steel1020.state               = 'Isotropic'   ;

% TantPentox ==============================================================
% http://oa.upm.es/12630/1/INVE_MEM_2011_106857.pdf
%  mu = 69 Gpa; hence sqrt(69*10^9 / 8200)
all_materials.tantpentox.c                  =   5000        ;
all_materials.tantpentox.cs                 =   2900        ; % calculated
all_materials.tantpentox.rho                =   8200        ;
all_materials.tantpentox.state              = 'Isotropic'   ;

% silicondiox =============================================================
% mu = 27.9 GPa; hence  sqrt(27.9*10^9 / 2600)
all_materials.silicondiox2.c                =   5900        ;
all_materials.silicondiox2.cs               =   3300        ; % calculated
all_materials.silicondiox2.rho              =   2500        ;
all_materials.silicondiox2.state            = 'Isotropic'   ;

% Zirconium dioxide =======================================================
% wikipedia
all_materials.ZircDiox.c                    =   3000        ;
all_materials.ZircDiox.cs                   =   1500        ; % unknown
all_materials.ZircDiox.rho                  =   5680        ;
all_materials.ZircDiox.state                = 'Isotropic'   ;

% Silver ==================================================================
all_materials.silver.c                      =   3600        ;
all_materials.silver.cs                     =   1590        ;
all_materials.silver.rho                    =   10500       ;
all_materials.silver.state                  = 'Isotropic'   ;

% Nickel ==================================================================
all_materials.nickel.c                      =   5630        ;
all_materials.nickel.cs                     =   2960        ;
all_materials.nickel.rho                    =   8800        ;
all_materials.nickel.state                  = 'Isotropic'   ;

% copper ==================================================================
all_materials.copper.c                      =   4700        ;
all_materials.copper.cs                     =   2260        ;
all_materials.copper.rho                    =   8900        ;
all_materials.copper.state                  = 'Isotropic'   ;

% =========================================================================
%   ANISOTROPIC
% =========================================================================

% CubicInAs ===============================================================
% from Nayfeh - wave propagation in layered anisotropic media
% from Nayfeh - rotated at 0 degrees
all_materials.CubicInAs0.rho                =   5670        ;
all_materials.CubicInAs0.state              = 'Anisotropic' ;
all_materials.CubicInAs0.stiffnessMatrix    =  1.0e+09 *[...
    83.29         45.26       45.26       0           0           0;
    45.26       83.29         45.26       0           0           0;
    45.26       45.26       83.29         0           0           0;
    0           0           0           39.59       0           0;
    0           0           0           0           39.59       0;
    0           0           0           0           0           39.59];

% CubicInAs ===============================================================
% from Nayfeh - wave propagation in layered anisotropic media
% rotated at 45 degrees
all_materials.CubicInAs45.rho                =   5670    ;
all_materials.CubicInAs45.state              = 'Anisotropic'  ;
all_materials.CubicInAs45.stiffnessMatrix    =  1.0e+09 *[...
    103.86      24.68       45.26       0           0           0;
    24.68       103.86      45.26       0           0           0;
    45.26       45.26       83.29       0           0           0;
    0           0           0           39.59       0           0;
    0           0           0           0           19.01       0;
    0           0           0           0           0           39.59];

% beryl ===================================================================
% from I. Abubakar - free vibrations of a transversely isotropic plate
all_materials.beryl.rho                 =   2700        ;
all_materials.beryl.state               = 'Anisotropic' ;
all_materials.beryl.stiffnessMatrix     =  1.0e+09 *[...
    23.63      	6.61        6.61        0           0           0;
    6.61        23.63       6.61        0           0           0;
    6.61        6.61        26.94       0           0           0;
    0           0           0           1           0           0;
    0           0           0           0           6.53        0;
    0           0           0           0           0           1];

% apatitie ================================================================
% from PAYTON - elastic wave propagation in transversely isotropic media
all_materials.apatite.rho               =   2700         ; % unknown
all_materials.apatite.state             = 'Anisotropic'  ;
all_materials.apatite.stiffnessMatrix   =  1.0e+09 *[...
    16.7      	1.31        6.6         0           0           0;
    1.31        16.7        6.6         0           0           0;
    6.6         6.6         14.0        0           0           0;
    0           0           0           6.63        0           0;
    0           0           0           0           6.63        0;
    0           0           0           0           0           ( 16.7  -1.31)/2  ];

% beryl ===================================================================
% from PAYTON - elastic wave propagation in transversely isotropic media
all_materials.beryl2.rho                =   2700        ;
all_materials.beryl2.state              = 'Anisotropic' ;
all_materials.beryl2.stiffnessMatrix    =  1.0e+09 *[...
    28.2      	9.94        6.95        0           0           0;
    9.94        28.2        6.95        0           0           0;
    6.95        6.95        24.8        0           0           0;
    0           0           0           6.68        0           0;
    0           0           0           0           6.68        0;
    0           0           0           0           0           (28.2  -9.94)/2  ];

% zinc ====================================================================
% from PAYTON - elastic wave propagation in transversely isotropic media
all_materials.zinc.rho                  =   2700            ;
all_materials.zinc.state                = 'Anisotropic'     ;
all_materials.zinc.stiffnessMatrix      =  1.0e+09 *[...
    16.5      	3.1         5.0         0           0           0;
    3.1         16.5        5.0         0           0           0;
    5.0         5.0         6.2         0           0           0;
    0           0           0           3.96        0           0;
    0           0           0           0           3.96        0;
    0           0           0           0           0           (16.5  - 3.1)/2  ];

% zinc (rotated) ==========================================================
% from PAYTON - elastic wave propagation in transversely isotropic media
all_materials.zinc.rho                  =   2700            ;
all_materials.zinc.state                = 'Anisotropic'     ;
all_materials.zinc.stiffnessMatrix      =  1.0e+09 *[...
    6.2         5.0         5.0         0           0           0;
    5.0         16.5        3.1         0           0           0;
    5.0         3.1         16.5        0           0           0;
    0           0           0           3.96        0           0;
    0           0           0           0           3.96        0;
    0           0           0           0           0           (16.5  - 3.1)/2  ];

% graphite-expoxy =========================================================
% Nayfeh - Anisotropic layered media book
% allMaterialStruct.graphiteEpoxy.rho                =   1600    ;
% allMaterialStruct.graphiteEpoxy.state              = 'Anisotropic'  ;
% allMaterialStruct.graphiteEpoxy.stiffnessMatrix    =  1.0e+09 *[...
%     155.43      3.72        3.72        0           0           0;
%     3.72        16.34       3.72        0           0           0;
%     3.72        3.72        16.34       0           0           0;
%     0           0           0           7.48        0           0;
%     0           0           0           0           7.48        0;
%     0           0           0           0           0           7.48];

% allMaterialStruct.graphiteEpoxy.rho                =   1600    ;
% allMaterialStruct.graphiteEpoxy.state              = 'Anisotropic'  ;
% allMaterialStruct.graphiteEpoxy.stiffnessMatrix    =  1.0e+09 *[...
%     155.43      3.72        3.72        0           0           0;
%     3.72        16.34       4.96        0           0           0;
%     3.72        4.96        16.34       0           0           0;
%     0           0           0           3.37        0           0;
%     0           0           0           0           7.48        0;
%     0           0           0           0           0           7.48];

all_materials.graphiteEpoxy.rho                =   1600    ;
all_materials.graphiteEpoxy.state              = 'Anisotropic'  ;
all_materials.graphiteEpoxy.stiffnessMatrix    =  1.0e+09 *[...
    145.79      3.77        8.33        0           0           0;
    3.77        16.34       4.91        0           0           0;
    8.33        4.91        16.77       0           0           0;
    0           0           0           3.52        0           0;
    0           0           0           0           12.08        0;
    0           0           0           0           0           7.33];

all_materials.graphiteEpoxy.rho                =   1600    ;
all_materials.graphiteEpoxy.state              = 'Anisotropic'  ;
all_materials.graphiteEpoxy.stiffnessMatrix    =  1.0e+09 *[...
    145.79      8.33        3.77        0           0           0;
    8.33        16.77       4.91        0           0           0;
    3.77        4.91        16.34       0           0           0;
    0           0           0            7.33        0           0;
    0           0           0           0           7.33        0;
    0           0           0           0           0            7.33];

% GaAs ====================================================================
%  Nayfeh - wave propagation in layered anisotropic media
all_materials.GaAs.rho                  =   5307            ;
all_materials.GaAs.state                = 'Anisotropic'     ;
all_materials.GaAs.stiffnessMatrix      =  1.0e+09 *[...
    111.8       53.8        53.8        0           0           0;
    53.8        111.8       53.8        0           0           0;
    53.8        3.72        111.8       0           0           0;
    0           0           0           59.4        0           0;
    0           0           0           0           59.4        0;
    0           0           0           0           0           59.4];

% =========================================================================
%   FABRY-PEROT SPECIFIC
% =========================================================================

% parylene_C ==============================================================
all_materials.parylene_C.c                  =   2200     ;
all_materials.parylene_C.cs                 =   1100     ;
all_materials.parylene_C.rho                =   1180     ;
all_materials.parylene_C.state              = 'Isotropic';
% from Cox & Beard, 'The frequency-dependent directivity of a planar ...
% Fabry-Perot polymer film ultrasound sensor'

% comboHD dielectric Fabry-Perot mirrors ==================================
all_materials.comboHD.c                     =   4592.7      ;
all_materials.comboHD.cs                    =   2488.1      ;
all_materials.comboHD.rho                   =   3988.4      ;
all_materials.comboHD.state                 = 'Isotropic'   ;

% dielectric mirrors D6 Fabry-Perot sensor ================================
% this is an estimate of the dielectric mirrors for the D6 Fabry-Perot
% sensor
all_materials.comboD6.c                     =   5615        ;
all_materials.comboD6.cs                    =   2442        ;
all_materials.comboD6.rho                   =   4432        ;
all_materials.comboD6.state                 = 'Isotropic'   ;

% ZEONEX ==================================================================
% http://www.zeon.co.jp/content/200181690.pdf
% mu = 2.4 Gpa;  sqrt(2400*10^6 / 2525)
all_materials.ZEONEX.c                      =   2525        ;
all_materials.ZEONEX.cs                     =   974.93      ; % calculated
all_materials.ZEONEX.rho                    =   1010        ;
all_materials.ZEONEX.state                  = 'Isotropic'   ;

% parylene2 ===============================================================
% parylene properties are not well known
all_materials.parylene2.c                   =   2200        ;
all_materials.parylene2.cs                  =   1100        ;
all_materials.parylene2.rho                 =   1289        ;
all_materials.parylene2.state               = 'Isotropic'   ;

% Anisotropic Paryene estimate ============================================
all_materials.ParCA.rho                 =   1289         ;
all_materials.ParCA.state               = 'Anisotropic'  ;
all_materials.ParCA.stiffnessMatrix                =  1.0e+09 *[...
    6.2388    3.1194    3.1194*0.9      0           0           0;
    3.1194    6.2388    3.1194          0           0           0;
    3.1194    3.1194    6.2388*1.5      0           0           0;
    0         0         0               1.5597      0           0;
    0         0         0               0           1.5597*1.3  0;
    0         0         0               0           0           1.5597];