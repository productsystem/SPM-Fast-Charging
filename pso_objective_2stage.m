function J = pso_objective_2stage(x, mdl, STOP_TIME)

I1 = x(1);
I2 = x(2);
SOC_break = x(3);

mws = get_param(mdl,'ModelWorkspace');
mws.assignin('I1', I1);
mws.assignin('I2', I2);
mws.assignin('SOC_break', SOC_break);

try
    simOut = sim(mdl,'StopTime',STOP_TIME);
catch
    J = 1e6;
    return;
end

SOCsig = simOut.logsout.get('SOC').Values;
SOC = SOCsig.Data;
tSOC = SOCsig.Time;

idx = find(SOC >= 0.89, 1, 'first');

if isempty(idx)
    J = 1e5;
    return;
end

charge_time = tSOC(idx);

Tsig = simOut.logsout.get('Temperature').Values;
T = Tsig.Data;
tT = Tsig.Time;

T = T(tT > 10);
Tmax = max(T);

Vsig = simOut.logsout.get('Voltage').Values;
V = Vsig.Data;
tV = Vsig.Time;

V = V(tV <= tSOC(idx));
Vmax = max(V);

penalty = 0;

Tmax_lim = 313;
if Tmax > Tmax_lim
    penalty = penalty + 1e4 * (Tmax - Tmax_lim)^2;
end

Vmax_lim = 3.346;
if Vmax > Vmax_lim
    penalty = penalty + 1e5 * (Vmax - Vmax_lim)^2;
end

J = charge_time + penalty;

fprintf(['I1=%.2f I2=%.2f SOCb=%.2f | ', ...
         'Time=%.0f | Tmax=%.1f K | Vmax=%.3f V | J=%.0f\n'], ...
        I1, I2, SOC_break, charge_time, Tmax, Vmax, J);

drawnow;
end
