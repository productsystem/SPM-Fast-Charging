clear; clc;

mdl = 'SPM_PSO';
STOP_TIME = '10000';

lb = [1.5, 0.5, 0.4];
ub = [16.0, 16.0, 0.8];

opts = optimoptions('particleswarm', ...
    'SwarmSize', 10, ...
    'MaxIterations', 10, ...
    'Display', 'iter');

load_system(mdl);
set_param(mdl, 'FastRestart', 'on');

[x_opt, fval] = particleswarm( ...
    @(x) pso_objective_2stage(x, mdl, STOP_TIME), ...
    3, lb, ub, opts);

fprintf('\n=============================\n');
fprintf('Optimal I1        = %.3f A\n', x_opt(1));
fprintf('Optimal I2        = %.3f A\n', x_opt(2));
fprintf('Optimal SOC_break = %.3f\n',  x_opt(3));
fprintf('Objective value   = %.1f\n',  fval);
fprintf('=============================\n');
