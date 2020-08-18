% Tutorial 2.2 Question 3: Challenge Question

% Alter the AELIF Model to produce a refractory period using a combo of
% methods from tutorial 2.2:
%   - Change the SRA current into a refractory conductance
%   - Make the neuron's spiking threshold dynamic

% Similar cell properties as Tutorial 2.3 Question 2
function [I_app, v, G_sra, t_vec, fr, ISIs] = alt_AELIF_model(current_pulse, start_pulse_s, end_pulse_s, time_s)

% Set parameters
E_l = -0.075;           % -75 mV
E_k = -0.080;           % -80 mV
V_th_base = -0.060;     % -60 mV
V_reset = -0.060;       % -60 mV
V_max = 0.150;          % 150 mV
V_th_max = 4 * V_max;   % 600 mV 
delta_th = 0.010;        % 10 mV
G_l = 10e-9;            % 10 nS
C_m = 100e-12;          % 100 pF
a = 10e-9;              % 2 nS
b = 60e-9;              % 0.02 nA
t_sra = 0.0005;         % 0.5 ms
t_vth = 0.002;          % 2 ms
R_m = 1/G_l;

% Initialize time vector
t_max = time_s;
dt = 0.0001;
t_vec = 0:dt:t_max;

% Initialize other time-dependent vectors
v = zeros(size(t_vec));
I_app = zeros(size(t_vec));
G_sra = zeros(size(t_vec));
spikes = zeros(size(t_vec));
V_th = V_th_base * ones(size(t_vec));

% Set initial vector values
v(1) = E_l;

% Alter the I_app vector to incorporate the parameterized pulse
if start_pulse_s == 0
    start_pulse_s = 1/10000;
end

I_app((start_pulse_s*10000):(end_pulse_s*10000)) = current_pulse;

% For loop to simulate AELIF model for each time step
for i = 2:length(t_vec)
    % When the membrane potential reaches the max, reset membrane
    % potential, increase I_sra by constant b, record spike time
    if v(i-1) > (V_max + V_th(i-1))
        v(i-1) = V_reset;
        G_sra(i-1) = G_sra(i-1) + b;
        spikes(i) = t_vec(i);
        V_th(i-1) = V_th_max;
        
    end
    
    % Update membrane potential at each time step
    dvdt = G_l * (E_l - v(i-1) + delta_th*exp((v(i-1) - V_th(i-1))/delta_th)) ...
        + (E_k - v(i-1))*G_sra(i-1) + I_app(i-1);
    v(i) = v(i-1) + (dt*dvdt/C_m);
    v(i) = max(v(i), E_k);
    
    % Update the V_th at each time step so that it decays over time
    dvthdt = V_th_base - V_th(i-1);
    V_th(i) = V_th(i-1) + (dt*dvthdt/t_vth);
    
    % Update adaptation so that it decays towards a steady state 
    % 
    % ***Obtained code below from Paul Miller's github example
    % Tutorial_2_3_Q3.m script***
    Gss = a*tan(0.25*pi*min((v(i-1)-E_k)/(V_th_base + V_max - E_k), 1.99999)); 
    G_sra(i) = G_sra(i-1) + dt*(Gss-G_sra(i-1))/t_sra;
    
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

% Calculate raw firing rate w/o SRA or Decay
fr = calc_FR(current_pulse, C_m, G_l, E_l, V_th_base, V_reset);


end