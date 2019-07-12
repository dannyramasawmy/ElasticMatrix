# ElasticMatrix
The ElasticMatrix software implements the partial-wave method [1] to model elastic wave propagation in multilayered anisotropic media up to transverse-isotropic symmetry when the wave propagation is along a plane of symmetry.

- The ./examples folder contains example scripts demonstrating some of the capabilities of the code.
- The ./documentation folder contains relevant papers for the mathematical background.
- The ./src-pw folder contains the source code for the partial wave method, the -pw refers to the partial-wave method, in future the global matrix method [2] will also be implemented.
- run ./examples/run_all.m  will run through every example and checks the code will execute correctly on your version of MATLAB

### Capabilities
Some of the code functionalitiy:
- plotting slowness profiles
- plotting reflection and transmission coefficients
- calculating the dispersion curves for simple plate structures (this has a few bugs currently)
- plotting the, displacement and stress fields
- calculating the directivity of Fabry-Perot Ultrasound sensors, see [3]

### References
- [1] Nayfeh, Adnan H. "The general problem of elastic wave propagation in multilayered anisotropic media." The Journal of the Acoustical Society of America 89.4 (1991): 1521-1531.
- [2] Lowe, Michael JS. "Matrix techniques for modeling ultrasonic waves in multilayered media." IEEE transactions on ultrasonics, ferroelectrics, and frequency control 42.4 (1995): 525-542.
- [3] Ramasawmy, D. R., et al. "Analysis of the Directivity of Glass Etalon Fabry-Pérot Ultrasound Sensors." IEEE transactions on ultrasonics, ferroelectrics, and frequency control (2019).

### Future updates
- Dispersion curve tracing still needs updating
- Automatic sorting of calculation parameters (angles, frequencies, wavenumbers, phasespeed) 

### Update log:
2019-07-12
- Dispersion curve algorithm is much faster
- examples folder is almost complete

2019-07-04
- Dispersion curve tracing still needs updating
- Automatic sorting of calculation parameters (angles, frequencies, wavenumbers, phasespeed) needs updating
- examples folder is still being populated

2019-06-26: 
- All methods are implemented 
- dispersion curve tracing needs to be made more robust, use the coarse method for now
- examples folder is being populated

2019-05-11:
- Inital commit, there are a few bugs in the dispersion curve functionality.
- The examples folder needs to be updated, there are a few class method implementations which are missing.              

