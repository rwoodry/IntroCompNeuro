% LIF model with adaptation function
% Simulate the LIF modelnueron with an adaptation current

% Function returns vectors of applied current, membrane potential, G_sra
% values, time, ISIs, as well as the raw firing rate w/o SRA.

function [I_app, v, G_sra, t_vec, fr, ISIs] = ada_LIF_model(current_pulse, start_pulse_s, end_pulse_s, time_s)
% Initialize Parameters
E_l = -0.075;       % -75 mv
V_th = -0.050;      % -50 mV
V_reset = -0.080;   % -80 mV
R_m = 100e6;        % 100 M Ohms
C_m = 1e-10;        % 100 pF
E_k = -0.080;       % -80 mV
delta_G_sra = 1e-9; % 1 nS
t_sra = 0.2;        % 200 ms
G_l = 1/R_m;

% Initialize time vector
t_max = time_s;
dt = 0.0001;
t_vec = 0:dt:t_max;

% Initialize other time-dependent vectors
v = zeros(size(t_vec));
I_app = zeros(size(t_vec));
G_sra = zeros(size(t_vec));
spikes = zeros(size(t_vec));

% Set initial vector values
v(1) = E_l;
G_sra(1) = 0;

% Alter the I_app vector to incorporate the parameterized pulse
if start_pulse_s == 0
    start_pulse_s = 1/10000;
end

I_app((start_pulse_s*10000):(end_pulse_s*10000)) = current_pulse;

% For loop to simulate adaptation model
for i = 2:length(t_vec)
    % Update Potassium conductance term (G)
    dgdt = -G_sra(i-1) / t_sra;
    G_sra(i) = G_sra(i-1) + dt*dgdt;
    
    % Update membrane potential
    dvdt = (E_l - v(i-1))/R_m + G_sra(i-1)*(E_k - v(i-1)) + I_app(i);
    v(i) = v(i-1) + (dt*dvdt/C_m);
    
    % When the membrane potential is greater than the threshold, reset it,
    % increment the Potassium conductance term by delta G_sra, and record
    % the spike time
    if v(i) > V_th
        v(i) = V_reset;
        G_sra(i) = G_sra(i) + delta_G_sra;
        spikes(i) = t_vec(i);
        
    end
    
end

% Keep only the spiketimes from the spikes vector (remove zeros)
spikes = nonzeros(spikes)';

% If more than one spike, assign to the variable ISIs the difference
% between each pair of spikes, yielding a vector of ISIs. If one or less,
% record an ISIs of 0.
if length(spikes) >= 2
    ISIs = diff(spikes);
else
    ISIs = 0;
end

% Calculate Firing Rate
fr = calc_FR(current_pulse, C_m, G_l, E_l, V_th, V_reset);


end
