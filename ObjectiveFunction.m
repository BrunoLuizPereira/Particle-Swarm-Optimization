function fitnessValue = ObjectiveFunction(x)
% Example objective function to be minimized.
%
%   f(x) = x(1)^2 + x(2)^2 + 10

fitnessValue = x(1)*x(1) + x(2)*x(2) + 10;
end
