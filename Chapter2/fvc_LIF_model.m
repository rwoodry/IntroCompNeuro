% Tutorial 2.2 
% Q1 Method 1 Forced Voltage Clamp
function [ fr, v_mean ] = fvc_LIF_model(applied_curr, time_ms, plot_ts)

E_l = -0.070;           % -70 mV
R_m = 10e7;             % 100 M Ohms
C_m = 100e-12;          % 0.1 nF
V_th = -0.050;          % -50 mV
V_reset = -0.065;       % -65 mV
G_l = 1/R_m;            % Inverse of Resistance
I_app = applied_curr;   % in e-12
t_ref = .0025;
V_peak = 0.050;         % 50 mV


t_max = 2; % 2 s, 2000 ms
dt = 0.0001; % 0.1 ms steps
t_vec = 0:dt:t_max; % Range from 0 to 2000 ms in 0.1 ms increments

v = zeros(size(t_vec));
v(1) = E_l;

i_app = zeros(size(t_vec)) + I_app;
spikes = zeros(size(t_vec));

t_last_spike = -t_ref*10;   % Ensure simulation  does not commence in a 
                            % refractory period

for i = 2:length(t_vec)
        dvdt = i_app(i) + G_l * (E_l - v(i-1));
        
        v(i) = v(i-1) + (dt*dvdt/C_m);
        
        if ( t_vec(i) < t_last_spike + t_ref )   % If within tref of last spike
            v(i) = V_reset;      % Clamp voltage to reset
        end
        
        if v(i) > V_th
            v(i) = V_reset;
            t_last_spike = t_vec(i);
            spikes(i) = i;
        end
        
end

% Convert V whenever spike occurred to V_peak to sim spiking
spikes = nonzeros(spikes)';
v(spikes) = V_peak;

% Calculate Firing Rate by dividing length of spikes by seconds (2)
fr = length(spikes) / 2;
v_mean = mean(v);

% Plot membrane potential across time given

if plot_ts
    % Scale time_ms to simulation steps (0.1 ms)
    timesteps = time_ms * 10;
    
    plot(t_vec(1:timesteps), v(1:timesteps));
    xlabel('Time (ms)');
    ylabel('Membrane Potential (V)');
end


end
