# ElasticMatrix
The ElasticMatrix software implements the partial-wave method [1,3,4] to model elastic wave propagation in multi-layered anisotropic media up to transverse-isotropic symmetry when the wave propagation is along a plane of symmetry.

To view the html documentation in MATLAB:
help (or press F1) -> Supplemental Software -> ElasticMatrix Toolbox

- ./examples folder contains example scripts demonstrating some of the capabilities of the code.
- ./examples_mlx folder contains example scripts in the MATLAB live script style.
- ./documentation folder contains a reference list for the mathematical background.
- ./src-pw folder contains the source code for the partial wave method.

### Capabilities
Some of the code functionality:
- Plotting slowness profiles.
- Plotting reflection and transmission coefficients.
- Calculating the dispersion curves for simple plate structures.
- Plotting the, displacement and stress fields.
- Calculating the directivity of Fabry-Perot ultrasound sensors, see [1].

### References
Reference list:
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

### Update log:
2019-08-20
- html documentation added for most example scripts.
- All Functions have been refactored.

2019-07-31
- Some functions in src-pw have been made static methods.
- Header documentation for every function.
- All functions in src-pw (Except calculateDispersionCurves) have been refactored to the BUG coding standard.

2019-07-18
- Reorder folders, delete some data and papers from documentation (replaced with a reference list).

2019-07-16
- Sorting of calculation parameters when calling .calculate needs 2 of 4, frequency + angle/phase-speed/wavenumber.
- Examples updated.

2019-07-12
- Dispersion curve algorithm is much faster.
- Examples folder is almost complete.

2019-07-04
- Dispersion curve tracing still needs updating.
- Automatic sorting of calculation parameters (angles, frequencies, wave-numbers, phase-speed) needs updating.
- Examples folder is still being populated.

2019-06-26: 
- All methods are implemented.
- Dispersion curve tracing needs to be made more robust, use the coarse method for now.
- Examples folder is being populated.

2019-05-11:
- Initial commit, there are a few bugs in the dispersion curve functionality.
- The examples folder needs to be updated, there are a few class method implementations which are missing.              
