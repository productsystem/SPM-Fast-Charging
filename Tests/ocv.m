mdl = 'SPM_TEST';
mws = get_param(mdl,'ModelWorkspace');

mws.assignin('I', 0.05);

simOut = sim(mdl,'StopTime','150000');

Vsig = simOut.logsout.get('Voltage').Values;
V = Vsig.Data;
t = Vsig.Time;

SOCsig = simOut.logsout.get('SOC').Values;
SOC = SOCsig.Data;

idx = SOC > 0.87;
Vmax = max(V(idx));

fprintf('Measured OCV_max ≈ %.3f V\n', Vmax);
