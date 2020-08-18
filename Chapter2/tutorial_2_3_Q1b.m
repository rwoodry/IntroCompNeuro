% Tutorial 2.3 
% Q1b
E_l = -0.075;       
V_th = -0.050;  
R_m = 100e6;
G_l = 1/R_m;

% Find applied current threshold (Max applied current that yields 0 Hz
% firing rate)

I_threshold = G_l * (V_th - E_l);

% Used for loop below to find range of I_app values that yield firing rate
% of 0-50 Hz. Created 20 steps by subtracting them then dividing by 19.
I_range = 2.5:0.0247:2.97 ;
I_range = I_range*1e-10;

fr = zeros(size(I_range));
ISIs = zeros(size(I_range));
final_rate = zeros(size(I_range));


for i = 1:length(I_range)
    [I_app, v, G_sra, t_vec, frate, isis] = ada_LIF_model(I_range(i), 0, 5, 5);
    
    % Obtain initial ISI
    ISIs(i) = 1/isis(1);
    
    % Obtain calculated firing rate (base rate without adaptation)
    if isreal(frate)
        fr(i) = frate;
    end
    
    % Obtain final simulated ISI
    if length(isis) > 1
        final_rate(i) = 1/isis(end);
    end
end

% Replace any final rate of Inf (inverse of 0 ISI) with 0
final_rate(final_rate == Inf) = 0;
ISIs(ISIs == Inf) = 0;

plot(I_range, fr);
hold on;
plot(I_range, ISIs);
plot(I_range, final_rate);
hold off;
xlabel('I_{App} (A)');
ylabel('Spike Rate (Hz)');
legend('Base Rate', '1/ISIs(1)', 'Final Rate');

