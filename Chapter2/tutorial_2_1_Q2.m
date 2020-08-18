% Tutorial 2.1 Question 2 
% Plot firing rate curve for at least two different sigma_I (random noise)

% Initialize vector of noise ratios
sigma_I = [0:0.1:0.5];

% Create Applied current vector
I_App = 4:0.25:8.75;
I_App = I_App * 1e-9;

% Initialize firing rate matrix of size sigma x I_app
FR_vec = zeros(length(sigma_I), length(I_App));

% Initialize alternate firing rate matrix
Alt_FR_vec = zeros(length(sigma_I), length(I_App));

% Loop through each Sigma_I to contruct the f-1 curve
for i = 1:length(sigma_I)
    
    % Loop through each I_app current, grabbing the Firing
    % rates. Add noise.
    for j = 1:length(I_App)
        % Assign corresponding values to the matrices
        [FR_vec(i, j), Alt_FR_vec(i, j)] = lif_model(I_App(j), 200, sigma_I(i));
    end
end

% Plot each Sigma values' f-1 curve as a function of vried injected current
for k = 1:length(sigma_I)
    plot(I_App, FR_vec(k, :));
    hold on;
end

    

legendCell = cellstr(num2str(sigma_I', 'Sigma = %.1f'));

xlabel('I_{App} (A)')
ylabel('Firing Rate (Hz)')
legend(legendCell, 'Location', [0.69 0.21 0.15 0.15]);
hold off;