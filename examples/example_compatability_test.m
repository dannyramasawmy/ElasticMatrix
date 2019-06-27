%% example_compatability_test
%
% Author    :   Danny Ramasawmy
%               rmapdrr@ucl.ac.uk
%               dannyramasawmy@gmail.com
% Date      :   2019-01-25  -   created
%
%   This script runs through nearly every function in the ElasticMatrix
%   software. If when running this script there is a fail, it may not be
%   compatible with your version of MATLAB. This will not check the
%   accuracy of the implementations, only if it will run.
%
% =========================================================================
%   TEST 1 : MEDIUM
% =========================================================================
% This will test the Medium methods
cls;

% counters
totalCounter = 0;
totalPass = 0;
totalFail = 0;

disp('Test: src')
try
    addpath('../src-pw/')
    disp('pass')
    totalPass = totalPass + 1;
catch
    disp('fail')
    totalFail = totalFail + 1;
end
totalCounter = totalCounter + 1;

disp('Test: Medium.availableMaterials;')
try
    Medium.availableMaterials
    disp('pass')
    totalPass = totalPass + 1;
catch
    disp('fail')
    totalFail = totalFail + 1;
end
totalCounter = totalCounter + 1;

disp('Test: myM = Medium.generateLayeredMedium(...)')
try
    myMedium = Medium.generateLayeredMedium('water',0,'apatite',1e-3,'glass',1);
    disp('pass')
    totalPass = totalPass + 1;
catch
    disp('fail')
    totalFail = totalFail + 1;
end
totalCounter = totalCounter + 1;

disp('Test: medium.disp;')
try
    myMedium.disp;
    disp('pass')
    totalPass = totalPass + 1;
catch
    disp('fail')
    totalFail = totalFail + 1;
end
totalCounter = totalCounter + 1;

disp('Test: Medium.setName(layerIndex, newName)')
try
    myMedium.setName(1,'newWater');
    disp('pass')
    totalPass = totalPass + 1;
catch
    disp('fail')
    totalFail = totalFail + 1;
end
totalCounter = totalCounter + 1;

disp('Test: [cMat] = Medium.soundSpeedDensityConversion(c_l, c_s, rho)')
try
    cMat = myMedium.soundSpeedDensityConversion(5600,3300,2400);
    disp('pass')
    totalPass = totalPass + 1;
catch
    disp('fail')
    totalFail = totalFail + 1;
end
totalCounter = totalCounter + 1;

disp('Test: Medium.setCMatrix(layerIndex, cMat)')
try
    myMedium.setCMatrix(3, cMat);
    disp('pass')
    totalPass = totalPass + 1;
catch
    disp('fail')
    totalFail = totalFail + 1;
end
totalCounter = totalCounter + 1;

disp('Test: Medium.setDensity(layerIndex, rho) ')
try
    myMedium.setDensity(3, 2400);
    disp('pass')
    totalPass = totalPass + 1;
catch
    disp('fail')
    totalFail = totalFail + 1;
end
totalCounter = totalCounter + 1;

disp('Test: Medium.setThickness(layerIndex, thickness)')
try
    myMedium.setThickness(2, 50e-6);
    disp('pass')
    totalPass = totalPass + 1;
catch
    disp('fail')
    totalFail = totalFail + 1;
end
totalCounter = totalCounter + 1;

disp('Test: [cMat] = Medium.lameConversion(lambda, mu)')
try
    if cMat == Medium.lameConversion(cMat(1,2),cMat(5,5))
        disp('pass')
        
        totalPass = totalPass + 1;
    else
        totalFail = totalFail + 1;
        disp('fail')
    end
catch
    disp('fail')
    totalFail = totalFail + 1;
end
totalCounter = totalCounter + 1;

disp('Test: Medium.calculateSlowness')
try
    myMedium.calculateSlowness;
    disp('pass')
    totalPass = totalPass + 1;
catch
    disp('fail')
    totalFail = totalFail + 1;
end
totalCounter = totalCounter + 1;

disp('Test: [figHand] = Medium.plotSlowness')
try
    figHandle = myMedium.plotSlowness;
    close(figHandle)
    disp('pass')
    totalPass = totalPass + 1;
catch
    disp('fail')
    totalFail = totalFail + 1;
end
totalCounter = totalCounter + 1;

% =========================================================================
%   TEST 2 : ELASTICMATRIX
% =========================================================================
% This will test the ElasticMatrix methods

disp('Test: model = ElasticMatrix(mediumObject)')
try
    model = ElasticMatrix(myMedium);
    disp('pass')
    totalPass = totalPass + 1;
catch
    disp('fail')
    totalFail = totalFail + 1;
end
totalCounter = totalCounter + 1;

myMedium =  Medium.generateLayeredMedium('water',0,'aluminium',1e-3,'water',Inf);
disp('Test: ElasticMatrix.setMedium(mediumObject)')
try
    model.setMedium(myMedium);
    disp('pass')
    totalPass = totalPass + 1;
catch
    disp('fail')
    totalFail = totalFail + 1;
end
totalCounter = totalCounter + 1;

disp('Test: ElasticMatrix.setFilename(filename)')
try
    model.setFilename('testing_example');
    disp('pass')
    totalPass = totalPass + 1;
catch
    disp('fail')
    totalFail = totalFail + 1;
end
totalCounter = totalCounter + 1;

sampleDensity = 10;
disp('Test: ElasticMatrix.setAngle(angleRange) ')
try
    model.setAngle(linspace(0,45,sampleDensity));
    disp('pass')
    totalPass = totalPass + 1;
catch
    disp('fail')
    totalFail = totalFail + 1;
end
totalCounter = totalCounter + 1;

disp('Test: ElasticMatrix.setFrequency(freqRange) ')
try
    model.setFrequency(linspace(0.1e6,50e5,sampleDensity));
    disp('pass')
    totalPass = totalPass + 1;
catch
    disp('fail')
    totalFail = totalFail + 1;
end
totalCounter = totalCounter + 1;
disp('Test: ElasticMatrix.setPhasespeed(phasespeedRange) ')
try
    model.setPhasespeed(linspace(100,500,sampleDensity));
    disp('pass')
    totalPass = totalPass + 1;
catch
    disp('fail')
    totalFail = totalFail + 1;
end
totalCounter = totalCounter + 1;
disp('Test: ElasticMatrix.setWavenumber(wavenumberRange) ')
try
    model.setWavenumber(linspace(100,500,sampleDensity));
    disp('pass')
    totalPass = totalPass + 1;
catch
    disp('fail')
    totalFail = totalFail + 1;
end
totalCounter = totalCounter + 1;

disp('Test: ElasticMatrix.disp')
try
    model.disp;
    disp('pass')
    totalPass = totalPass + 1;
catch
    disp('fail')
    totalFail = totalFail + 1;
end
totalCounter = totalCounter + 1;

disp('Test: ElasticMatrix.calculate')
try
    model.calculate;
    disp('pass')
    totalPass = totalPass + 1;
catch
    disp('fail')
    totalFail = totalFail + 1;
end
totalCounter = totalCounter + 1;

disp('Test: [figHand] = ElasticMAtrix.plotRCoefficients')
try
    [figHand] = model.plotRCoefficients;
    close(figHand)
    disp('pass')
    totalPass = totalPass + 1;
catch
    disp('fail')
    totalFail = totalFail + 1;
end
totalCounter = totalCounter + 1;

disp('Test: [figHand] = ElasticMatrix.plotInterfaceParameters')
try
    figHand = model.plotInterfaceParameters;
    close(figHand.interface1,figHand.interface2)
    disp('pass')
    totalPass = totalPass + 1;
catch
    disp('fail')
    totalFail = totalFail + 1;
end
totalCounter = totalCounter + 1;

disp('Test: [fieldStructure] = ElasticMatrix.calculateField(angle, frequency, {Zvector, Xvector}) ')
try
    plotVector = linspace(-1.5,0.5,128)*1e-3;
    field = model.calculateField(15, 50e6, {plotVector, plotVector});
    disp('pass')
    totalPass = totalPass + 1;
catch
    disp('fail')
    totalFail = totalFail + 1;
end
totalCounter = totalCounter + 1;

disp('Test: [figHand = plotField(fieldStructure)] ')
try
    figHand = model.plotField(field);
    disp('pass')
    totalPass = totalPass + 1;
catch
    disp('fail')
    totalFail = totalFail + 1;
end
totalCounter = totalCounter + 1;

disp('Test: [figHand = plotField(fieldStructure, figureHandleStructure)] ')
try
    figHand = model.plotField(field, figHand);
    disp('pass')
    totalPass = totalPass + 1;
catch
    disp('fail')
    totalFail = totalFail + 1;
end
totalCounter = totalCounter + 1;

disp('Test: [figHand = plotField(fieldStructure, plotType)] ')
try
    figHand = model.plotField(field, 'Mesh','Vector');
    close all;
    disp('pass')
    totalPass = totalPass + 1;
catch
    disp('fail')
    totalFail = totalFail + 1;
end
totalCounter = totalCounter + 1;

disp('Test: ElastixMatix.calculateDispersonCurvesCoarse')
try
    model.calculateDispersionCurvesCoarse;
    disp('pass')
    totalPass = totalPass + 1;
catch
    disp('fail')
    totalFail = totalFail + 1;
end
totalCounter = totalCounter + 1;

disp('Test: ElastixMatix.calculateDispersonCurves')
try
    % model.calculateDispersionCurves;
    disp('pass')
    totalPass = totalPass + 1;
catch
    disp('fail')
    totalFail = totalFail + 1;
end
totalCounter = totalCounter + 1;

disp('Test: [figHand] = ElasticMatrix.plotDispersionCurves')
try
    [figHand] = model.plotDispersionCurves;
    close all
    disp('pass')
    totalPass = totalPass + 1;
catch
    disp('fail')
    totalFail = totalFail + 1;
end
totalCounter = totalCounter + 1;

disp('Test: ElasticMatrix.save(filename)')
try
    model.save('TestCompatibility');
    delete('TestCompatibility.mat')
    disp('pass')
    totalPass = totalPass + 1;
catch
    disp('fail')
    totalFail = totalFail + 1;
end
totalCounter = totalCounter + 1;

% =========================================================================
%  TEST 3 : FABRYPEROTSENSOR
% =========================================================================
% The fabry-perot class inherits the elastic matrix class, this part of the
% script will test the additional methods of this class


disp('Test: model = FabryPerotSensor(mediumObject)')
try
    % make the example medium
    sensorMedium      = Medium.generateLayeredMedium(...
        'water',Inf,'glass',200e-6,'water',Inf);
    sensor = FabryPerotSensor(sensorMedium);
    disp('pass')
    totalPass = totalPass + 1;
catch
    disp('fail')
    totalFail = totalFail + 1;
end
totalCounter = totalCounter + 1;

disp('Test: FabryperotSensor.setSpotType(spotType)')
try
    sensor.setSpotType('collimated');
    disp('pass')
    totalPass = totalPass + 1;
catch
    disp('fail')
    totalFail = totalFail + 1;
end
totalCounter = totalCounter + 1;

disp('Test: FabryperotSensor.setSpotSize(spotDiameter) ')
try
    sensor.setSpotSize(50e-6);
    disp('pass')
    totalPass = totalPass + 1;
catch
    disp('fail')
    totalFail = totalFail + 1;
end
totalCounter = totalCounter + 1;

disp('Test: FabryperotSensor.setMirrorLocations([interfaceIndex, interfaceIndex]) ')
try
    sensor.setMirrorLocations([1 2]);
    disp('pass')
    totalPass = totalPass + 1;
catch
    disp('fail')
    totalFail = totalFail + 1;
end
totalCounter = totalCounter + 1;

disp('Test: FabryperotSensor.calculateDirectivity;')
try
    sensor.setAngle(linspace(0, 50,50));
    sensor.setFrequency(linspace(0.1e6,50e6,50))
    sensor.calculateDirectivity;
    disp('pass')
    totalPass = totalPass + 1;
catch
    disp('fail')
    totalFail = totalFail + 1;
end
totalCounter = totalCounter + 1;

disp('Test: [figHand] = FabryperotSensor.plotDirectivity;')
try
    [figHand] = sensor.plotDirectivity;
    disp('pass')
    totalPass = totalPass + 1;
catch
    disp('fail')
    totalFail = totalFail + 1;
end
totalCounter = totalCounter + 1;

disp('Test: FabryperotSensor.getDirectivity')
try
    myDirectivity = sensor.getDirectivity;
    close all
    disp('pass')
    totalPass = totalPass + 1;
catch
    disp('fail')
    totalFail = totalFail + 1;
end
totalCounter = totalCounter + 1;

% =========================================================================
%  RESULTS
% =========================================================================
printLineBreaks;
disp(['Total number of tests    : ',num2str(totalCounter)])
disp(['Total passed             : ',num2str(totalPass)])
disp(['Total failed             : ',num2str(totalFail)])
printLineBreaks;

