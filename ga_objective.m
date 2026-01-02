function J = ga_objective(x, mdl, STOP_TIME)

I = x(1);
mws = get_param(mdl,'ModelWorkspace');
mws.assignin('I', I);

try
    simOut = sim(mdl,'StopTime',STOP_TIME);
catch
    J = 1e6;
    return;
end

SOCsig = simOut.logsout.get('SOC').Values;
SOC = SOCsig.Data;
tSOC = SOCsig.Time;

idx = find(SOC >= 0.9, 1, 'first');
if isempty(idx)
    J = 1e6;
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

fprintf('I = %.2f A | Time = %.1f s | Tmax = %.2f K | Vmax = %.3f V | J = %.1f\n', ...
        I, charge_time, Tmax, Vmax, J);

end
