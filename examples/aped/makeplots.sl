require ("xfig");

define slsh_main ()
{
   variable en, flux;
   () = readascii ("apedflux.tbl", &en, &flux);
   variable p = xfig_plot_new ();
   p.xlabel ("Energy [keV]");
   p.ylabel ("Flux [photons/sec/keV/cm$^2$]");
   p.plot (en, flux; logx, logy);
   p.render ("apedflux.png");
}

