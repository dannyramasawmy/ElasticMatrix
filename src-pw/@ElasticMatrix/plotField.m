function [figure_handle, obj] = plotField(obj, fields, varargin)
    %PLOTFIELD Plots the displacement and stress field parameters.
    %
    % DESCRIPTION
    %   PLOTFIELD(...) plots the displacement and stress field parameters
    %   for a given range of values. There are multiple types of
    %   figure-styles that can be plotted which are described below. Before
    %   using this function use [field] = .calculateField to get a
    %   structure which contains the displacement and stress values. This
    %   function will only plot the structure that is returned from
    %   .calculateField.
    %
    % USEAGE
    %   [figure_handle] = plotField(field_struct, plot_style);
    %   [figure_handle] = plotField(field_struct, plot_style_1, ...
    %       plot_style_2, ..., plot_style_n);
    %   [figure_handle] = plotField(field_struct, figure_handle);
    %
    % INPUTS
    %   fields                  - Structure with the calculated fields.
    %   fields.z_vector         - 1D vector of z-range.         [m]
    %   fields.x_vector         - 1D vector of x-range.         [m]
    %   fields.x_displacement   - 2D matrix of x-displacements. [m]
    %   fields.z_displacement   - 2D matrix of z-displacements. [m]
    %   fields.sigma_zz         - 2D matrix of normal stress.   [Pa]
    %   fields.sigma_xz         - 2D matrix of shear stress.    [Pa]
    %
    % OPTIONAL INPUTS
    %   plot_style              - Plot style to use, (string).   []
    %                           - All displacement in. [m]
    %                           - All stress in [Pa]
    %       'displacement1D'    - x and z displacement along x = 0, z =
    %                             z_vector.
    %       'displacement2D'    - x and z displacement over the grid
    %                             defined by z_vector and x_vector
    %       'stress1D'          - normal and shear stress along x = 0, z =
    %                             z_vector.
    %       'stress2D'          - Normal and shear stress over the grid
    %                             defined by z_vector and x_vector.
    %       'vector'            - 2D vector field over the grid defined by
    %                             x_vector and z_vector, displacement.
    %       'mesh'              - 2D mesh field over the grid defined by
    %                             x_vector and z_vector.
    %       'surf'              - 3D surface plot of normal stress
    %                             over the grid defined by z_vector and
    %                             x_vector.
    %       'all'               - Plots all of the above.
    %
    %   figure_handle           - This is the figure handle returned by the
    %                             function .plotField. Using it as the
    %                             input plots the same plot_style using the
    %                             same figure handle. Use this for asking
    %                             movies and to minimize the number of new
    %                             figures being created.
    %
    % OUTPUTS
    %   outputs         - The outputs.       [units]
    %
    % DEPENDENCIES
    %   []              - There are no dependencies.    []
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 15 - January      - 2019
    %   last update     - 04 - September    - 2019
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
    
    % =====================================================================
    %   SORT INPUTS
    % =====================================================================
    % check if varargin is a figure handle, if it is then use the
    % a cell with all the figure types
    all_figure_types = {...
        'displacement1D','displacement2D','stress1D','stress2D'...
        'vector','mesh','surf'};
    
    
    % flags
    flag_handle = 0;
    flag_surf = 0;
    flag_mesh = 0;
    flag_vector = 0;
    flag_stress1D = 0;
    flag_displacement1D = 0;
    flag_stress2D = 0;
    flag_displacement2D = 0;
    
    % error check input field is correct
    if isa(fields, 'double')
        if isnan(fields)
            figure_handle = 0;
            warning('Field is NaN check .calcualteField');
            return;
        end
    end
    
    % sort the inputs
    if isempty(varargin)
        % if no inputs plot everything
        plotting_list = {'all'};
        
    elseif isstruct(varargin{1})
        % if the input is a structure, sort
        plot_names = fieldnames(varargin{1});
        figure_handle_list = {'displacement1D', 'displacement2D', ...
            'stress1D', 'stress2D', 'vector', 'mesh','surf'};
        
        % loop and compare
        for figure_idx = 1:length(plot_names)
            % copy over the plotting list
            plotting_list{figure_idx} = ...  
                all_figure_types{...
                strcmp(figure_handle_list, plot_names{figure_idx}) }; %#ok<AGROW>
            % copy over the handle
            figure_handle = varargin{1};
            flag_handle = 1;
        end
        
    else
        % if input is a list of figure types, plot the specific figures
        plotting_list = varargin;
    end
    
    % if the all flag is used plot all
    if sum(strcmp(plotting_list,'all')) > 0
        plotting_list = all_figure_types;
    end
    
    % open figure handle to mesh plot if desired
    if sum(strcmp(plotting_list,'surf')) > 0
        if flag_handle ~= 1
            figure_handle.surf = figure;
        end
        flag_surf = 1;
    end
    
    % open figure handle to mesh plot if desired
    if sum(strcmp(plotting_list,'mesh')) > 0
        if flag_handle ~= 1
            figure_handle.mesh = figure;
        end
        flag_mesh = 1;
    end
    
    % open figure handle to mesh plot if desired
    if sum(strcmp(plotting_list,'vector')) > 0
        if flag_handle ~= 1
            figure_handle.vector = figure;
        end
        flag_vector = 1;
    end
    
    % open figure handle to mesh plot if desired
    if sum(strcmp(plotting_list,'stress1D')) > 0
        if flag_handle ~= 1
            figure_handle.stress1D = figure;
        end
        flag_stress1D = 1;
    end
    
    % open figure handle to mesh plot if desired
    if sum(strcmp(plotting_list,'displacement1D')) > 0
        if flag_handle ~= 1
            figure_handle.displacement1D = figure;
        end
        flag_displacement1D = 1;
    end
    
    % open figure handle to mesh plot if desired
    if sum(strcmp(plotting_list,'stress2D')) > 0
        if flag_handle ~= 1
            figure_handle.stress2D = figure;
        end
        flag_stress2D = 1;
    end
    
    % open figure handle to mesh plot if desired
    if sum(strcmp(plotting_list,'displacement2D')) > 0
        if flag_handle ~= 1
            figure_handle.displacement2D = figure;
        end
        flag_displacement2D = 1;
    end
    
    % just incase no variables matched
    if ~exist('figure_handle','var')
        warning('Incorrect plot type, use help(''plotField'') to find correct inputs')
        figure_handle = 0;
        return;
    end
    % =====================================================================
    %   PLOTTING INFORMATION
    % =====================================================================
    
    % generate mesh coordinates
    [Z, X] = meshgrid(fields.z_vector, fields.x_vector);
    
    % plot mesh
    if flag_surf == 1
        [figure_handle] = plotSurf(Z,X,fields,figure_handle);
    end
    
    % plot mesh
    if flag_mesh == 1
        figure_handle = plotMesh(Z,X,fields,figure_handle);
    end
    
    % plot vector
    if flag_vector == 1
        figure_handle = plotVector(Z,X,fields, figure_handle);
    end
    
    % position location for 1D plot (slice along x = 0)
    x_sample_position = round(length(fields.x_vector)/2);
    
    % plot 1D stress
    if flag_stress1D == 1
        figure_handle = plot1DStress(fields, figure_handle, x_sample_position);
    end
    
    % plot 1D displacement
    if flag_displacement1D == 1
        figure_handle = plot1DDisplacement(fields, figure_handle, x_sample_position);
    end
    
    % plot 2D stress
    if flag_stress2D == 1
        figure_handle = plot2DStress(fields, figure_handle);
    end
    
    % plot 2D displacements
    if flag_displacement2D == 1
        figure_handle = plot2DDisplacement(fields, figure_handle);
    end
    % =====================================================================
    %   OVERLAY INTERFACES
    % =====================================================================
    
    % add the interfaces between each layer
    figure_handle = addInterfaces(figure_handle, fields.x_vector, obj.medium);
    
    
end

function [figure_handle] = addInterfaces(figure_handle, x_vector, medium)
    %ADDINTERFACES Adds red interface lines to the other plots.
    %
    % DESCRIPTION
    %   ADDINTERFACES adds lines to the different plot-styles in
    %   .plotField. These lines correspond to the coordinates between
    %   interfaces.
    %
    % USAGE
    %   [figure_handle] = addInterfaces(figure_handle, x_vector, medium);
    %
    % INPUTS / OUTPUTS
    %   See .plotField header.
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 15 - January  - 2019
    %   last update     - 23 - July     - 2019
    
    
    % for each interface
    interface_locations = 0;
    
    if length(medium) > 2
        % interface locations
        for layer_idx = 2:(length(medium)-1)
            interface_locations(layer_idx) = ...
                interface_locations(layer_idx-1) ...
                - medium(layer_idx).thickness; %#ok<AGROW>
        end
    end
    
    % get the field names required
    figure_fields = fieldnames(figure_handle);
    
    % loop over each available figure
    for figure_idx = 1:length(figure_fields)
        % each plot requires a slightly different interface plot
        switch figure_fields{figure_idx}
            
            case {'mesh', 'vector'}
                % get figure
                figure(figure_handle.(figure_fields{figure_idx}))
                % loop over each interface location and plot a horizontal
                % line
                for idx = 1:length(interface_locations)
                    hold on
                    plot([x_vector(1),x_vector(end)], ...
                        [interface_locations(idx),interface_locations(idx)],'r')
                    hold off
                end
                
            case {'stress1D','displacement1D'}
                % get figure
                figure(figure_handle.(figure_fields{figure_idx}))
                % loop over each interface location and plot a vertical
                % line
                for idx = 1:length(interface_locations)
                    hold on
                    plot([interface_locations(idx),interface_locations(idx)],...
                        [-1,1],'r')
                    hold off
                end
                
            case {'stress2D', 'displacement2D' }
                % get figure
                figure(figure_handle.(figure_fields{figure_idx}))
                
                for plot_idx = 1:2
                    subplot(1,2,plot_idx)
                    % loop over each interface location and plot a horizontal
                    % line
                    for idx = 1:length(interface_locations)
                        hold on
                        plot([x_vector(1),x_vector(end)], ...
                            [interface_locations(idx),interface_locations(idx)],'k')
                        hold off
                    end
                end
                
            otherwise
                % warning('No figure specified.') % DEBUG
        end
    end
end

function [figure_handle] = plot2DDisplacement(field_values, figure_handle)
    %PLOT2DDISPLACEMENT Plots ux and uz displacement fields.
    %
    % DESCRIPTION
    %   PLOT2DDISPLACEMENT plots the ux and uz displacement field.
    %
    % USAGE
    %   [figure_handle] = plot2DDisplacement(field_values,figure_handle);
    %
    % INPUTS / OUTPUTS
    %   See .plotField header.
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 15 - January  - 2019
    %   last update     - 23 - July     - 2019
    
    % plot the z and x displacements
    figure(figure_handle.displacement2D);
    
    % z displacement
    subplot(1,2,1)
    % plot the z displacement
    imagesc(field_values.x_vector, field_values.z_vector, ...
        real(field_values.z_displacement(:,:))' );
    title('Real Displacement u_z ');
    
    % x displacment
    subplot(1,2,2)
    % plot the x displacement
    imagesc(field_values.x_vector, field_values.z_vector, ...
        real(field_values.x_displacement(:,:))' );
    title('Real Displacement u_x');
    
    % add labels
    for plot_idx = 1:2
        subplot(1,2,plot_idx)
        % labels
        ylabel('Z [m]');
        xlabel('X [m]');
        axis xy image;
        colorbar;
        colormap hot;
        
    end
    
end

function [figure_handle] = plot2DStress(field_values, figure_handle)
    %PLOT2DSTRESS Plots normal and shear stress fields.
    %
    % DESCRIPTION
    %   PLOT2DSTRESS plots the normal and shear stress fields.
    %
    % USAGE
    %   [figure_handle] = plot2DStress(field_values,figure_handle);
    %
    % INPUTS / OUTPUTS
    %   See .plotField header.
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 15 - January  - 2019
    
    % plot the z and x stress
    figure(figure_handle.stress2D);
    
    % z displacement
    subplot(1,2,1)
    % plot the z displacement
    imagesc(field_values.x_vector, field_values.z_vector, ...
        real(field_values.sigma_zz(:,:))' );
    title('Real Stress \sigma_z_z');
    
    % x displacment
    subplot(1,2,2)
    % plot the x displacement
    imagesc(field_values.x_vector, field_values.z_vector, ...
        real(field_values.sigma_xz(:,:))' );
    title('Real Stress \sigma_x_z');
    
    % add labels
    for plot_idx = 1:2
        subplot(1,2,plot_idx)
        % labels
        ylabel('Z [m]');
        xlabel('X [m]');
        axis xy image;
        colorbar;
        colormap hot;
    end
end

function [figure_handle] = plot1DDisplacement(field_values, figure_handle, ...
        x_sample_position)
    %PLOT1DDISPLACEMENT Plots ux and uz displacement fields.
    %
    % DESCRIPTION
    %   PLOT1DDISPLACEMENT plots the ux and uz displacement field along the
    %   coordinates x = x_sample_position, z = z_vector.
    %
    % USAGE
    %   [figure_handle] = plot1DDisplacement(field_values,figure_handle,...
    %       x_sample_position);
    %
    % INPUTS / OUTPUTS
    %   See .plotField header.
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 15 - January  - 2019
    %   last update     - 23 - July     - 2019
    
    figure(figure_handle.displacement1D);
    
    % calculate the normalised displacement
    one_dim_z = normMe(real(...
        field_values.z_displacement(x_sample_position,:)...
        ));
    one_dim_x = normMe(real(...
        field_values.x_displacement(x_sample_position,:)...
        ));
    
    % plot 1D displacement
    figure(figure_handle.displacement1D);
    % plot z displacement
    plot(field_values.z_vector,one_dim_z,'k')
    % plot x displacement
    hold on
    plot(field_values.z_vector,one_dim_x,'k--')
    hold off
    % labels
    title('Displacement 1D');
    xlabel('Depth [\mum]');
    ylabel('Normalised Displacement');
    ylim([-1 1])
    xlim([field_values.z_vector(1) field_values.z_vector(end)])
    legend('u_z','u_x','AutoUpdate','off')
    
end

function [figure_handle] = plot1DStress(field_values, figure_handle, ...
        x_sample_position)
    %PLOT1DSTRESS Plots normal and shear stress fields.
    %
    % DESCRIPTION
    %   PLOT1DSTRESS plots the normal and shear stress field along the
    %   coordinates x = x_sample_position, z = z_vector.
    %
    % USAGE
    %   [figure_handle] = plot1DStress(field_values,figure_handle,...
    %       x_sample_position);
    %
    % INPUTS / OUTPUTS
    %   See .plotField header.
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 15 - January  - 2019
    %   last update     - 23 - July     - 2019
    
    % plot 1D stress
    figure(figure_handle.stress1D);
    
    % calculate the normalised displacement
    one_dim_sigma_zz = normMe(real(...
        field_values.sigma_zz(x_sample_position,:)...
        ));
    one_dim_sigma_xz = normMe(real(...
        field_values.sigma_xz(x_sample_position,:)...
        ));
    
    % plot z displacement
    plot(field_values.z_vector,one_dim_sigma_zz,'k')
    % plot x displacement
    hold on
    plot(field_values.z_vector,one_dim_sigma_xz,'k--')
    hold off
    % labels
    title('Stress 1D');
    xlabel('Depth [\mum]');
    ylabel('Normalised Stress');
    ylim([-1 1])
    xlim([field_values.z_vector(1) field_values.z_vector(end)])
    legend('\sigma_z_z','\sigma_x_z','AutoUpdate','off')
    
    
end

function [figure_handle] = plotVector(Z,X,field_values, figure_handle)
    %PLOTVECTOR Plots ux and uz displacement as a vector field.
    %
    % DESCRIPTION
    %   PLOTVECTOR plots the ux and uz displacement as a vector
    %   field.
    %
    % USAGE
    %   [figure_handle] = plotVector(Z,Xfield_values,figure_handle);
    %
    % INPUTS / OUTPUTS
    %   See .plotField header.
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 15 - January  - 2019
    %   last update     - 23 - July     - 2019
    
    figure(figure_handle.vector);
    hold off
    %                 subplot(1,2,1)
    % down sample, as there are too many points
    sam = 1;
    
    % make the u and v vectors for quiver; normalise arrows
    v = real(field_values.x_displacement(1:sam:end,1:sam:end)) / ...
        max(abs(field_values.x_displacement(:)));
    u = real(field_values.z_displacement(1:sam:end,1:sam:end)) / ...
        max(abs(field_values.z_displacement(:)));
    
    % need to down-sample mesh grid as well
    Z2 = Z(1:sam:end,1:sam:end);
    X2 = X(1:sam:end,1:sam:end);
    
    quiver(X2,Z2,v,u,0.6,'k');
    
    % label the graph
    ylabel('z [m]')
    xlabel('x [m]')
    title('Vector Field of Normalized Displacement')
    
    % plot border gap between the borders
    pBG = 0.00005;
    
    % reduce axis size
    ylim([ min(field_values.z_vector)-pBG, max(field_values.z_vector)+pBG])
    xlim([ min(field_values.x_vector)-pBG, max(field_values.x_vector)+pBG])
end

function [figure_handle] = plotMesh(Z,X,field_values,figure_handle)
    %PLOTMESH Plots ux and uz displacement as a vector field.
    %
    % DESCRIPTION
    %   PLOTMESH plots the ux and uz displacement as a mesh field.
    %
    % USAGE
    %   [figure_handle] = plotMesh(Z, X, field_values, figure_handle);
    %
    % INPUTS / OUTPUTS
    %   See .plotField header.
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 15 - January  - 2019
    %   last update     - 23 - July     - 2019
    
    % scaling factor (add an exaggerated displacement to each coordinate in
    % the Z,X mesh)
    
    % some auto scaling
    fact =  3.5520e-05 / ...
        sqrt(max(real(field_values.z_displacement(:)).^2) + ...
        max(real(field_values.x_displacement(:)).^2));
    
    % sampling interval
    samp = 1;
    
    % create horizontal lines
    horiz_x = X(1:samp:end,1:samp:end) + ...
        fact * real(field_values.x_displacement(1:samp:end,1:samp:end));
    horiz_y = Z(1:samp:end,1:samp:end) + ...
        fact * real(field_values.z_displacement(1:samp:end,1:samp:end));
    
    % create vertical lines
    vert_x = X(1:samp:end,1:samp:end)' + ...
        fact * real(field_values.x_displacement(1:samp:end,1:samp:end))';
    vert_y = Z(1:samp:end,1:samp:end)' + ...
        fact * real(field_values.z_displacement(1:samp:end,1:samp:end))';
    
    % open figure
    figure(figure_handle.mesh);
    
    
    % plot horizontal lines
    plot( horiz_x, horiz_y, 'k')
    hold on
    plot( vert_x,  vert_y,  'k')
    hold off
    % labels
    title('Mesh Displacement Plot')
    plotBorderGap = 0.00005;
    box on
    xlabel('X [m]')
    ylabel('Z [m]')
    % plot limits
    ylim( [field_values.z_vector(1) - plotBorderGap, ...
        field_values.z_vector(end) + plotBorderGap])
    xlim( [field_values.x_vector(1) - plotBorderGap, ...
        field_values.x_vector(end) + plotBorderGap])
    % force update
    drawnow;
    
end

function [figure_handle] = plotSurf(Z,X,field_values,figure_handle)
    %PLOTSURF Plots normal and shear stress fields with surf.
    %
    % DESCRIPTION
    %   PLOTSURF plots the normal and shear stress fields as a surface
    %   plot.
    %
    % USAGE
    %   [figure_handle] = plotSurf(field_values,figure_handle);
    %
    % INPUTS / OUTPUTS
    %   See .plotField header.
    %
    % ABOUT
    %   author          - Danny Ramasawmy
    %   contact         - dannyramasawmy+elasticmatrix@gmail.com
    %   date            - 15 - January  - 2019
    %   last update     - 23 - July     - 2019
    
    % open figure
    figure(figure_handle.surf);
    
    % surf plot with absolute displacement
    % surf(X,Z, sqrt(real(field_values.z_displacement).^2 + ...
    %    real(field_values.x_displacement).^2 ) )
    
    % surf plot
    surf(X,Z, real(field_values.sigma_zz) )
    
    % labels
    view(-35,70)
    xlabel('X [m]')
    ylabel('Z [m]')
    
end





