# ElasticMatrix Toolbox
The ElasticMatrix Toolbox uses the partial-wave method [1,3,4] to model elastic wave propagation in multi-layered anisotropic media up to transverse-isotropic symmetry when the wave propagation is along a plane of symmetry.

## Download
Download from github, or MATLAB file exchange:
[![View ElasticMatrix Toolbox on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://uk.mathworks.com/matlabcentral/fileexchange/74245-elasticmatrix-toolbox).

View the documentation online:
https://dannyramasawmy.github.io/ElasticMatrix/

## Installation

To add the ElasticMatrix Toolbox source-code and all the examples:

``` matlab
addpath(genpath('<folderpath>/ElasticMatrix')) 
```

To add the ElasticMatrix Toolbox source-code without examples:

``` matlab
addpath('<folderpath>/ElasticMatrix/src-pw')
```

The source code is found in the ```src-pw``` folder.

## Requirements

ElasticMatrix has been tested with MATLAB2016a and above and should run on most personal laptops and desktop machines.

## Documentation

- To view the html documentation in MATLAB:
  - ```help (or press F1) -> Supplemental Software -> ElasticMatrix Toolbox```

- ```./examples``` folder contains example scripts demonstrating some of the capabilities of the code.
- ```./examples_mlx``` folder contains example scripts in the MATLAB live script style.
- ```./documentation``` folder contains a reference list for the mathematical background.

## Functionality
Some of the code functionality includes:
- Plotting slowness profiles.
- Plotting reflection and transmission coefficients.
- Calculating dispersion curves for simple plate structures.
- Plotting displacement and stress fields.
- Calculating the directivity of Fabry-Perot ultrasound sensors, see [1].

## Contact
Danny Ramasawmy

rmapdrr@ucl.ac.uk

dannyramasawmy+elasticmatrix@gmail.com 

or

Bradley Treeby

b.treeby@ucl.ac.uk

Ben Cox

b.cox@ucl.ac.uk

## File Tree

The file tree for the ElasticMatrix Toolbox is shown below. Files/folders marked with an asterisk (*) are not included when using download in git and are only included if the repository is cloned. Files marked with  a double asterisk are not pushed to the public repository, please contact the author if these are required.

Tree compiled: 2019-11-11

``` bash
.
├── data
│   └── disperseTitaniumPlateData.txt
│   ├── disperseTeflonPlateData.txt
│
├── documentation
│   ├── 2019-07-19-BUG_coding_standard.md*
│   ├── example_template_file.m*
│   ├── functionTemplateFile.m*
│   ├── html
│   │   ├── ElasticMatrix.html
|   │   ├── example_dispersion_curve_PVDF_plate.html
│   │   ├── example_dispersion_curve_teflon_plate.html
│   │   ├── example_dispersion_curve_titanium_plate.html
│   │   ├── example_elasticmatrix_class.html
│   │   ├── example_extra_functions.html
│   │   ├── example_fabry_perot_directivity.html
│   │   ├── example_interface_parameters.html
│   │   ├── example_medium_class.html
│   │   ├── example_periodic_media.html
│   │   ├── example_plot_field_parameters.html
│   │   ├── example_plot_field_parameters_movie.html
│   │   ├── example_reflection_and_transmission.html
│   │   ├── example_slowness_profiles.html
│   │   ├── helptoc.xml
│   │   └── images
│   │       ├── elastic_matrix_banner.JPG
│   │       ├── ElasticMatrix - class diagram.png
│   │       └── sfg_example.JPG
│   └── references.txt
│
├── examples
│   ├── example_dispersion_curve_PVDF_plate.m
│   ├── example_dispersion_curve_teflon_plate.m
│   ├── example_dispersion_curve_tissue_plate.m
│   ├── example_dispersion_curve_titanium_plate.m
│   ├── example_elasticmatrix_class.m
│   ├── example_extra_functions.m
│   ├── example_fabry_perot_directivity.m
│   ├── example_fabry_perot_frequency_response.m
│   ├── example_interface_parameters.m
│   ├── example_medium_class.m
│   ├── example_periodic_media.m
│   ├── example_plot_field_parameters.m
│   ├── example_plot_field_parameters_movie.m
│   ├── example_reflection_and_transmission.m
│   └── example_slowness_profiles.m
│
├── examples_mlx
|   ├── example_dispersion_curve_PVDF_plate.mlx
│   ├── example_dispersion_curve_teflon_plate.mlx
│   ├── example_dispersion_curve_titanium_plate.mlx
│   ├── example_elasticmatrix_class.mlx
│   ├── example_extra_functions.mlx
│   ├── example_fabry_perot_directivity.mlx
│   ├── example_interface_parameters.mlx
│   ├── example_medium_class.mlx
│   ├── example_periodic_media.mlx
│   ├── example_plot_field_parameters.mlx
│   ├── example_plot_field_parameters_movie.mlx
│   ├── example_reflection_and_transmission.mlx
│   └── example_slowness_profiles.mlx
│
├── src-pw
│   ├── calculateReflectionTransmissionAnalytic.m
│   ├── cls.m
│   ├── @ElasticMatrix
│   │   ├── calculateDispersionCurvesCoarse.m
│   │   ├── calculateDispersionCurves.m
│   │   ├── calculateField.m
│   │   ├── calculateFieldMatrixAnisotropic.m
│   │   ├── calculate.m
│   │   ├── calculateMatrixModelKf.m
│   │   ├── calculateMatrixModel.m
│   │   ├── disp.m
│   │   ├── ElasticMatrix.m
│   │   ├── getPartialWaveAmplitudes.m
│   │   ├── plotDispersionCurves.m
│   │   ├── plotField.m
│   │   ├── plotInterfaceParameters.m
│   │   ├── plotRTCoefficients.m
│   │   ├── save.m
│   │   ├── setAngle.m
│   │   ├── setFilename.m
│   │   ├── setFrequency.m
│   │   ├── setMedium.m
│   │   ├── setPhasespeed.m
│   │   └── setWavenumber.m
│   ├── @FabryPerotSensor
│   │   ├── calculateDirectivity.m
│   │   ├── disp.m
│   │   ├── FabryPerotSensor.m
│   │   ├── getDirectivity.m
│   │   ├── plotDirectivity.m
│   │   ├── setMirrorLocations.m
│   │   ├── setSpotDiameter.m
│   │   └── setSpotType.m
│   ├── findClosest.m
│   ├── findClosestMinimum.m
│   ├── findZeroCrossing.m
│   ├── materialList.m
│   ├── @Medium
|   │   ├── availableMaterials.m
│   │   ├── calculateAlphaCoefficients.m
│   │   ├── calculateSlowness.m
│   │   ├── disp.m
│   │   ├── getAcousticProperties.m
│   │   ├── lameConversion.m
│   │   ├── Medium.m
│   │   ├── mtimes.m
│   │   ├── plotSlowness.m
│   │   ├── plus.m
│   │   ├── setDensity.m
│   │   ├── setName.m
│   │   ├── setStiffnessMatrix.m
│   │   ├── setThickness.m
│   │   ├── soundSpeedDensityConversion.m
│   │   ├── state.m
│   │   └── times.m
│   ├── normMe.m
│   ├── printLineBreaks.m
│   └── sfg.m
│
├── testing*
│   ├── run_all_tests_and_examples.m*
│   ├── test_comparison_with_GMM.m*
│   ├── test_elasticmatrix_class.m*
│   ├── test_fabry_perot_directivity.m*
│   ├── test_fabry_perot_frequency_response.m*
│   ├── test_fabryperotsensor_class.m*
│   ├── test_main_functions.m*
│   ├── test_medium_class.m*
│   ├── test_n_layers_vs_calculation_time.m*
│   └── test_partial_wave_amplitudes.m*
│
├── testing_data**
│   ├── Beard1999FrequencyResponseFabryPerotData.mat**
│   ├── glassEtalonFabryPerotDirectivityData.mat**
│   └── gmmIsotropicModelData.mat**
│     
├── info.xml
├── LICENSE.txt
└── README.md

```

  

## References

[1] Ramasawmy, Danny R., et al. "ElasticMatrix: A MATLAB Toolbox for 
    Anisotropic Elastic Wave Propagation in Layered Media.", (2019).

[2] Ramasawmy, Danny R., et al. "Analysis of the Directivity of Glass 
    Etalon Fabry-Pérot Ultrasound Sensors." IEEE transactions on 
    ultrasonics, ferroelectrics, and frequency control, (2019).

[3] Lowe, Michael JS. "Matrix techniques for modeling ultrasonic waves in 
    multilayered media." IEEE transactions on ultrasonics, ferroelectrics,
    and frequency control, (1995).

[4] Nayfeh, Adnan H. "The general problem of elastic wave propagation in
    multilayered anisotropic media." The Journal of the Acoustical Society 
    of America (1991).

[5] Pavlakovic, Brian, et al. "Disperse: A general purpose program for 
    creating dispersion curves." Review of progress in quantitative
    nondestructive evaluation. Springer, Boston, (1997).

[6] Rose, Joseph L. "Ultrasonic guided waves in solid media." 
    Cambridge university press, (2014).

[7] Cheeke, J. David N. "Fundamentals and applications of ultrasonic 
    waves." CRC press, (2016).

[8] Beard, P. "Transduction mechanisms of the Fabry-Perot polymer film 
    sensing concept for wideband ultrasound detection"  IEEE transactions 
    on ultrasonics, ferroelectrics, and frequency control, (1999).

[9] Cox, Benjamin T., and Paul C. Beard. "The frequency-dependent 
    directivity of a planar Fabry-Perot polymer film ultrasound sensor." 
    IEEE transactions on ultrasonics, ferroelectrics, and frequency 
    control, (2007).
