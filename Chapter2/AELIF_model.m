% AELIF Model function
% Simulate the AELIF neuron model.

% Function returns vectors of applied current, membrane potential, I_sra
% values, time, ISIs, as well as the raw firing rate w/o SRA.

function [I_app, v, I_sra, t_vec, fr, ISIs] = AELIF_model(current_pulse, start_pulse_s, end_pulse_s, time_s)

% Set parameters
E_l = -0.070;           % -75 mV
V_th = -0.050;          % -50 mV
V_reset = -0.080;       % -80 mV
V_max = 0.050;          % 50 mV
delta_th = 0.002;       % 2 mV
G_l = 10e-9;            % 10 nS
C_m = 100e-12;          % 100 pF
a = 2e-9;               % 2 nS
b = 0.02e-9;            % 0.02 nA
t_sra = 0.200;          % 200 ms
R_m = 1/G_l;

% Initialize time vector
t_max = time_s;
dt = 0.0001;
t_vec = 0:dt:t_max;

% Initialize other time-dependent vectors
v = zeros(size(t_vec));
I_app = zeros(size(t_vec));
I_sra = zeros(size(t_vec));
spikes = zeros(size(t_vec));

% Set initial vector values
v(1) = E_l;
I_sra(1) = 0;

% Alter the I_app vector to incorporate the parameterized pulse
if start_pulse_s == 0
    start_pulse_s = 1/10000;
end

I_app((start_pulse_s*10000):(end_pulse_s*10000)) = current_pulse;

% For loop to simulate AELIF model for each time step
for i = 2:length(t_vec)
    
    % Update membrane potential at each time step
    dvdt = G_l * (E_l - v(i-1) + delta_th*exp((v(i-1) - V_th)/delta_th)) - I_sra(i-1) + I_app(i);
    v(i) = v(i-1) + (dt*dvdt/C_m);
    
    % Update the I_sra at each time step so that it decays over time
    didt = a*(v(i-1) - E_l) - I_sra(i-1);
    I_sra(i) = I_sra(i-1) + (dt*didt/t_sra);
    
    % When the membrane potential reaches the max, reset membrane
    % potential, increase I_sra by constant b, record spike time
    if v(i) > V_max
        v(i) = V_reset;
        I_sra(i) = I_sra(i) + b;
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

% Calculate raw firing rate w/o SRA
fr = calc_FR(current_pulse, C_m, G_l, E_l, V_th, V_reset);


end