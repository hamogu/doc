fit_fun("phabs(1)*powerlaw(1)+gauss(1)+gauss(2)");
list_par;  % This will show the model parameters.

% Set the model parameters:

set_par(1, 0.80);
set_par(2, 0.020);
set_par(3, 1.20);

% Set the Gaussian line parameters.
% It's also possible to set the parameters by name instead of their number.
% Note that the "center" must be specified in Angstroms,
% so keV values are converted using Const_hc [ keV A ].

% Fe line and Ne line centers

set_par("gauss(1).center", Const_hc/6.4038);
set_par("gauss(2).center", Const_hc/0.8486);

% Set the areas and widths of the lines:

set_par("gauss(1).area", 3.0e-4);
set_par("gauss(2).area", 1.0e-4);

% Make the lines have small but non-zero widths
% of 0.020 A FWHM, or sigma = 0.020/2.35 = 0.0085 A.
% These correspond to velocity widths of:
% c * 0.020/1.936 =  ~ 3100 km/s FWHM for Fe line
% c * 0.020/14.61 =  ~  410 km/s FWHM for Ne line

set_par("gauss(1).sigma", 0.0085);
set_par("gauss(2).sigma", 0.0085);

% Save the model/parameters to a file and exit isis.

save_par ("plaw_hetg.par");
