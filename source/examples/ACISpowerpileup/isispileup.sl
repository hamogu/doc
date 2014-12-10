implements("demo");
static variable lo, hi, s;
()=evalfile("./isispileup1.inc", "demo");
()=evalfile("./isispileup2.inc", "demo");
()=evalfile("./isispileup2b.inc", "demo");
()=evalfile("./isispileup3.inc", "demo");
()=evalfile("./isispileup3b.inc", "demo");
()=evalfile("./isispileup4.inc", "demo");

plot_open("plawpileupfit.ps/CPS");
xrange (0,11);
rplot_counts();
plot_close ();
