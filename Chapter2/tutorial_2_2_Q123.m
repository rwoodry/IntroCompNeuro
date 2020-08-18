% Tutorial 2.2


I_app = 100:600;        % Range of applied currents
I_app = I_app * 1e-12;  % in e-12


% Q1 vectors Forced Voltage Clamp model
fr_vec_q1 = zeros(size(I_app));
vm_vec_q1 = zeros(size(I_app));

% Q2 vectors Threshold Increase Model
fr_vec_q2 = zeros(size(I_app));
vm_vec_q2 = zeros(size(I_app));

% Q3 vectors Refractory Conductance with Threshold Increase Model
fr_vec_q3 = zeros(size(I_app));
vm_vec_q3 = zeros(size(I_app));

% Figure 1
figure(1);
hold on;

% Obtain mean FR and Membrane Potential for Q1 model
for i = 1:length(I_app)
    [fr_vec_q1(i), vm_vec_q1(i)] = fvc_LIF_model(I_app(i), 1, false);
    [fr_vec_q2(i), vm_vec_q2(i)] = ti_LIF_model(I_app(i), 1, false); 
    [fr_vec_q3(i), vm_vec_q3(i)] = rc_LIF_model(I_app(i), 1, false); 
end

% F1 s1: FR_IC - Mean Firing rate as a Function of Input Current
subplot('Position',[0.1 0.6 0.33 0.33]);
hold on;
plot(I_app, fr_vec_q1);
plot(I_app, fr_vec_q2);
plot(I_app, fr_vec_q3);
xlabel('I_{App}');
ylabel('Firing Rate (Hz)');
title('Firing Rate ~ Input Current');
legend('Q1', 'Q2', 'Q3', 'Location', [.135 .82 .1 .1]);



% F1 s2: MP_IC - Mean Membrane Potential as a Function of Input Current
subplot('Position',[0.6 0.6 0.33 0.33]);
hold on;
plot(I_app, vm_vec_q1);
plot(I_app, vm_vec_q2);
plot(I_app, vm_vec_q3)
xlabel('I_{App}');
ylabel('Membrane Potential (V)');
title('Membrane Potential ~ Input Current');

% F1 s3: MP_FR - Mean Membrane Potential as a Function of Firing Rate
subplot('Position',[0.1 0.1 0.33 0.33]);
hold on;
plot(fr_vec_q1, vm_vec_q1);
plot(fr_vec_q2, vm_vec_q2);
plot(fr_vec_q3, vm_vec_q3);
xlabel('Firing Rate (Hz)');
ylabel('Membrane Potential (V)');
title('Membrane Potential ~ Firing Rate');

% F1 s4: MP_T - Membrane Potential at 220 pA across 100 ms 
subplot('Position',[0.6 0.1 0.33 0.33]);
hold on;
fvc_LIF_model(220e-12, 100, true);
ti_LIF_model(220e-12, 100, true);
rc_LIF_model(220e-12, 100, true);
xlabel('Time (S)');
ylabel('Membrane Potential (V)');
title('Simulation at 220 pA');
