%% materialList v1 date:  2019-01-15
%
%   Author
%   Danny Ramasawmy
%   rmapdrr@ucl.ac.uk
%
%   Description
%   Stores the list of all the materials needed for the fabry perot sensor.
%   Please add any new materials in the same format seen below. The relevant
%   properties are c (compressional speed) [ms^-1], cs (shear speed) [ms^-1] 
%   and rho (density) [kgm^-3]. For anisotropic materials store the 6X6
%   stiffness matrix (cMat), however currently only C(1,1), C(1,3), C(3,3)
%   and C(5,5) are used as these correspond to x_1 and x_3 coordinates.


% clearing step (to check incase list has been updated)
try
    clear('materialtV')
end

allMaterialStruct.vacuum.c                     = 0.01      ;
allMaterialStruct.vacuum.cs                    = 0.01      ;
allMaterialStruct.vacuum.rho                   = 0.01      ;

% generates a temporary material variable materialtV

% Olive Oil ==================================
allMaterialStruct.olive_oil.c                  =   1440    ; 
allMaterialStruct.olive_oil.cs                 =   0.001   ; 
allMaterialStruct.olive_oil.rho                =   860     ; 
% % quoted 800-920 at http://www.engineeringtoolbox.com/liquids-densities-d_743.html

% NOA81 ======================================
allMaterialStruct.NOA81.c                      =   2200    ; 
allMaterialStruct.NOA81.cs                     =   1100    ; 
allMaterialStruct.NOA81.rho                    =   1180    ; %water
% % currently a copy of parylene, not correct

% water ======================================
allMaterialStruct.water.c                      =   1480    ; 
allMaterialStruct.water.cs                     =   0.001   ; 
allMaterialStruct.water.rho                    =   1000    ; %water

% parylene_C =================================
allMaterialStruct.parylene_C.c                 =   2200    ; 
allMaterialStruct.parylene_C.cs                =   1100    ; 
allMaterialStruct.parylene_C.rho               =   1180    ; %parylene C

% PET =======================================
allMaterialStruct.PET.c                        =   2200    ; 
allMaterialStruct.PET.cs                       =   1000    ; 
allMaterialStruct.PET.rho                      =   1350    ; 
%PET  %shear wave speed could be 800-1200 m/s)

% PVDF ======================================
allMaterialStruct.PVDF.c                       =   2250    ; 
allMaterialStruct.PVDF.cs                      =   1410    ; 
allMaterialStruct.PVDF.rho                     =   1780    ; %PVDF
 
% Glass =====================================
allMaterialStruct.glass.c                      =   5570    ; 
allMaterialStruct.glass.cs                     =   3430    ; 
allMaterialStruct.glass.rho                    =   2500    ; %glass
% from Rose textbook
% Aluminium oxide ==========================
allMaterialStruct.aluminium_oxide.c            =   10775   ; 
allMaterialStruct.aluminium_oxide.cs           =   6414    ; 
allMaterialStruct.aluminium_oxide.rho          =   3986    ; %aluminium oxide

% Polycarbonate 1 ==========================
allMaterialStruct.polycarbonate_1.c            =   2300    ; 
allMaterialStruct.polycarbonate_1.cs           =   1390    ; 
allMaterialStruct.polycarbonate_1.rho          =   1180    ; %polycarbonate 1.

% Polycarbonate 2 ==========================
allMaterialStruct.polycarbonate_2.c            =   2300    ; 
allMaterialStruct.polycarbonate_2.cs           =   900     ; 
allMaterialStruct.polycarbonate_2.rho          =   1180    ; %polycarbonate 2.

% borosillicate glass pryrex ===============
allMaterialStruct.borosilicate_glass_pyrex.c   =   5640    ; 
allMaterialStruct.borosilicate_glass_pyrex.cs  =   3280    ; 
allMaterialStruct.borosilicate_glass_pyrex.rho =   2240    ; %borosilicate glass (pyrex)

% Epoxy Resin ==============================
allMaterialStruct.epoxy_resin.c                =   2650    ; 
allMaterialStruct.epoxy_resin.cs               =   1100    ; 
allMaterialStruct.epoxy_resin.rho              =   1175    ;   %epoxy resin

% Perspex =================================
allMaterialStruct.perspex.c                    =   2700    ; 
allMaterialStruct.perspex.cs                   =   1330    ; 
allMaterialStruct.perspex.rho                  =   1150    ; %perspex

% PMMA ====================================
allMaterialStruct.PMMA.c                       =   2700    ; 
allMaterialStruct.PMMA.cs                      =   1330    ; 
allMaterialStruct.PMMA.rho                     =   1150    ; %perspex

% Blank ===================================
allMaterialStruct.blank.c                      =   1       ;  
allMaterialStruct.blank.cs                     =   1       ;   
allMaterialStruct.blank.rho                    =   1       ;

% titanium ================================
allMaterialStruct.titanium.c                   =   4140    ;  
allMaterialStruct.titanium.cs                  =   3124    ;   
allMaterialStruct.titanium.rho                 =   4507    ;

% gold ====================================
allMaterialStruct.gold.c                       =   1740    ;  
allMaterialStruct.gold.cs                      =   1182    ;   
allMaterialStruct.gold.rho                     =   19300   ;

% gold 2 ==================================
allMaterialStruct.gold2.c                      =   3240    ;  
allMaterialStruct.gold2.cs                     =   1182    ;   
allMaterialStruct.gold2.rho                    =   19300   ;

% iodine ==================================
allMaterialStruct.iodine.c                     =   2000    ;  
allMaterialStruct.iodine.cs                    =   1       ;   
allMaterialStruct.iodine.rho                   =   4940    ;
 
% protactinium ============================
allMaterialStruct.protactinium.c               =   3070    ;  
allMaterialStruct.protactinium.cs              =   1       ;   
allMaterialStruct.protactinium.rho             =   12023   ;

% tungsten ================================
allMaterialStruct.tungsten.c                   =   5147    ;  
allMaterialStruct.tungsten.cs                  =   2891    ;   
allMaterialStruct.tungsten.rho                 =   19250   ;

% tissue ==================================
allMaterialStruct.tissue.c                     =   1578    ;  
allMaterialStruct.tissue.cs                    =   0.001   ; 
allMaterialStruct.tissue.rho                   =   1050    ;

% aluminium ===============================
allMaterialStruct.aluminium.c                  =   6400    ; 
allMaterialStruct.aluminium.cs                 =   3100    ; 
allMaterialStruct.aluminium.rho                =   2700    ;

% steel ===================================
allMaterialStruct.steel1020.c                  =   5890    ; 
allMaterialStruct.steel1020.cs                 =   3240    ; 
allMaterialStruct.steel1020.rho                =   7870    ;

% TantPentox ===================================      % German Sensor?
% http://oa.upm.es/12630/1/INVE_MEM_2011_106857.pdf
allMaterialStruct.tantpentox.c                 =   5000    ;
allMaterialStruct.tantpentox.cs                =   2900    ;   % calculates
allMaterialStruct.tantpentox.rho               =   8200    ;
%  mu = 69 Gpa; hence sqrt(69*10^9 / 8200)

% silicondiox ===================================   % German Sensor
% http://oa.upm.es/12630/1/INVE_MEM_2011_106857.pdf
allMaterialStruct.silicondiox.c                =   6000    ;
allMaterialStruct.silicondiox.cs               =   2156    ;   % calculated
allMaterialStruct.silicondiox.rho              =   2200    ;
% mu = 27.9 GPa; hence  sqrt(27.9*10^9 / 6000) *** THIS IS A MISTAKE
% disp('Mistake in Silicondiox use Silicondioxide 2')

% silicondiox ===================================   % German Sensor
% 
allMaterialStruct.silicondiox2.c                =   5900    ;
allMaterialStruct.silicondiox2.cs               =   3300    ;   % calculated
allMaterialStruct.silicondiox2.rho              =   2500    ;
% mu = 27.9 GPa; hence  sqrt(27.9*10^9 / 2600)

% parylene2 ===================================     % German Sensor
allMaterialStruct.parylene2.c                  =   2200    ;
allMaterialStruct.parylene2.cs                 =   1100    ;
allMaterialStruct.parylene2.rho                =   1289    ;

% ZEONEX =====================================      % German Sensor
% http://www.zeon.co.jp/content/200181690.pdf
allMaterialStruct.ZEONEX.c                     =   2525    ;
allMaterialStruct.ZEONEX.cs                    =   974.93  ;   % calculated
allMaterialStruct.ZEONEX.rho                   =   1010    ;
% mu = 2.4 Gpa;  sqrt(2400*10^6 / 2525)

% Zirconium dioxide ===========================      % Hard Die Sensor
% wikipedia
allMaterialStruct.ZircDiox.c                     =   3000  ;
allMaterialStruct.ZircDiox.cs                    =   1500  ;   % guess
allMaterialStruct.ZircDiox.rho                   =   5680  ;

% paryleneOptim
allMaterialStruct.paryleneOptim.c                =   3300  ; % 3300 3250
allMaterialStruct.paryleneOptim.cs               =   1400  ;   % 1500 guess
allMaterialStruct.paryleneOptim.rho              =   1300  ;
allMaterialStruct.paryleneOptim.alpha_L          =   0.2   ;   % Nepers/wavelength
allMaterialStruct.paryleneOptim.alpha_T          =   0     ;   
% materialtV.paryleneOptim = materialtV.parylene_C; disp('Check Material List')

% dielectirc mirrors D6 sensor - specific / combination of dielectric
allMaterialStruct.comboD6.c                      =   5615  ;
allMaterialStruct.comboD6.cs                     =   2442  ;
allMaterialStruct.comboD6.rho                    =   4432  ;  

% Silver
allMaterialStruct.silver.c                      =   3600  ;
allMaterialStruct.silver.cs                     =   1590  ;
allMaterialStruct.silver.rho                    =   10500 ;  

% Nickel
allMaterialStruct.nickel.c                      =   5630  ;
allMaterialStruct.nickel.cs                     =   2960  ;
allMaterialStruct.nickel.rho                    =   8800  ;  

% copper
allMaterialStruct.copper.c                      =   4700  ;
allMaterialStruct.copper.cs                     =   2260  ;
allMaterialStruct.copper.rho                    =   8900  ;  

% comboHD / Ellys Sensor
allMaterialStruct.comboHD.c                      =   4592.7  ;
allMaterialStruct.comboHD.cs                     =   2488.1  ;
allMaterialStruct.comboHD.rho                    =   3988.4  ; 

% Air /Rose
allMaterialStruct.air.c                      =   330   ;
allMaterialStruct.air.cs                     =   0.001 ;
allMaterialStruct.air.rho                    =   1   ; 

% Air /Rose
allMaterialStruct.test.c                      =   330   ;
allMaterialStruct.test.cs                     =   0.001 ;
allMaterialStruct.test.rho                    =   1   ; 
% materialtV.test.cMat = ...
%     [1 1 1 0 0 0 ;
%     1 1 1 0 0 0;
%     1 1 1 0 0 0;
%     0 0 0 1 0 0;
%     0 0 0 0 1 0;
%     0 0 0 0 0 1];
% materialtV.ParCA.c                      =   330   ;
% materialtV.ParCA.cs                     =   0.001 ;
allMaterialStruct.ParCA.rho                =   1289    ;
allMaterialStruct.ParCA.cMat    =  1.0e+09 *[...
    6.2388    3.1194    3.1194*0.9      0           0           0;
    3.1194    6.2388    3.1194          0           0           0;
    3.1194    3.1194    6.2388*1.5      0           0           0;
    0         0         0               1.5597      0           0;
    0         0         0               0           1.5597*1.3  0;
    0         0         0               0           0           1.5597];


% Nayfeh - CubicInAs
allMaterialStruct.CubicInAs0.rho                =   5670    ;
allMaterialStruct.CubicInAs0.cMat    =  1.0e+09 *[...
    124       45.26       45.26       0           0           0;
    45.26       124       45.26       0           0           0;
    45.26       45.26       124       0           0           0;
    0           0           0           39.59       0           0;
    0           0           0           0           39.59       0;
    0           0           0           0           0           39.59];
% Nayfeh - CubicInAs
allMaterialStruct.CubicInAs45.rho                =   5670    ;
allMaterialStruct.CubicInAs45.cMat    =  1.0e+09 *[...
    103.86      24.68       45.26       0           0           0;
    24.68       103.86      45.26       0           0           0;
    45.26       45.26       83.29       0           0           0;
    0           0           0           39.59       0           0;
    0           0           0           0           19.01       0;
    0           0           0           0           0           39.59];
% beryl - I. Abubakar - free vibrations of a transversely isotropic plate
allMaterialStruct.beryl.rho                =   2700    ;
allMaterialStruct.beryl.cMat    =  1.0e+09 *[...
    23.63      	6.61           6.61        0           0           0;
    6.61           23.63       6.61           0           0           0;
    6.61        6.61           26.94       0           0           0;
    0           0           0           1           0           0;
    0           0           0           0           6.53        0;
    0           0           0           0           0           1];

% from PAYTON
allMaterialStruct.apatite.rho                =   2700    ; % unknown density
allMaterialStruct.apatite.cMat    =  1.0e+09 *[...
    16.7      	1.31       6.6        0           0           0;
    1.31        16.7       6.6           0           0           0;
    6.6        6.6         14.0       0           0           0;
    0           0           0           6.63           0           0;
    0           0           0           0           6.63        0;
    0           0           0           0           0           ( 16.7  -1.31)/2  ];
% from PAYTON
allMaterialStruct.beryl2.rho                =   2700    ;
allMaterialStruct.beryl2.cMat    =  1.0e+09 *[...
    28.2      	9.94       6.95        0           0           0;
    9.94        28.2       6.95           0           0           0;
    6.95        6.95       24.8       0           0           0;
    0           0           0           6.68           0           0;
    0           0           0           0           6.68        0;
    0           0           0           0           0           (28.2  -9.94)/2  ];
% from Zinc
allMaterialStruct.zinc.rho                =   2700    ;
allMaterialStruct.zinc.cMat    =  1.0e+09 *[...
    16.5      	3.1       5.0        0           0           0;
    3.1        16.5       5.0           0           0           0;
    5.0        5.0        6.2       0           0           0;
    0           0           0           3.96           0           0;
    0           0           0           0           3.96        0;
    0           0           0           0           0           (16.5  - 3.1)/2  ];

% from Zinc (rotated properties)
allMaterialStruct.zinc.rho                =   2700    ;
allMaterialStruct.zinc.cMat    =  1.0e+09 *[...
    6.2        5.0       5.0        0           0           0;
    5.0        16.5       3.1           0           0           0;
    5.0        3.1        16.5      0           0           0;
    0           0           0           3.96           0           0;
    0           0           0           0           3.96        0;
    0           0           0           0           0           (16.5  - 3.1)/2  ];

% graphite-expoxy - Nayfeh - Anisotropic layered media book
allMaterialStruct.graphiteEpoxy.rho                =   1600    ;
allMaterialStruct.graphiteEpoxy.cMat    =  1.0e+09 *[...
    155.43      3.72        3.72        0           0           0;
    3.72        16.34       3.72        0           0           0;
    3.72        3.72        16.34       0           0           0;
    0           0           0           7.48        0           0;
    0           0           0           0           7.48        0;
    0           0           0           0           0           7.48];

% graphite-expoxy - Nayfeh - Anisotropic layered media book
allMaterialStruct.GaAs.rho                =   5307    ;
allMaterialStruct.GaAs.cMat    =  1.0e+09 *[...
    111.8       53.8        53.8        0           0           0;
    53.8        111.8       53.8        0           0           0;
    53.8        3.72        111.8       0           0           0;
    0           0           0           59.4        0           0;
    0           0           0           0           59.4        0;
    0           0           0           0           0           59.4];

