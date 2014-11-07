implements("demo");
static variable lo, hi, s;
()=evalfile("./inc/isispileup1.inc", "demo");
()=evalfile("./inc/isispileup2.inc", "demo");
()=evalfile("./inc/isispileup2b.inc", "demo");
()=evalfile("./inc/isispileup3.inc", "demo");
()=evalfile("./inc/isispileup3b.inc", "demo");
()=evalfile("./inc/isispileup4.inc", "demo");

plot_open("plawpileupfit.ps/CPS");
xrange (0,11);
rplot_counts();
plot_close ();
