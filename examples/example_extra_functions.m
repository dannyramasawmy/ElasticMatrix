%% Example: Extra Functions
% Additional functions are described here.

%% cls
% cls clears the workspace, command window and closes all open figures.
cls;

%% sfg
% sfg finds all open MATLAB figures, then distributes them evenly across
% the full-screen.
for idx = 1:6
    figure
end

sfg;

%% findClosest
% findClosest finds the closest element in an array to an input x. The
% value x is taken away from the vector x_list, the absolute value is taken
% and the minimum value is found and returned. Note, this function has the
% same name as a function included in the k-wave toolbox.

% Find the closest value in the list:
x_list = [6, 5, 4, 3, 2, 1];
x = 2.1;
[closest_value, index] = findClosest(x_list, x);

% Display the results:
disp(closest_value)
disp(index)


