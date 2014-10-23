load_dataset ("plaw_pileup_pha.fits", "plaw_rmf.fits", "plaw_arf.fits");
rebin_data (1, 30);
xnotice_en (1, 0.3, 11.0);
fit_fun("phabs(1)*powerlaw(1)");
set_par (1, 1, 1);		       %  freeze nH
fit_counts;
list_par;
