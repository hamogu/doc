plasma(aped);
define create_aped_model ()
{
   variable p = default_plasma_state ();
   p.temperature = [9.7e7, 3.2e7];
   p.norm = [ 0.016, 0.0156];
   p.elem = [Fe, Ne];
   p.elem_abund = [ 0.2, 2 ];

   create_aped_fun ("Aped", p);
   fit_fun("Aped(1)");
}

create_aped_model ();
save_par ("aped.p");
