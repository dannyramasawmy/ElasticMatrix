function xmin = findClosestMinimum(funHand, startingPoint, increment, maxRange)
    %% findClosestMinimum v1 date:  2019-01-15
    %
    %   Author
    %   Danny Ramasawmy
    %   rmapdrr@ucl.ac.uk
    %
    %   Description
    %   Find the closest minimum in a function (funHand) from a starting point
    %   (startingPoint).
    %
    % x = 1:100;
    % A = (1-cos(2*pi*0.01*x)).*sin(2*pi*0.15*x);
    
    % fun_hand = @(x) (1-cos(2*pi*0.01*x)).*sin(2*pi*0.15*x);
    %
    % x = linspace(1,100,1000);
    %
    % out = fun_hand(x);
    %
    % figure(1), plot(x, out)
    %
    %
    % % starting point
    % starting_point = 16;
    % max_range = 4;
    % increment = 0.5;
    
    
    % arrange vector
    miniVec = ...
        [startingPoint - increment, startingPoint, startingPoint + increment ];
    
    breakout = 1;
    maxExceed = 0;
    while breakout
        
        for idx = 1:3
            threePoints(idx) = abs(funHand(miniVec(idx)));
        end
        
        if threePoints(1) < threePoints(2) && threePoints(2) < threePoints(3)
            
            miniVec = [(miniVec(1)-increment), miniVec(1), miniVec(2)];
            
            
        end
        
        if threePoints(1) > threePoints(2) && threePoints(2) > threePoints(3)
            
            miniVec(1:3) = [miniVec(2), miniVec(3), (miniVec(3)+increment) ];
            
        end
        
        if threePoints(2) < threePoints(1) && threePoints(2) < threePoints(3)
            
            xmin = fminbnd(funHand, miniVec(1), miniVec(3));
            
            %         mini_vec = mini_vec;
            breakout = 0;
        end
        
        if miniVec(1) < (startingPoint - maxRange)
            xmin = startingPoint;
            breakout = 0;
        end
        
        if miniVec(3) > (startingPoint + maxRange)
            
            xmin = startingPoint;
            breakout = 0;
        end
        
        
        if maxExceed > 1000
            xmin = startingPoint;
            breakout = 0;
            % disp('Limit reached')
        end
        
        maxExceed = maxExceed +1;
    end
    
    % figure(1)
    % hold on
    % plot(starting_point, fun_hand(starting_point),'b*')
    % plot(xmin, fun_hand(xmin),'r*')
    % hold off
    
