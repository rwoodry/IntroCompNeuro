% Tutorial 2.2 Q 2 Threshold increase
function [ fr, v_mean ] = ti_LIF_model(applied_curr, time_ms, plot_ts)

E_l = -0.070;           % -70 mV
R_m = 10e7;             % 100 M Ohms
C_m = 100e-12;          % 0.1 nF
V_th0 = -0.050;          % -50 mV
V_reset = -0.065;       % -65 mV
G_l = 1/R_m;            % Inverse of Resistance
I_app = applied_curr;   % in e-12
t_vth = .001;
V_peak = 0.050;         % 50 mV
V_thmax = 0.200;        % 200 mv

t_max = 2; % 2 s, 2000 ms
dt = 0.0001; % 0.1 ms steps
t_vec = 0:dt:t_max; % Range from 0 to 2000 ms in 0.1 ms increments

v = zeros(size(t_vec));     % Initialize membrane potential vector
v(1) = E_l;

vt = zeros(size(t_vec));    % Initialize membrane potential threshold vector
vt(1) = V_th0;


i_app = zeros(size(t_vec)) + I_app;
spikes = zeros(size(t_vec));

for i = 2:length(t_vec)
        % Update Membrane Potential
        dvdt = i_app(i) + G_l * (E_l - v(i-1));
        v(i) = v(i-1) + (dt*dvdt/C_m);
        
        % Update Membrane Potential Threshold
        dvthdt = (V_th0 - vt(i-1)) / t_vth;
        vt(i) = vt(i-1) + (dt*dvthdt);
        
        if v(i) > vt(i)
            v(i) = V_reset;
            vt(i) = V_thmax;
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