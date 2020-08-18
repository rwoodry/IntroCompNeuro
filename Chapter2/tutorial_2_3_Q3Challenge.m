% Tutorial 2.3 Question 3 Challenge Question

% Initialize pulse parameters
start_pulse_s = 0;  % 0 s
end_pulse_s = 1;    % 1 s
time_s = 1;       % 200 ms

% Create I_App vector
I_App = [0:10:1000]*1e-12;

% Create other vectors
initial_rate = zeros(size(I_App));
final_rate = zeros(size(I_App));
firing_rate = zeros(size(I_App));
mean_V = zeros(size(I_App));

% Go through each applied current in I_App vector

for i = 1:length(I_App)
    % Simulate under given parameters
    [I_app, v, G_sra, t_vec, firing_rate(i), ISIs] = alt_AELIF_model(I_App(i), start_pulse_s, end_pulse_s, time_s);
    
    % Calculate mean membrane potential
    mean_V(i) = mean(v);
    
    % Grab the initial ISI and store its inverse
    initial_rate(i) = 1/ISIs(1);
    
    % If more than one ISI, grab the final ISI and store its inverse
    if (length(ISIs) > 1)
        final_rate(i) = 1/ISIs(end);
    end
    
    % Plot a specific applied current of 160 pA's Membrane Potential as a 
    % function of time for 200 ms
    if I_App(i) == 160e-12
        figure(1)
        subplot('Position',[0.16 0.62 0.33 0.33])                      
        plot(t_vec(1:2000), v(1:2000))
        hold on;
        xlabel('Time (sec)')
        ylabel('V_{m} (V)')
        title('Membrane Potential ~ Time (160 pA)')
    end
    
end




% Plot Final Firing Rate as a function of Applied Current
subplot('Position',[0.65 0.62 0.33 0.33])                      
hold on;                            
plot(I_App, final_rate)     
xlabel('I_{app} (nA)')             
ylabel('Spike Rate (Hz)') 
title('Firing Rate ~ Applied Current')

% Plot Mean Membrane Potential as a function of applied current 
subplot('Position',[0.65 0.14 0.33 0.33])                      
plot(I_App, mean_V)
xlabel('I_{app} (A)')
ylabel('Mean V_{membrane} (V)')
title('Membrane Potential ~ Applied Current')

% Plot MEan Membrane Potential as a function of Final Spike Rate
subplot('Position',[0.16 0.14 0.33 0.33])                     
plot(final_rate, mean_V)
xlabel('Spike rate (Hz)')
ylabel('Mean V_{membrane} (V)')
title('Membrane Potential ~ Final ISI')

