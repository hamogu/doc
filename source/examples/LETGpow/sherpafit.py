# Sherpa code

load_pha('letgplaw_pha2.fits')
load_arf('legLEG_-1_garf.fits')
load_arf('legLEG_-1_garf.fits')
load_rmf('leg-1_rmf.fits')
set_source(xsphabs.a * xspowerlaw.xp)

group_counts(25)
fit()

# Do not display a window
# Delete this line for interactive use!
set_preferences(['window.display', False])

plot_fit_delchi()
log_scale(X_AXIS)
print_window('m1_fit.png', ['clobber', True])
print_window('m1_fit.eps', ['clobber', True])
