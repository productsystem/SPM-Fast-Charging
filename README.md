# SPM-Fast-Charging
Single Particle Model Fast charging implementation using Simscape Battery, MATLAB Optimization Toolbox.

run_ga_optimizer - Runs Genetic Algorithm for a continuous current supply over 0.3 to 0.9 SOC under temperature and voltage constraints. This uses SPM_GA.slx.

run_pso_optimizer - Runs Particle Swarm Optimizer for a 2 part CC supply split across SOC_break which is also parametrized, under the same constraints as before. This uses SPM_PSO.slx.

The only difference between the two Simulink models is the 1D Lookup table for current which is constant for GA and split at SOC_break for PSO.
