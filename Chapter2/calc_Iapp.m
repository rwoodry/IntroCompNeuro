% Function to calculate desired I_app given Firing rate and other
% parameters

function [I_a] = calc_Iapp(fr, C_m, G_l, E_l, V_th, V_reset)

t_m = C_m * (1/G_l);

% I took the firing rate function (pg. 70) and solved for I_app. I broke
% the solved equation down into three parts below.
E = exp( 1 / (fr * t_m));
G = G_l * (E*E_l - E*V_th - E_l + V_reset);
I_a = G / (1 - E);

end
