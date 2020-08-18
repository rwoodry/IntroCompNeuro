% Calculate firing rate given applied current and other parameters

function [fr] = calc_FR(I_app, C_m, G_l, E_l, V_th, V_reset)

t_m = C_m* (1/G_l);
fr = 1 / (t_m * log((E_l + I_app/G_l - V_reset) / (E_l + I_app/G_l - V_th)));

end