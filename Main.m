clc
clear
close all

%% Search-space bounds
% Bounds are provided as [lower1 upper1 lower2 upper2 ...].
searchBounds = [-5 +2 -5 +3];

%% Particle Swarm Optimization parameters
maxIterations = 100;
numParticles = 50;
w = 0.7;
c1 = 1.5;
c2 = 1.5;

%% Run Particle Swarm Optimization
[bestPosition, bestFitness, convergenceCurve] = ...
    ParticleSwarmOptimization(@ObjectiveFunction, searchBounds, ...
    maxIterations, numParticles, w, c1, c2);

%% Display results
fprintf('Best decision variables: \n');
disp(bestPosition)

fprintf('Best objective-function value: %.6f \n', bestFitness);

%% Plot the convergence curve
figure
plot(convergenceCurve, 'LineWidth', 1.5)
xlabel('Iteration')
ylabel('Best Objective-Function Value')
title('Particle Swarm Optimization Convergence')
grid on
box on
