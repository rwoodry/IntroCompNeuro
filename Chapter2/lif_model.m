% Leaky Integrate-and-Fire model

% Tutorial 2.1 Q1 part a
% Takes input as applied current (I_threshold = 4e-9)
% Reccomend parameters applied_curr = 4.5e-9, time_ms = 200, sigma = 0.1
function [fr, alt_fr] = lif_model(applied_curr, time_ms, sigma_I)
    % Define parameters.
    E_l = -0.070;   % -70 mV                 
    R_m = 5e6;      % 5 M Ohms
    C_m = 2e-9;     % 2 nF     
    V_th = -0.050;  % -50 mV
    V_res = -0.065; % -65 mV
    G_l = 1/R_m ;   % Inverse of Resistance
    I_app = applied_curr;
    spikes = 0;


    % Time vector of steps = 0.1 from 0 to max of 2 seconds
    t_max = 2;
    dt = 0.0001;
    t_vec = 0:dt:t_max;


    % Membrane potential vector, V, same size as  t_vec
    v = zeros(size(t_vec));

    % Set initial values of membrane potential (V) to leak potential
    v(1) = E_l;

    % Create applied current vector of size t_vec of a constant value (I) tbd
    i_app = zeros(size(t_vec)) + I_app;

    % For loop  i from 2 to # points in the time vector. Will be used for
    % integration over time. Within the for loop, update the membrane potential
    % using the Forward Euler method.
    
    % Initialize a spike vector

    for i = 2:length(t_vec)
        % Update membrane potential
        dvdt = i_app(i) + G_l * (E_l - v(i-1));
        v(i) = v(i-1) + (dt*dvdt/C_m);
        
        % Adds noise to the model based on Sigma_I supplied in function
        % call. If sigma = 0, then there will be no noise.
        v(i) = v(i) + randn(1) * sigma_I * sqrt(dt);
        
        % When membrane potential exceeds the threshold, reset it.
        if v(i) > V_th
            v(i) = V_res;
            spikes = spikes + 1;
        end
         
    end
    
    % Plot the model
    timesteps = time_ms * 10;
    plot(t_vec(1:timesteps), v(1:timesteps));
    hold off;
    
   
    % Return number of spikes per second
    fr = spikes / t_max;
    
    % Calculate firing rate based on equation provided in tutorial
    t_m = C_m * (1/G_l);
    alt_fr = 1 / ((t_m* log(I_app*R_m + E_l - V_res)) - (t_m * log(I_app*R_m + E_l - V_th)));
    
end
