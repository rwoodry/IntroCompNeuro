% Tutorial 2.3 Question 2 part a

% Simulate  AELIF model neuron for 1.5 seconds, with a current pulse of
% I_app = 500 pA applied from 0.5 s until 1.0 s. Plot results in a graph,
% using 2 subplots: 
%       1) Current as a function of time 
%       2) Membrane potential as a function of time

[I_app, v, I_sra, t_vec, fr, firstISI] = AELIF_model(500e-12, 0.5, 1.0, 1.5);

% Current as a function of time
subplot('Position', [.1 .75 .8 .2]);
plot(t_vec, I_app);
xlabel('Time (seconds)');
ylabel('I_{App}(A)');

% Membrane Potential as a function of time
subplot('Position', [.1 .425 .8 .2]);
plot(t_vec, v);
xlabel('Time (seconds)');
ylabel('V_{membrane}(V)');

% I_sra as a function of time
subplot('Position', [.1 .1 .8 .2]);
plot(t_vec, I_sra);
xlabel('Time (seconds)');
ylabel('I_{sra}(A)');
hold off;