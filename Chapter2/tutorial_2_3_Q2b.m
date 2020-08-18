% Tutorial 2.3 Question 2 part b

% Simulate the AELIF model for 5 seconds with a range of 20 different levels
% of constant applied current such that the steady state firing rate of the
% cell varies from 0 to 50 Hz.
%   - For each applied current calculate the first ISI and the ss ISI. On a
%   graph plot the inverse of the ss ISI against the applied current to
%   produce an f-1 curve. On the same graph plot as individual points the
%   inverse of the ISI.

% Calculate I_app such that firing rate equals 50 Hz, given parameters of
% the AELIF model. Then calculate again such that firing rate equals 0.
E_l = -0.070;           % -75 mV
V_th = -0.050;          % -50 mV
V_reset = -0.080;       % -80 mV
G_l = 10e-9;            % 10 nS
C_m = 100e-12;          % 100 pF
max_fr = 50;            % 50 Hz
min_fr = 0;             % 0 Hz

I_app_max = calc_Iapp(max_fr, C_m, G_l, E_l, V_th, V_reset);
% Find applied current threshold (Max applied current that yields 0 Hz
% firing rate)

I_threshold = G_l * (V_th - E_l);

% Create a 20-element vector that goes from minimum I_app to maximum I_app,
% such that the firing rate varies from 0 Hz to 50 Hz. First calculate the
% steps to use, then create the vector

I_step = (I_app_max - I_threshold) / 19;
I_app_vec = I_threshold:I_step:I_app_max;

% Initialize firing rate vector (inverse of steady state ISI) and Initial
% ISI vector(first ISI between the first and second of spikes)
fr_vec = zeros(size(I_app_vec));
ISI_i = zeros(size(I_app_vec));
ISI_f = zeros(size(I_app_vec));

% Loop through each I_app in the I_app vector and assign the firing rate
% and initial ISI to their respective vectors
for i = 1:length(I_app_vec)
    [I_app, v, I_sra, t_vec, fr_vec(i), ISIs] = AELIF_model(I_app_vec(i), 0, 5, 5);
    ISI_i(i) = 1/ISIs(1);
    
    % If more than one ISI, record final ISI
    if (length(ISIs) > 1)
        ISI_f(i) = 1/ISIs(end);
    end
end

% Plot the Firing rate and the Inverse of the initial ISI as a function of
% applied Current

% Firing rate as a function of applied current w/o SRA
plot(I_app_vec, fr_vec);
hold on;

% Initial ISI 
scatter(I_app_vec, ISI_i);

% Final ISI
plot(I_app_vec, ISI_f);

% Label
xlabel('I_{App}(A)');
ylabel('Spike Rate (Hz)');
legend('Base Rate', '1/ISIs(1)', 'Final Rate', 'Location', [0.17 0.75 0.15 0.15]);
hold off;


