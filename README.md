# ElasticMatrix
The ElasticMatrix software implements the partial-wave method [1] to model elastic wave propagation in multilayered anisotropic media up to transverse-isotropic and orthotropic symmetry when the wave propagation is along an axis of symmetry.

- The ./examples folder contains example scripts demonstrating some of the capabilities of the code.
- The ./documentation folder contains relevant papers for the mathematical background.
- The ./src-pw folder contains the source code for the partial wave method, the -pw refers to the partial-wave method, in future the global matrix method [2] may also be implemented.

### Capabilities
Some of the code functionalitiy:
- plotting slowness profiles
- plotting reflection and transmission coefficients
- calculating the dispersion curves for simple plate structures
- plotting the, displacement and stress fields
- calculating the directivity of Fabry-Perot Ultrasound sensors, see [3]

### References
- [1] Nayfeh, Adnan H. "The general problem of elastic wave propagation in multilayered anisotropic media." The Journal of the Acoustical Society of America 89.4 (1991): 1521-1531.
- [2] Lowe, Michael JS. "Matrix techniques for modeling ultrasonic waves in multilayered media." IEEE transactions on ultrasonics, ferroelectrics, and frequency control 42.4 (1995): 525-542.
- [3] Ramasawmy, D. R., et al. "Analysis of the Directivity of Glass Etalon Fabry-Pérot Ultrasound Sensors." IEEE transactions on ultrasonics, ferroelectrics, and frequency control (2019).

### Update log:
2019-06-26: 
- All methods are implemented 
- dispersion curve tracing needs to be made more robust, use the coarse method for now
- examples folder is being populated

2019-05-11:
- Inital commit, there are a few bugs in the dispersion curve functionality.
- The examples folder needs to be updated, there are a few class method implementations which are missing.              

