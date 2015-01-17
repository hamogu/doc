'''This module collects some utilities for figure creation for the MARX documentation.'''

figureformat = ['.eps', '.pdf', '.png']


def savefig(figure, basename):
    '''Save figure in different formats.

    Parameters
    ----------
    figure : mpl.figure
    basename : string
        name (with path if not current directory) for the figure.
        Filetype will be added automatically.
    '''
    for f in figureformat:
        figure.savefig(basename + f)
