load_data ("aped_pha2.fits");
xrange (1, 25);
plot_open("apedmeg1.ps/CPS");
group_data (3, 2);
plot_data (3);
plot_close ();
