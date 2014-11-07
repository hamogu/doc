load_data ("aped_pha2.fits");
xrange (1, 25);
plot_open("apedmeg1.ps/CPS");
group_data (9, 2);
plot_data (9);
plot_close ();
%exit(0);
