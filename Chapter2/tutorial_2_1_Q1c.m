% Tutorial 2.1 Question 1
%   Plot firing rate as a function of Applied current

% Calculate I threshold
% I_threshold = G_l * (V_th - E_l) = 4.0000e-09

% Create I_app vector from I threshold
I_App = 4:0.25:8.75;
I_App = I_App * 1e-9;

% Initialize firing rate vector
FR_vec = zeros(size(I_App));

% Initialize alternate firing rate vector
Alt_FR_vec = zeros(size(I_App));

% Loop through each I_app current in I_app vector, grabbing the Firing
% rates. Add 0 noise.
for i = 1:length(I_App)
    [FR_vec(i), Alt_FR_vec(i)] = lif_model(I_App(i), 200, 0);
end

% Plot them as a function of applied current. Plot obtained firing rate as
% points, then plot calculated (alt) firing rate as line.
scatter(I_App, FR_vec)
hold on;
plot(I_App, Alt_FR_vec)
xlabel('I_{App} (A)')
ylabel('Firing Rate (Hz)')
legend('Simulation', 'Calculation', 'Location', [0.69 0.13 0.15 0.15]);
hold off;
