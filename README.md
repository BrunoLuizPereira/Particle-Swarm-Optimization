# Particle Swarm Optimization

A simple, practical, and easy-to-use implementation of Particle Swarm Optimization (PSO) for continuous optimization in **MATLAB and GNU Octave**.

The algorithm allows users to minimize their own objective functions within user-defined bounds, without requiring additional MATLAB toolboxes. It is suitable for students, researchers, engineers, and anyone interested in numerical optimization.

The implementation includes particle velocity and position updates, personal and global best tracking, and convergence monitoring through configurable parameters.

## Requirements

- MATLAB or GNU Octave.
- No additional MATLAB toolboxes are required.

## Files

- `ParticleSwarmOptimization.m` — main PSO function.
- `Main.m` — example script that configures and runs the algorithm.
- `ObjectiveFunction.m` — objective function used in the example.

Keep all three files in the same folder, or add their folder to the MATLAB or Octave path.

## Example

The provided Main.m script minimizes the objective function defined in ObjectiveFunction.m:

f(x1, x2) = x1^2 + x2^2 + 10

The search bounds are:

-5 <= x1 <= 2
-5 <= x2 <= 3

The theoretical minimum is 10, attained at (x1, x2) = (0, 0).

The example uses 100 iterations, 50 particles, an inertia weight of `0.7`, and cognitive and social coefficients of `1.5`.

To run the example, set the project folder as the current folder and execute:

```matlab
Main
```

The script displays the best position found, its objective-function value, and the convergence curve.

## Using the Algorithm

The main function has the following syntax:

```matlab
[bestPosition, bestFitness, convergenceCurve] = ...
    ParticleSwarmOptimization(objectiveFunction, bounds, ...
    maxIterations, numParticles, w, c1, c2, ...
    absConvCounterLimit, relConvCounterLimit);
```

The first two arguments are required:

- `objectiveFunction` — function handle that receives a vector of decision variables and returns a scalar objective value.
- `bounds` — vector containing the lower and upper bounds of each decision variable in alternating order.

For example, for three decision variables:

```matlab
bounds = [lb1 ub1 lb2 ub2 lb3 ub3];
```

All subsequent arguments are optional and use the default values defined in `ParticleSwarmOptimization.m` when omitted.

## Input Parameters

| Parameter | Description | Default |
|---|---|---:|
| `maxIterations` | Maximum number of iterations. | `100` |
| `numParticles` | Number of particles in the swarm. | `50` |
| `w` | Inertia weight. | `0.7` |
| `c1` | Cognitive coefficient, controlling the influence of each particle's personal best. | `1.5` |
| `c2` | Social coefficient, controlling the influence of the global best. | `1.5` |
| `absConvCounterLimit` | Consecutive-iteration limit for the absolute convergence test. | `10000` |
| `relConvCounterLimit` | Consecutive-iteration limit for the relative convergence test. | `10000` |

## Algorithm Overview

- **Velocity update:** combines inertia, the cognitive component, and the social component.
- **Position update:** advances each particle according to its velocity.
- **Personal best:** stores the best position found by each particle.
- **Global best:** stores the best position found by the swarm.
- **Convergence monitoring:** tracks changes in the best objective-function value.

Particle positions are internally represented in the normalized range `[0, 1]` and mapped to the user-defined bounds for objective-function evaluation. Velocities are limited to the range `[-0.5, 0.5]`, and normalized positions are kept within `[0, 1]`.

## Output Arguments

- `bestPosition` — best decision-variable vector found.
- `bestFitness` — minimum objective-function value associated with `bestPosition`.
- `convergenceCurve` — best objective-function value recorded at each iteration.

## Stopping Criteria

The algorithm stops when the maximum number of iterations is reached or when both convergence tests satisfy their respective consecutive-iteration limits.

The implementation uses an absolute tolerance of `1e-5` and a relative threshold of `0.001` (0.1%). The counter limits can be configured through `absConvCounterLimit` and `relConvCounterLimit`.

Because PSO is a stochastic optimization method, results may vary between runs, and finding the global optimum is not guaranteed.

## License

This project is distributed under the MIT License. See the `LICENSE` file for details.
