function sfg()
    %% SpreadFigures
    %
    % Author    :   Danny Ramasawmy
    %               rmapdrr@ucl.ac.uk
    %               dannyramasawmy@gmail.com
    % Date      :   2017-03-31  -   created
    %
    %
    % Description
    %   spread the figures
    
    % get figure handles
    figHandles = findall(0,'Type','figure');
    
    % number of figure handles
    figTot = numel(figHandles);
    
    % get screen size
    screensize = get( groot, 'Screensize' );
%     screensize = [7 68 1908 997];
    sideSqueeze = 10; % pixels off side
    vertSqueeze = 100; % pixels  off top and bottom
    screensize(1) = screensize(1) + sideSqueeze;
    screensize(2) = screensize(2) + vertSqueeze;
    screensize(3) = screensize(3) - sideSqueeze;
    screensize(4) = screensize(4) - 2*vertSqueeze;
    
    flag = 'odd';
    if mod(figTot,2) == 0
        flag = 'even';
    end
    
    height = (screensize(4)-screensize(2)) / 2 -45 ;
    
    
    switch flag
        case 'even'
            width = (screensize(3)-screensize(1)) * 2  / figTot ;
        case 'odd'
            width = (screensize(3) -screensize(1) ) * 2 / (figTot + 1);
    end
    
    widthplus = screensize(1) ;
    for idx = 1:round(figTot/2)
        % set the figure size
        set(figHandles(idx),'Position',[widthplus screensize(2) width height])
        % add stuff to width
        widthplus = widthplus + width + 1;
        % bring up the figure
        figure(figHandles(idx))
    end
    
    widthplus = screensize(1) ;
    for idx = (round(figTot/2)+1):figTot
        % set figure size
        set(figHandles(idx),'Position',[widthplus (height+screensize(2)+89) width height])
        % add stuff to width
        widthplus = widthplus + width;
        % bring up the figure
        figure(figHandles(idx))
    end
    
    drawnow;
    
end






