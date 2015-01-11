'''Custom Sphinx extension for MARX

'''

import re
from itertools import groupby

from docutils import nodes
from docutils.parsers.rst import directives

from sphinx import addnodes
from sphinx.roles import XRefRole
from sphinx.domains import ObjType, Index
from sphinx.directives import ObjectDescription
from sphinx.util.docfields import TypedField
from sphinx.domains.std import GenericObject, StandardDomain


class MARXtool(ObjectDescription):
    """
    Description of a MARX tool or script.
    """
    option_spec = {
        'noindex': directives.flag,
        'language': directives.unchanged,
        'annotation': directives.unchanged,
    }

    doc_field_types = [
        TypedField('options', label='Options',
                   names=('param', 'parameter', 'arg', 'argument',
                          'keyword', 'kwarg', 'kwparam', 'option'),
                   typerolename='obj', typenames=('paramtype', 'type'),
                   can_collapse=True),
    ]

    indextext = '%s; MARX tool'

    def needs_arglist(self):
        """May return true if an empty argument list is to be generated even if
        the document contains none.
        """
        return False

    def handle_signature(self, sig, signode):
        match = re.search('(\w+)', sig)
        name = match.groups()[0]
        # At this point, we make no attempt to break up the arglist into
        # reqired parameters, keywords, optional arguments etc.
        # This would be very hard, since we would have to cover the syntax
        # of shell, IDL, S-Lang, ...
        # For our output all we want is to attach it to the name in
        # reasonable formatting.
        arglist = sig[len(name):]

        anno = self.options.get('annotation')
        lang = self.options.get('language')

        signode += addnodes.desc_name(name, name)
        # addname has a good formatting, even if it is meant for a
        # different use in sphinx for python.
        # Sphinx expects name + parameterlist, but unfortunately,
        # the parameterlist is automatically wrapped in (), so we avoid that
        # here.
        signode += addnodes.desc_addname(arglist, arglist)

        if lang:
            signode += addnodes.desc(' ' + lang, ' ' + lang)
        if anno:
            signode += addnodes.desc_annotation(' ' + anno, ' ' + anno)
        return name

    def add_target_and_index(self, name, sig, signode):
        if name not in self.state.document.ids:
            signode['ids'].append(name)
            self.state.document.note_explicit_target(signode)
            objects = self.env.domaindata['std']['objects']
            if name in objects:
                self.state_machine.reporter.warning(
                    'duplicate object description of %s, ' % name +
                    'other instance in ' +
                    self.env.doc2path(objects[name][0]) +
                    ', use :noindex: for one of them',
                    line=self.lineno)
            objects['marxtool', name] = (self.env.docname, name)

        indextext = self.indextext % name
        self.indexnode['entries'].append(('pair', indextext, name, ''))


class MARXpost(MARXtool):
    indextext = '%s; post-processing'


def ciao_reference_role(role, rawtext, text, lineno, inliner,
                        options={}, content=[]):
    '''Automatically construct the right URL for a CIAO tool'''
    ref = "http://cxc.harvard.edu/ciao/ahelp/{0}.html".format(text.strip())
    node = nodes.reference(rawtext, text, refuri=ref, **options)
    return [node], []


class Parameter(GenericObject):
    # use this line to make them show up in general index
    # indextemplate = 'pair: %s; MARX parameter'
    # use this line to NOT have them in general index
    indextemplate = ''


class ParRole(XRefRole):
    """Role that recognizes MARX parameters in expressions like ``par=5``"""
    def process_link(self, env, refnode, has_explicit_title, title, target):
        """Called after parsing title and target text, and creating the
        reference node (given in *refnode*).  This method can alter the
        reference node and must return a new (or the same) ``(title, target)``
        tuple.
        """
        return title, target.split('=')[0].strip()


class MARXParIndex(Index):
    """
    Index subclass to provide the MARX Parameter index.
    """

    name = 'parindex'
    localname = 'MARX Parameter Index'
    shortname = 'MARX Parameters'

    def generate(self, docnames=None):
        entries = []
        objects = self.domain.data['objects']
        parameters = [o for o in objects if o[0] == 'parameter']
        for p in parameters:
            docname, anchor = objects[p]
            # can use this for more info, e.g.
            # a = one line description of par
            # b = 'default'
            # c = value for default from default file
            #     (I need to check how MARX determines the default)
            # entries.append([p[1], 0, docname, anchor, 'a', 'b', 'c'])
            entries.append([p[1], 0, docname, anchor, '', '', ''])
        # sort alphabetically, without "key" upper and lower case would
        # be separate
        entries = sorted(entries, key=lambda x: x[0][0].upper())
        content = []
        # key can be anything!
        for k, g in groupby(entries, key=lambda x: x[0][0].upper()):
            content.append((k, list(g)))

        return content, False


def setup(app):
    app.add_directive('marxtool', MARXtool)
    StandardDomain.object_types['marxtool'] = ObjType('marxtool', 'marxtool')
    # (objname or directivename, rolename)
    StandardDomain.roles['marxtool'] = XRefRole(warn_dangling=True)

    app.add_directive('marxpost', MARXpost)
    StandardDomain.object_types['marxpost'] = ObjType('marxpost', 'marxtool')
    StandardDomain.roles['marxpost'] = XRefRole(warn_dangling=True)

    app.add_role('ciao', ciao_reference_role)

    app.add_directive('parameter', Parameter)
    StandardDomain.object_types['parameter'] = ObjType('parameter', 'par')

    StandardDomain.roles['par'] = ParRole()

    app.add_index_to_domain('std', MARXParIndex)
    StandardDomain.initial_data['labels']['parindex'] = ('std-parindex', '', 'Marx Parameters')
    StandardDomain.initial_data['anonlabels']['parindex'] = ('std-parindex', '')
