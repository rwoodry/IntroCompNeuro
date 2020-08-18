% Tutorial 2.1 Q1 B
E_l = -0.070;   % -70 mV                 
R_m = 5e6;      % 5 M Ohms
V_th = -0.050;  % -50 mV
G_l = 1/R_m; 

% Calculate I threshold
I_threshold = G_l * (V_th - E_l);

% Simulate model with applied currents slightly lower and slightly higher
% than that value. Plot on the same graph

I_vec = [I_threshold * 0.9, I_threshold, I_threshold * 1.1];

for i = 1:length(I_vec)
    lif_model(I_vec(i), 200, 0);
    hold on;
end

% Label graph
legend('Below Threshold', 'At Threshold', 'Above Threshold', 'Location', [0.69 0.13 0.15 0.15]);
xlabel('Time (s)');
ylabel('Membrane Potential (V)');
hold off;
