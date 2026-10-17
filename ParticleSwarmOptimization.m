function [bestPosition, bestFitness, convergenceCurve] = ParticleSwarmOptimization( ...
    objectiveFunction, bounds, maxIterations, numParticles, w, c1, c2, ...
    absConvCounterLimit, relConvCounterLimit)

if nargin < 3
    maxIterations = 100; % Default value for maxIterations
end
if nargin < 4
    numParticles = 50;
end
if nargin < 5
    w = 0.7; % Inertia weight [0.7 - 0.9]
end
if nargin < 6
    c1 = 1.5; % Cognitive coefficient [1.5 - 2.0]
end
if nargin < 7
    c2 = 1.5; % Social coefficient [1.5 - 2.0]
end
if nargin < 8
    absConvCounterLimit = 10000;
end
if nargin < 9
    relConvCounterLimit = 10000;
end

numVariables = length(bounds)/2;

% Initialize particle positions and velocities
X = zeros(numParticles, numVariables); % Particle positions (normalized to [0,1])
V = zeros(numParticles, numVariables); % Particle velocities
objectiveValues = zeros(numParticles, 1); % Objective-function value for each particle

% Personal and global best positions
Pbest = X; % Personal best positions
fPbest = inf(numParticles, 1); % Objective values at personal best positions
Gbest = zeros(1, numVariables); % Global best position
fGbest = inf; % Objective value at the global best position

% Define the search bounds for the decision variables
lowerBounds = bounds(1:2:end-1);
upperBounds = bounds(2:2:end);

% INITIALIZE PARTICLES
for i = 1:numParticles
    for j = 1:numVariables
        X(i,j) = rand; % Random initial position in [0,1]
        V(i,j) = (rand - 0.5) * 0.1; % Small initial velocity
    end
end

% EVALUATE INITIAL PARTICLE POSITIONS
for i = 1:numParticles
    % Map the normalized position to the original search space
    decisionVariables = (upperBounds - lowerBounds) .* X(i,:) + lowerBounds;
    objectiveValues(i) = objectiveFunction(decisionVariables);

    % Initialize the personal best
    Pbest(i,:) = X(i,:);
    fPbest(i) = objectiveValues(i);

    % Update the global best
    if objectiveValues(i) < fGbest
        fGbest = objectiveValues(i);
        Gbest = X(i,:);
    end
end

iterationCounter = 0;
continueIterations = 1;
absConvergenceReached = 0;
relConvergenceReached = 0;
absConvCounter = 0;
relConvCounter = 0;
previousBestFitness = inf;
convergenceCurve = zeros(1, maxIterations);

% START PSO
while (continueIterations)
    iterationCounter = iterationCounter + 1;
    fprintf('Iteration counter: %d \n', iterationCounter);

    % UPDATE PARTICLE VELOCITIES AND POSITIONS
    for i = 1:numParticles
        for j = 1:numVariables
            % Update velocity
            r1 = rand;
            r2 = rand;
            V(i,j) = w * V(i,j) + c1 * r1 * (Pbest(i,j) - X(i,j)) + c2 * r2 * (Gbest(j) - X(i,j));

            % Limit velocity (optional, for stability)
            Vmax = 0.5;
            if V(i,j) > Vmax
                V(i,j) = Vmax;
            elseif V(i,j) < -Vmax
                V(i,j) = -Vmax;
            end

            % Update position
            X(i,j) = X(i,j) + V(i,j);

            % Keep the position within the normalized bounds [0,1]
            if X(i,j) < 0
                X(i,j) = 0;
            elseif X(i,j) > 1
                X(i,j) = 1;
            end
        end

        % EVALUATE THE NEW POSITION
        decisionVariables = (upperBounds - lowerBounds) .* X(i,:) + lowerBounds;
        objectiveValues(i) = objectiveFunction(decisionVariables);

        % UPDATE PERSONAL BEST
        if objectiveValues(i) < fPbest(i)
            Pbest(i,:) = X(i,:);
            fPbest(i) = objectiveValues(i);

            % UPDATE GLOBAL BEST
            if fPbest(i) < fGbest
                fGbest = fPbest(i);
                Gbest = Pbest(i,:);
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%% CONVERGENCE TESTS %%%%%%%%%%%%%%%%%%%%%%

    if (iterationCounter >= maxIterations)
        continueIterations = 0;
    end

    currentBestFitness = fGbest; % PSO minimizes by default

    % Absolute convergence criterion
    if (abs(currentBestFitness - previousBestFitness) < 0.00001)
        absConvCounter = absConvCounter + 1;
        if (absConvCounter >= absConvCounterLimit)
            absConvergenceReached = 1;
        end
    else
        absConvCounter = 0;
        absConvergenceReached = 0;
    end

    % Relative convergence criterion
    if (abs(currentBestFitness - previousBestFitness) / max(abs(currentBestFitness), 10^(-10)) < 0.001)
        relConvCounter = relConvCounter + 1;
        if (relConvCounter >= relConvCounterLimit)
            relConvergenceReached = 1;
        end
    else
        relConvCounter = 0;
        relConvergenceReached = 0;
    end

    if absConvergenceReached == 1 && relConvergenceReached == 1
        continueIterations = 0;
    end

    previousBestFitness = currentBestFitness;
    convergenceCurve(iterationCounter) = currentBestFitness;
end

% BEST SOLUTION FOUND
bestFitness = fGbest;
bestPosition = (upperBounds - lowerBounds) .* Gbest + lowerBounds;
convergenceCurve = convergenceCurve(1:iterationCounter);

end
