clear; clc;

mdl = 'SPM_TEST';
STOP_TIME = '20000';

I_vals = linspace(1.5, 9, 16);
Tmax_vals = zeros(size(I_vals));

mws = get_param(mdl,'ModelWorkspace');

for k = 1:length(I_vals)

    I = I_vals(k);
    fprintf('Running simulation for I = %.2f A...\n', I);

    mws.assignin('I', I);

    try
        simOut = sim(mdl, 'FastRestart','on','StopTime',STOP_TIME);
    catch ME
        warning('Simulation failed at I = %.2f A', I);
        Tmax_vals(k) = NaN;
        continue;
    end

    Tsig = simOut.logsout.get('Temperature').Values;
    T = Tsig.Data;
    t = Tsig.Time;

    idx = t > 10;
    T = T(idx);

    Tmax_vals(k) = max(T);

    fprintf('   Max temperature = %.2f K\n', Tmax_vals(k));
end

results = table(I_vals(:), Tmax_vals(:), ...
    'VariableNames', {'Current_A', 'MaxTemperature_K'})

figure;
plot(I_vals, Tmax_vals, '-o', 'LineWidth', 1.5);
grid on;
xlabel('Charging Current (A)');
ylabel('Maximum Temperature (K)');
title('SPM Thermal Response vs Charging Current');
