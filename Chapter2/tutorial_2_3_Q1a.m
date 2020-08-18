% Tutorial 2.3
% Q1a
% Simulate the adaptation LIF model for 1.5 s with 500 pA applied from 0.5
% s until 1.0 s. Plot three subplots as a function of time
[I_app, v, G_sra, t_vec, fr, firstISI] = ada_LIF_model(500e-12, 0.5, 1.0, 1.5);

% Current as a function of time
subplot('Position', [.1 .75 .8 .2]);
plot(t_vec, I_app);
xlabel('Time (seconds)');
ylabel('I_{App}');

% Membrane Potential as a function of time
subplot('Position', [.1 .425 .8 .2]);
plot(t_vec, v);
xlabel('Time (seconds)');
ylabel('V_{membrane}');

% Adaptation conductance as a function of time
subplot('Position', [.1 .1 .8 .2]);
plot(t_vec, G_sra);
xlabel('Time (seconds)');
ylabel('G_{sra}');
hold off;