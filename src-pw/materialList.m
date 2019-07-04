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
%
%   Possible states are:
%   'Unknown', 'Vacuum', 'Gas', 'Liquid', 'Isotropic', 'Anisotropic'
%   These states are taken into account when plotting slowness profiles,
%   and in future will be taken into account in the partial wave code execution.
%
%   % to add Gas/Vacuum/Liqud/Isotropic materials
%   allMaterialStruct.NAME.c                     =  ...      ;
%   allMaterialStruct.NAME.cs                    =  ...  (set to 0.01 for Vacuum/Gas/Liquid ;
%   allMaterialStruct.NAME.rho                   =  ...      ;
%   allMaterialStruct.NAME.state                 =  ...      ; 
%
%   % to add orthotropic/transverse isotropic materials
%   allMaterialStruct.NAME.rho                   =  ...      ;
%   allMaterialStruct.NAME.state                 =  'Anisotropic'      ; 
%   allMaterialStruct.NAME.cMat                  =  [6 x 6 matrix]      ;

% clearing step (if the list has been updated)
try
    clear('materialtV')
end

% =========================================================================
%   LIQUIDS / GASES / UNKNOWNS
% =========================================================================

% Blank ===================================================================
allMaterialStruct.blank.c                       =   1       ;  
allMaterialStruct.blank.cs                      =   1       ;   
allMaterialStruct.blank.rho                     =   1       ;
allMaterialStruct.blank.state                   = 'Unknown' ;

% vacuum ==================================================================
allMaterialStruct.vacuum.c                      = 0.01      ;
allMaterialStruct.vacuum.cs                     = 0.01      ;
allMaterialStruct.vacuum.rho                    = 0.01      ;
allMaterialStruct.vacuum.state                  = 'Vacuum'  ;  

% Air =====================================================================
allMaterialStruct.air.c                         =   330     ;
allMaterialStruct.air.cs                        =   0.001   ;
allMaterialStruct.air.rho                       =   1       ; 
allMaterialStruct.air.state                     = 'Gas'     ;

% Olive Oil ===============================================================
allMaterialStruct.olive_oil.c                   =   1440    ; 
allMaterialStruct.olive_oil.cs                  =   0.001   ; 
allMaterialStruct.olive_oil.rho                 =   860     ;
allMaterialStruct.olive_oil.state               = 'Liquid'  ;
% quoted 800-920 at ...
% http://www.engineeringtoolbox.com/liquids-densities-d_743.html

% water ===================================================================
allMaterialStruct.water.c                       =   1480    ; 
allMaterialStruct.water.cs                      =   0.001   ; 
allMaterialStruct.water.rho                     =   1000    ; 
allMaterialStruct.water.state                   = 'Liquid'  ;

% iodine ==================================================================
allMaterialStruct.iodine.c                      =   2000    ;  
allMaterialStruct.iodine.cs                     =   1       ;   
allMaterialStruct.iodine.rho                    =   4940    ;
allMaterialStruct.iodine.state                  = 'Liquid'  ;

% =========================================================================
%   ISOTROPIC
% =========================================================================

% PET =====================================================================
allMaterialStruct.PET.c                         =   2200     ; 
allMaterialStruct.PET.cs                        =   1000     ; 
allMaterialStruct.PET.rho                       =   1350     ; 
allMaterialStruct.PET.state                     = 'Isotropic';
%PET  %shear wave speed could be 800-1200 m/s)

% PVDF ====================================================================
allMaterialStruct.PVDF.c                        =   2250     ; 
allMaterialStruct.PVDF.cs                       =   1410     ; 
allMaterialStruct.PVDF.rho                      =   1780     ; 
allMaterialStruct.PVDF.state                    = 'Isotropic';

% Glass ===================================================================
allMaterialStruct.glass.c                       =   5570     ; 
allMaterialStruct.glass.cs                      =   3430     ; 
allMaterialStruct.glass.rho                     =   2500     ; 
allMaterialStruct.glass.state                   = 'Isotropic';
% from Rose, Ultrasonic guided waves in solid media

% Aluminium oxide =========================================================
allMaterialStruct.aluminium_oxide.c             =   10775       ; 
allMaterialStruct.aluminium_oxide.cs            =   6414        ; 
allMaterialStruct.aluminium_oxide.rho           =   3986        ; 
allMaterialStruct.aluminium_oxide.state         = 'Isotropic'   ;

% Polycarbonate ===========================================================
allMaterialStruct.polycarbonate.c               =   2300     ; 
allMaterialStruct.polycarbonate.cs              =   1100     ; 
allMaterialStruct.polycarbonate.rho             =   1180     ; 
allMaterialStruct.polycarbonate.state           = 'Isotropic';
% density could range between 900-1300

% borosillicate glass pryrex ==============================================
allMaterialStruct.borosilicate_glass_pyrex.c        =   5640        ; 
allMaterialStruct.borosilicate_glass_pyrex.cs       =   3280        ; 
allMaterialStruct.borosilicate_glass_pyrex.rho      =   2240        ; 
allMaterialStruct.borosilicate_glass_pyrex.state    = 'Isotropic'   ;

% Epoxy Resin =============================================================
allMaterialStruct.epoxy_resin.c                =   2650     ; 
allMaterialStruct.epoxy_resin.cs               =   1100     ; 
allMaterialStruct.epoxy_resin.rho              =   1175     ;  
allMaterialStruct.epoxy_resin.state            = 'Isotropic';

% Perspex =================================================================
allMaterialStruct.perspex.c                     =   2700        ; 
allMaterialStruct.perspex.cs                    =   1330        ; 
allMaterialStruct.perspex.rho                   =   1150        ;          
allMaterialStruct.perspex.state                 = 'Isotropic'   ;

% PMMA ====================================================================
allMaterialStruct.PMMA.c                        =   2700        ;    
allMaterialStruct.PMMA.cs                       =   1330        ; 
allMaterialStruct.PMMA.rho                      =   1150        ; 
allMaterialStruct.PMMA.state                    = 'Isotropic'   ;

% titanium ================================================================
allMaterialStruct.titanium.c                    =   6060        ;  
allMaterialStruct.titanium.cs                   =   3230        ;   
allMaterialStruct.titanium.rho                  =   4460        ;
allMaterialStruct.titanium.state                = 'Isotropic'   ;

% gold ====================================================================
allMaterialStruct.gold.c                        =   3240        ;  
allMaterialStruct.gold.cs                       =   1182        ;   
allMaterialStruct.gold.rho                      =   19300       ;
allMaterialStruct.gold.state                    = 'Isotropic'   ;
 
% protactinium ============================================================
allMaterialStruct.protactinium.c                =   3070        ;  
allMaterialStruct.protactinium.cs               =   1           ;   
allMaterialStruct.protactinium.rho              =   12023       ;
allMaterialStruct.protactinium.state            = 'Isotropic'   ;

% tungsten ================================================================
allMaterialStruct.tungsten.c                    =   5147        ;  
allMaterialStruct.tungsten.cs                   =   2891        ;   
allMaterialStruct.tungsten.rho                  =   19250       ;
allMaterialStruct.tungsten.state                = 'Isotropic'   ;

% tissue (flesh) ==========================================================
allMaterialStruct.tissue.c                      =   1578    ;  
allMaterialStruct.tissue.cs                     =   0.01    ;  
allMaterialStruct.tissue.rho                    =   1050    ;
allMaterialStruct.tissue.state                  = 'Liquid'  ;

% aluminium ===============================================================
allMaterialStruct.aluminium.c                   =   6400        ; 
allMaterialStruct.aluminium.cs                  =   3100        ; 
allMaterialStruct.aluminium.rho                 =   2700        ;
allMaterialStruct.aluminium.state               = 'Isotropic'   ;

% steel ===================================================================
allMaterialStruct.steel1020.c                   =   5890        ; 
allMaterialStruct.steel1020.cs                  =   3240        ; 
allMaterialStruct.steel1020.rho                 =   7870        ;
allMaterialStruct.steel1020.state               = 'Isotropic'   ;

% TantPentox ==============================================================     
% http://oa.upm.es/12630/1/INVE_MEM_2011_106857.pdf
%  mu = 69 Gpa; hence sqrt(69*10^9 / 8200)
allMaterialStruct.tantpentox.c                  =   5000        ;
allMaterialStruct.tantpentox.cs                 =   2900        ; % calculated
allMaterialStruct.tantpentox.rho                =   8200        ;
allMaterialStruct.tantpentox.state              = 'Isotropic'   ;

% silicondiox =============================================================  
% mu = 27.9 GPa; hence  sqrt(27.9*10^9 / 2600)
allMaterialStruct.silicondiox2.c                =   5900        ;
allMaterialStruct.silicondiox2.cs               =   3300        ; % calculated
allMaterialStruct.silicondiox2.rho              =   2500        ;
allMaterialStruct.silicondiox2.state            = 'Isotropic'   ;

% Zirconium dioxide =======================================================
% wikipedia 
allMaterialStruct.ZircDiox.c                    =   3000        ;
allMaterialStruct.ZircDiox.cs                   =   1500        ; % unknown
allMaterialStruct.ZircDiox.rho                  =   5680        ;
allMaterialStruct.ZircDiox.state                = 'Isotropic'   ;

% Silver ==================================================================
allMaterialStruct.silver.c                      =   3600        ;
allMaterialStruct.silver.cs                     =   1590        ;
allMaterialStruct.silver.rho                    =   10500       ;  
allMaterialStruct.silver.state                  = 'Isotropic'   ;

% Nickel ==================================================================
allMaterialStruct.nickel.c                      =   5630        ;
allMaterialStruct.nickel.cs                     =   2960        ;
allMaterialStruct.nickel.rho                    =   8800        ;  
allMaterialStruct.nickel.state                  = 'Isotropic'   ;

% copper ==================================================================
allMaterialStruct.copper.c                      =   4700        ;
allMaterialStruct.copper.cs                     =   2260        ;
allMaterialStruct.copper.rho                    =   8900        ;  
allMaterialStruct.copper.state                  = 'Isotropic'   ;

% =========================================================================
%   ANISOTROPIC
% =========================================================================

% CubicInAs ===============================================================
% from Nayfeh - wave propogation in layered anisotropic media
% from Nayfeh - rotated at 0 degrees
allMaterialStruct.CubicInAs0.rho            =   5670        ;
allMaterialStruct.CubicInAs0.state          = 'Anisotropic' ;
allMaterialStruct.CubicInAs0.cMat           =  1.0e+09 *[...
    83.29         45.26       45.26       0           0           0;
    45.26       83.29         45.26       0           0           0;
    45.26       45.26       83.29         0           0           0;
    0           0           0           39.59       0           0;
    0           0           0           0           39.59       0;
    0           0           0           0           0           39.59];

% CubicInAs ===============================================================
% from Nayfeh - wave propogation in layered anisotropic media
% rotated at 45 degrees
allMaterialStruct.CubicInAs45.rho                =   5670    ;
allMaterialStruct.CubicInAs45.state              = 'Anisotropic'  ;
allMaterialStruct.CubicInAs45.cMat    =  1.0e+09 *[...
    103.86      24.68       45.26       0           0           0;
    24.68       103.86      45.26       0           0           0;
    45.26       45.26       83.29       0           0           0;
    0           0           0           39.59       0           0;
    0           0           0           0           19.01       0;
    0           0           0           0           0           39.59];

% beryl ===================================================================
% from I. Abubakar - free vibrations of a transversely isotropic plate
allMaterialStruct.beryl.rho                 =   2700        ;
allMaterialStruct.beryl.state               = 'Anisotropic' ;
allMaterialStruct.beryl.cMat                =  1.0e+09 *[...
    23.63      	6.61        6.61        0           0           0;
    6.61        23.63       6.61        0           0           0;
    6.61        6.61        26.94       0           0           0;
    0           0           0           1           0           0;
    0           0           0           0           6.53        0;
    0           0           0           0           0           1];

% apatitie ================================================================
% from PAYTON - elstic wave propogation in transversely isotropic media
allMaterialStruct.apatite.rho               =   2700         ; % unknown 
allMaterialStruct.apatite.state             = 'Anisotropic'  ;
allMaterialStruct.apatite.cMat              =  1.0e+09 *[...
    16.7      	1.31        6.6         0           0           0;
    1.31        16.7        6.6         0           0           0;
    6.6         6.6         14.0        0           0           0;
    0           0           0           6.63        0           0;
    0           0           0           0           6.63        0;
    0           0           0           0           0           ( 16.7  -1.31)/2  ];

% beryl ===================================================================
% from PAYTON - elstic wave propogation in transversely isotropic media
allMaterialStruct.beryl2.rho                =   2700        ;
allMaterialStruct.beryl2.state              = 'Anisotropic' ;
allMaterialStruct.beryl2.cMat               =  1.0e+09 *[...
    28.2      	9.94        6.95        0           0           0;
    9.94        28.2        6.95        0           0           0;
    6.95        6.95        24.8        0           0           0;
    0           0           0           6.68        0           0;
    0           0           0           0           6.68        0;
    0           0           0           0           0           (28.2  -9.94)/2  ];

% zinc ====================================================================
% from PAYTON - elstic wave propogation in transversely isotropic media
allMaterialStruct.zinc.rho                  =   2700            ;
allMaterialStruct.zinc.state                = 'Anisotropic'     ;
allMaterialStruct.zinc.cMat                 =  1.0e+09 *[...
    16.5      	3.1         5.0         0           0           0;
    3.1         16.5        5.0         0           0           0;
    5.0         5.0         6.2         0           0           0;
    0           0           0           3.96        0           0;
    0           0           0           0           3.96        0;
    0           0           0           0           0           (16.5  - 3.1)/2  ];

% zinc (rotated) ==========================================================
% from PAYTON - elstic wave propogation in transversely isotropic media
allMaterialStruct.zinc.rho                  =   2700            ;
allMaterialStruct.zinc.state                = 'Anisotropic'     ;
allMaterialStruct.zinc.cMat                 =  1.0e+09 *[...
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
% allMaterialStruct.graphiteEpoxy.cMat    =  1.0e+09 *[...
%     155.43      3.72        3.72        0           0           0;
%     3.72        16.34       3.72        0           0           0;
%     3.72        3.72        16.34       0           0           0;
%     0           0           0           7.48        0           0;
%     0           0           0           0           7.48        0;
%     0           0           0           0           0           7.48];

% allMaterialStruct.graphiteEpoxy.rho                =   1600    ;
% allMaterialStruct.graphiteEpoxy.state              = 'Anisotropic'  ;
% allMaterialStruct.graphiteEpoxy.cMat    =  1.0e+09 *[...
%     155.43      3.72        3.72        0           0           0;
%     3.72        16.34       4.96        0           0           0;
%     3.72        4.96        16.34       0           0           0;
%     0           0           0           3.37        0           0;
%     0           0           0           0           7.48        0;
%     0           0           0           0           0           7.48];

allMaterialStruct.graphiteEpoxy.rho                =   1600    ;
allMaterialStruct.graphiteEpoxy.state              = 'Anisotropic'  ;
allMaterialStruct.graphiteEpoxy.cMat    =  1.0e+09 *[...
    145.79      3.77        8.33        0           0           0;
    3.77        16.34       4.91        0           0           0;
    8.33        4.91        16.77       0           0           0;
    0           0           0           3.52        0           0;
    0           0           0           0           12.08        0;
    0           0           0           0           0           7.33];

allMaterialStruct.graphiteEpoxy.rho                =   1600    ;
allMaterialStruct.graphiteEpoxy.state              = 'Anisotropic'  ;
allMaterialStruct.graphiteEpoxy.cMat    =  1.0e+09 *[...
    145.79      8.33        3.77        0           0           0;
    8.33        16.77       4.91        0           0           0;
    3.77        4.91        16.34       0           0           0;
    0           0           0            7.33        0           0;
    0           0           0           0           7.33        0;
    0           0           0           0           0            7.33];

% GaAs ====================================================================
%  Nayfeh - wave propogation in layered anisotropic media
allMaterialStruct.GaAs.rho                  =   5307            ;
allMaterialStruct.GaAs.state                = 'Anisotropic'     ;
allMaterialStruct.GaAs.cMat                 =  1.0e+09 *[...
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
allMaterialStruct.parylene_C.c                  =   2200     ; 
allMaterialStruct.parylene_C.cs                 =   1100     ; 
allMaterialStruct.parylene_C.rho                =   1180     ; 
allMaterialStruct.parylene_C.state              = 'Isotropic';
% from Cox & Beard, 'The frequency-dependent directivity of a planar ...
% Fabry-Perot polymer film ultrasound sensor' 

% comboHD dielectric Fabry-Perot mirrors ==================================
allMaterialStruct.comboHD.c                     =   4592.7      ;
allMaterialStruct.comboHD.cs                    =   2488.1      ;
allMaterialStruct.comboHD.rho                   =   3988.4      ; 
allMaterialStruct.comboHD.state                 = 'Isotropic'   ;

% dielectirc mirrors D6 Fabry-Perot sensor ================================
% this is an estimate of the dielectric mirros for the D6 Fabry perot
% sensor
allMaterialStruct.comboD6.c                     =   5615        ;
allMaterialStruct.comboD6.cs                    =   2442        ;
allMaterialStruct.comboD6.rho                   =   4432        ;   
allMaterialStruct.comboD6.state                 = 'Isotropic'   ;

% ZEONEX ==================================================================
% http://www.zeon.co.jp/content/200181690.pdf
% mu = 2.4 Gpa;  sqrt(2400*10^6 / 2525)
allMaterialStruct.ZEONEX.c                      =   2525        ;
allMaterialStruct.ZEONEX.cs                     =   974.93      ; % calculated
allMaterialStruct.ZEONEX.rho                    =   1010        ;
allMaterialStruct.ZEONEX.state                  = 'Isotropic'   ;

% parylene2 ===============================================================
% parylene properties are not well known
allMaterialStruct.parylene2.c                   =   2200        ;
allMaterialStruct.parylene2.cs                  =   1100        ;
allMaterialStruct.parylene2.rho                 =   1289        ;
allMaterialStruct.parylene2.state               = 'Isotropic'   ;

% Anisotropic Paryene estimate ============================================
allMaterialStruct.ParCA.rho                 =   1289         ;
allMaterialStruct.ParCA.state               = 'Anisotropic'  ;
allMaterialStruct.ParCA.cMat                =  1.0e+09 *[...
    6.2388    3.1194    3.1194*0.9      0           0           0;
    3.1194    6.2388    3.1194          0           0           0;
    3.1194    3.1194    6.2388*1.5      0           0           0;
    0         0         0               1.5597      0           0;
    0         0         0               0           1.5597*1.3  0;
    0         0         0               0           0           1.5597];