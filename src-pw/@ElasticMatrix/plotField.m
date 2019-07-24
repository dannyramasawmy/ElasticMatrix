function [figureHandle, obj] = plotField(obj, fieldValues, varargin)
    %PLOTFIELD Plots the displacement and stress field parameters.
    %
    % DESCRIPTION
    %   PLOTFIELD(...) plots the displacement and stress field parameters
    %   for a given range of values. There are multiple types of
    %   figure-styles that can be plotted. These are described below.
    %
    % USEAGE
    %   [figure_handle] = plotField(fieldValues, plot_style);
    %   [figure_handle] = plotField(fieldValues, figure_handle);
    %
    % INPUTS
    %   field_values    - is a cell with two vectors    [units]
    %
    % OPTIONAL INPUTS
    %   []              - there are no optional inputs []
    %
    % OUTPUTS
    %   outputs         - the outputs       [units]
    %
    % DEPENDENCIES
    %   []              - there are no dependencies     []
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 15 - January  - 2019
    %   last update     - 22 - July     - 2019
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
    %
    % inputs:
    %   (fieldValues )
    %   varargin{1} can be a structure of figure handles
    %   or
    %   varargin{1,2,...,n} can be plot types
    %   '1DDisplacement'
    %   '2DDisplacement'
    %   '1DStress'
    %   '2DStress'
    %   'Vector'
    %   'Mesh'
    %   'Surf'
    %   'All'
    %
    % Example:
    %    [figH1] = model.plotField(field, 'Mesh','Vector');
    %   will plot two figures. The figure handle structure will have fields
    %   figH1.mesh, figH1.vector.
    %   If the field is updated, this figure handle can be reused to
    %   prevent multiple figure objects being created. This function will
    %   automatically detect which handles correspond to which figure, this
    %   may be useful when producing a movie of the stress or displacement.
    %   model.plotField(updatedField, figH1);
    
    % =====================================================================
    %   SORT INPUTS
    % =====================================================================
    % check if varargin is a figure handle, if it is then use the
    % a cell with all the figure types
    allFigureTypes = {...
        '1DDisplacement','2DDisplacement','1DStress','2DStress'...
        'Vector','Mesh','Surf'};
    
    % flags
    flagHandle = 0;
    flagSurf = 0;
    flagMesh = 0;
    flagVector = 0;
    flagStress1D = 0;
    flagDisplacement1D = 0;
    flagStress2D = 0;
    flagDisplacement2D = 0;
    
    % error check input field is correct
    if isa(fieldValues, 'double')
        if isnan(fieldValues)
            figureHandle = 0;
            warning('Field is NaN check .calcualteField');
            return;
        end
    end
    
    % sort the inputs
    if isempty(varargin)
        % if no inputs plot everything
        plottingList = {'All'};
        
    elseif isstruct(varargin{1})
        % if the input is a structure, sort
        plotNames = fieldnames(varargin{1});
        figureHandleList = {'displacement1D', 'displacement2D', ...
            'stress1D', 'stress2D', 'vector', 'mesh','surf'};
        
        % loop and compare
        for figureDx = 1:length(plotNames)
            % copy over the plotting lise
            plottingList{figureDx} = allFigureTypes{strcmp(figureHandleList, plotNames{figureDx})};
            % copy over the handle
            figureHandle = varargin{1};
            flagHandle = 1;
        end
        
    else
        % if input is a list of figure types, plot the specific figures
        plottingList = varargin;
    end
    
    % if the all flag is used plot all
    if sum(strcmp(plottingList,'All')) > 0
        plottingList = allFigureTypes;
    end
    
    % open figure handle to mesh plot if desired
    if sum(strcmp(plottingList,'Surf')) > 0
        if flagHandle ~= 1
            figureHandle.surf = figure;
        end
        flagSurf = 1;
    end
    
    % open figure handle to mesh plot if desired
    if sum(strcmp(plottingList,'Mesh')) > 0
        if flagHandle ~= 1
            figureHandle.mesh = figure;
        end
        flagMesh = 1;
    end
    
    % open figure handle to mesh plot if desired
    if sum(strcmp(plottingList,'Vector')) > 0
        if flagHandle ~= 1
            figureHandle.vector = figure;
        end
        flagVector = 1;
    end
    
    % open figure handle to mesh plot if desired
    if sum(strcmp(plottingList,'1DStress')) > 0
        if flagHandle ~= 1
            figureHandle.stress1D = figure;
        end
        flagStress1D = 1;
    end
    
    % open figure handle to mesh plot if desired
    if sum(strcmp(plottingList,'1DDisplacement')) > 0
        if flagHandle ~= 1
            figureHandle.displacement1D = figure;
        end
        flagDisplacement1D = 1;
    end
    
    % open figure handle to mesh plot if desired
    if sum(strcmp(plottingList,'2DStress')) > 0
        if flagHandle ~= 1
            figureHandle.stress2D = figure;
        end
        flagStress2D = 1;
    end
    
    % open figure handle to mesh plot if desired
    if sum(strcmp(plottingList,'2DDisplacement')) > 0
        if flagHandle ~= 1
            figureHandle.displacement2D = figure;
        end
        flagDisplacement2D = 1;
    end
    
    % just incase no variables matched
    if ~exist('figureHandle')
        warning('Incorrect plot type, use help(''plotField'') to find correct inputs')
        figureHandle = 0;
        return;
    end
    % =====================================================================
    %   PLOTTING INFORMATION
    % =====================================================================
    
    % generate mesh coordinates
    [Z, X] = meshgrid(fieldValues.z_vector, fieldValues.x_vector);
    
    % plot mesh
    if flagSurf == 1
        [figureHandle] = plotSurf(Z,X,fieldValues,figureHandle);
    end
    
    % plot mesh
    if flagMesh == 1
        figureHandle = plotMesh(Z,X,fieldValues,figureHandle);
    end
    
    % plot vector
    if flagVector == 1
        figureHandle = plotVector(Z,X,fieldValues, figureHandle);
    end
    
    % position location for 1D plot (slice along x = 0)
    xSamplePosition = round(length(fieldValues.x_vector)/2);
    
    % plot 1D stress
    if flagStress1D == 1
        figureHandle = plot1DStress(fieldValues, figureHandle, xSamplePosition);
    end
    
    % plot 1D displacement
    if flagDisplacement1D == 1
        figureHandle = plot1DDisplacement(fieldValues, figureHandle, xSamplePosition);
    end
    
    % plot 2D stress
    if flagStress2D == 1
        figureHandle = plot2DStress(fieldValues, figureHandle);
    end
    
    % plot 2D displacements
    if flagDisplacement2D == 1
        figureHandle = plot2DDisplacement(fieldValues, figureHandle);
    end
    % =====================================================================
    %   OVERLAY INTERFACES
    % =====================================================================
    
    % add the interfaces between each layer
    figureHandle = addInterfaces(figureHandle, fieldValues.x_vector, obj.medium);
    
    
end

function [figureHandle] = addInterfaces(figureHandle, x_vector, medium)
    % =====================================================================
    %   ADD LAYER INTERFACE
    % =====================================================================
    
    % for each interface
    interfaceLocations = [0];
    
    if length(medium) > 2
        % interface locations
        for layerDx = 2:(length(medium)-1)
            interfaceLocations(layerDx) = ...
                interfaceLocations(layerDx-1) - medium(layerDx).thickness;
        end
    end
    
    % get the field names required
    figureFields = fieldnames(figureHandle);
    
    % loop over each available figure
    for figureDx = 1:length(figureFields)
        % each plot requires a slighlty different interface plot
        switch figureFields{figureDx}
            
            case {'mesh', 'vector'}
                % get figure
                figure(figureHandle.(figureFields{figureDx}))
                % loop over each interface location and plot a horizontal
                % line
                for idx = 1:length(interfaceLocations)
                    hold on
                    plot([x_vector(1),x_vector(end)], ...
                        [interfaceLocations(idx),interfaceLocations(idx)],'r')
                    hold off
                end
                
            case {'stress1D','displacement1D'}
                % get figure
                figure(figureHandle.(figureFields{figureDx}))
                % loop over each interface location and plot a vertical
                % line
                for idx = 1:length(interfaceLocations)
                    hold on
                    plot([interfaceLocations(idx),interfaceLocations(idx)],...
                        [-1,1],'r')
                    hold off
                end
                
            case {'stress2D', 'displacement2D' }
                % get figure
                figure(figureHandle.(figureFields{figureDx}))
                
                for plotDx = 1:2
                    subplot(1,2,plotDx)
                    % loop over each interface location and plot a horizontal
                    % line
                    for idx = 1:length(interfaceLocations)
                        hold on
                        plot([x_vector(1),x_vector(end)], ...
                            [interfaceLocations(idx),interfaceLocations(idx)],'k')
                        hold off
                    end
                end
                
            otherwise
                % warning('No figure specified.') % DEBUG
        end
    end
end

function [figureHandle] = plot2DDisplacement(fieldValues, figureHandle)
    % =====================================================================
    %   PLOT 2D DISPLACEMENTS
    % =====================================================================
    % plot the z and x displacements
    figure(figureHandle.displacement2D);
    
    % z displacement
    subplot(1,2,1)
    % plot the z displacement
    imagesc(fieldValues.x_vector, fieldValues.z_vector, real(fieldValues.z_displacement(:,:))' );
    title('Real Displacement u_z ');
    
    % x displacment
    subplot(1,2,2)
    % plot the x displacement
    imagesc(fieldValues.x_vector, fieldValues.z_vector, real(fieldValues.x_displacement(:,:))' );
    title('Real Displacement u_x');
    
    % add labels
    for plotDx = 1:2
        subplot(1,2,plotDx)
        % labels
        ylabel('Z [m]');
        xlabel('X [m]');
        axis xy;
        colorbar;
        colormap hot;
        
    end
    
end

function [figureHandle] = plot2DStress(fieldValues, figureHandle)
    % =====================================================================
    %   PLOT 2D STRESS
    % =====================================================================
    % plot the z and x stress
    figure(figureHandle.stress2D);
    
    % z displacement
    subplot(1,2,1)
    % plot the z displacement
    imagesc(fieldValues.x_vector, fieldValues.z_vector, real(fieldValues.sigma_zz(:,:))' );
    title('Real Stress \sigma_z_z');
    
    % x displacment
    subplot(1,2,2)
    % plot the x displacement
    imagesc(fieldValues.x_vector, fieldValues.z_vector, real(fieldValues.sigma_xz(:,:))' );
    title('Real Stress \sigma_x_z');
    
    % add labels
    for plotDx = 1:2
        subplot(1,2,plotDx)
        % labels
        ylabel('Z [m]');
        xlabel('X [m]');
        axis xy;
        colorbar;
        colormap hot;
    end
end

function [figureHandle] = plot1DDisplacement(fieldValues, figureHandle, xSamplePosition)
    % =====================================================================
    %   PLOT 1D DISPLACMENTS
    % =====================================================================
    figure(figureHandle.displacement1D);
    
    % calculate the normalised displacement
    oneDimZ = normMe(real(...
        fieldValues.z_displacement(xSamplePosition,:)...
        ));
    oneDimx = normMe(real(...
        fieldValues.x_displacement(xSamplePosition,:)...
        ));
    
    % plot 1D displacement
    figure(figureHandle.displacement1D);
    % plot z displacement
    plot(fieldValues.z_vector,oneDimZ,'k')
    % plot x displacement
    hold on
    plot(fieldValues.z_vector,oneDimx,'k--')
    hold off
    % labels
    title('Displacement 1D');
    xlabel('Depth [\mum]');
    ylabel('Normalised Displacement');
    ylim([-1 1])
    xlim([fieldValues.z_vector(1) fieldValues.z_vector(end)])
    legend('u_z','u_x')
    
end

function [figureHandle] = plot1DStress(fieldValues, figureHandle, xSamplePosition)
    % =====================================================================
    %   PLOT 1D STRESS
    % =====================================================================
    
    % plot 1D stress
    figure(figureHandle.stress1D);
    
    % calculate the normalised displacement
    one_dim_sigma_zz = normMe(real(...
        fieldValues.sigma_zz(xSamplePosition,:)...
        ));
    oneDimSigmaXZ = normMe(real(...
        fieldValues.sigma_xz(xSamplePosition,:)...
        ));
    
    % plot z displacement
    plot(fieldValues.z_vector,one_dim_sigma_zz,'k')
    % plot x displacement
    hold on
    plot(fieldValues.z_vector,oneDimSigmaXZ,'k--')
    hold off
    % labels
    title('Stress 1D');
    xlabel('Depth [\mum]');
    ylabel('Normalised Stress');
    ylim([-1 1])
    xlim([fieldValues.z_vector(1) fieldValues.z_vector(end)])
    legend('\sigma_z_z','\sigma_x_z')
    
    
end

function [figureHandle] = plotVector(Z,X,fieldValues, figureHandle)
    % =====================================================================
    %   PLOT VECTOR
    % =====================================================================
    figure(figureHandle.vector);
    hold off
    %                 subplot(1,2,1)
    % down sample, as there are too many points
    sam = 1;
    
    %                 % make the u and v vectors for quiver; normalise arrows
    v = real(fieldValues.x_displacement(1:sam:end,1:sam:end)) / max(abs(fieldValues.x_displacement(:)));
    u = real(fieldValues.z_displacement(1:sam:end,1:sam:end)) / max(abs(fieldValues.z_displacement(:)));
    
    % need to down-sample mesh grid as well
    Z2 = Z(1:sam:end,1:sam:end);
    X2 = X(1:sam:end,1:sam:end);
    
    quiver(X2,Z2,v,u,0.6,'k');
    
    % label the graph
    ylabel('z [m]')
    xlabel('x [m]')
    title('Vector Field of Normalised Displacement')
    
    % plot border gap between the borders
    pBG = 0.00005;
    
    % reduce axis size
    ylim([ min(fieldValues.z_vector)-pBG, max(fieldValues.z_vector)+pBG])
    xlim([ min(fieldValues.x_vector)-pBG, max(fieldValues.x_vector)+pBG])
end

function [figureHandle] = plotMesh(Z,X,fieldValues,figureHandle)
    % =====================================================================
    %   PLOT MESH
    % =====================================================================
    
    % scaling factor (add an exaggerated displacment to each coordinate in
    % the Z,X mesh)
    %     fact  = 1.5e3;
    % some auto scaling
    fact =  3.5520e-05 / sqrt(max(real(fieldValues.z_displacement(:)).^2)+ max(real(fieldValues.x_displacement(:)).^2));
    %     fact = 10;
    
    % sampling interval
    samp = 1;
    
    % create horizontal lines
    horizX = X(1:samp:end,1:samp:end) + fact * real(fieldValues.x_displacement(1:samp:end,1:samp:end));
    horizY = Z(1:samp:end,1:samp:end) + fact * real(fieldValues.z_displacement(1:samp:end,1:samp:end));
    
    % create vertical lines
    vertX = X(1:samp:end,1:samp:end)' + fact * real(fieldValues.x_displacement(1:samp:end,1:samp:end))';
    vertY = Z(1:samp:end,1:samp:end)' + fact * real(fieldValues.z_displacement(1:samp:end,1:samp:end))';
    
    % open figure
    figure(figureHandle.mesh);
    
    
    % plot horizontal lines
    plot( horizX, horizY, 'k')
    hold on
    plot( vertX,  vertY,  'k')
    hold off
    % labels
    title('Mesh Displacement Plot')
    plotBorderGap = 0.00005;
    ylim( [fieldValues.z_vector(1) - plotBorderGap, fieldValues.z_vector(end) + plotBorderGap])
    xlim( [fieldValues.x_vector(1) - plotBorderGap, fieldValues.x_vector(end) + plotBorderGap])
    box on
    xlabel('X [m]')
    ylabel('Z [m]')
    % force update
    drawnow;
    
end

function [figureHandle] = plotSurf(Z,X,fieldValues,figureHandle)
    % =====================================================================
    %   PLOT MESH
    % =====================================================================
    % open figure
    figure(figureHandle.surf);
    
    % surf plot
    surf(X,Z, sqrt(real(fieldValues.z_displacement).^2 + real(fieldValues.x_displacement).^2 ) )
    
    % surf plot
    surf(X,Z, real(fieldValues.sigma_zz) )
    
    
    % labels
    view(-35,70)
    xlabel('X [m]')
    ylabel('Z [m]')
    
end





