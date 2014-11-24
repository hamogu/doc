'''Custom Sphinx extension for MARX

'''



import re

from docutils import nodes
from docutils.parsers.rst import directives

from sphinx import addnodes
from sphinx.roles import XRefRole
from sphinx.domains import Domain, ObjType, Index
from sphinx.directives import ObjectDescription
from sphinx.util.nodes import make_refnode
from sphinx.util.compat import Directive
from sphinx.util.docfields import Field, GroupedField, TypedField
from sphinx.domains.std import GenericObject, Target, StandardDomain


def _pseudo_parse_arglist(signode, arglist):
    """"Parse" a list of arguments separated by commas.

    Arguments can have "optional" annotations given by enclosing them in
    brackets.  Currently, this will split at any comma, even if it's inside a
    string literal (e.g. default argument value).
    """
    paramlist = addnodes.desc_parameterlist()
    stack = [paramlist]
    try:
        for argument in arglist.split(','):
            argument = argument.strip()
            ends_open = ends_close = 0
            while argument.startswith('['):
                stack.append(addnodes.desc_optional())
                stack[-2] += stack[-1]
                argument = argument[1:].strip()
            while argument.startswith(']'):
                stack.pop()
                argument = argument[1:].strip()
            while argument.endswith(']'):
                ends_close += 1
                argument = argument[:-1].strip()
            while argument.endswith('['):
                ends_open += 1
                argument = argument[:-1].strip()
            if argument:
                stack[-1] += addnodes.desc_parameter(argument, argument)
            while ends_open:
                stack.append(addnodes.desc_optional())
                stack[-2] += stack[-1]
                ends_open -= 1
            while ends_close:
                stack.pop()
                ends_close -= 1
        if len(stack) != 1:
            raise IndexError
    except IndexError:
        # if there are too few or too many elements on the stack, just give up
        # and treat the whole argument list as one argument, discarding the
        # already partially populated paramlist node
        signode += addnodes.desc_parameterlist()
        signode[-1] += addnodes.desc_parameter(arglist, arglist)
    else:
        signode += paramlist



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
        sig = sig.split()
        name = sig[0]
        arglist = " ".join(sig[1:])

        anno = self.options.get('annotation')
        lang = self.options.get('language')

        signode += addnodes.desc_name(name, name)

        #if arglist:
        _pseudo_parse_arglist(signode, arglist)
#            for arg in arglist:
                #signode += addnodes.desc_parameterlist(arglist, arglist)
                #signode[-1] += addnodes.desc_parameter(arglist, arglist)

                #addnodes.desc_parameter(arg, arg)
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
                    'duplicate object description of %s, ' % fullname +
                    'other instance in ' +
                    self.env.doc2path(objects[fullname][0]) +
                    ', use :noindex: for one of them',
                    line=self.lineno)
            objects['marxtool', name] = (self.env.docname, name)

        indextext = self.indextext % name
        self.indexnode['entries'].append(('pair', indextext,
                                              name , ''))


class MARXpost(MARXtool):
    indextext = '%s; post-processing'


def ciao_reference_role(role, rawtext, text, lineno, inliner,
                       options={}, content=[]):
    '''Automatically construct the right URL for a CIAO tool'''
    ref = "http://cxc.harvard.edu/ciao/ahelp/{0}.html".format(text.strip())
    node = nodes.reference(rawtext, text, refuri=ref, **options)
    return [node], []


class Parameter(GenericObject):
    indextemplate = 'pair: %s; MARX parameter'


class ParRole(XRefRole):
    """Role to mark up MARX paramters that recognizes them in expressions like par=5"""
    def process_link(self, env, refnode, has_explicit_title, title, target):
        """Called after parsing title and target text, and creating the
        reference node (given in *refnode*).  This method can alter the
        reference node and must return a new (or the same) ``(title, target)``
        tuple.
        """
        return title, target.split('=')[0].strip()


def setup(app):
    app.add_directive('marxtool', MARXtool)
    StandardDomain.object_types['marxtool'] = \
            ObjType('marxtool', 'marxtool')
            #(objname or directivename, rolename)
    StandardDomain.roles['marxtool'] = XRefRole(warn_dangling=True)

    app.add_directive('marxpost', MARXpost)
    StandardDomain.object_types['marxpost'] = \
            ObjType('marxpost', 'marxtool')
    #StandardDomain.roles['marxpost'] = XRefRole(warn_dangling=True)

    app.add_role('ciao', ciao_reference_role)

    app.add_directive('parameter', Parameter)
    StandardDomain.object_types['parameter'] = \
        ObjType('parameter', 'par')

    StandardDomain.roles['par'] = ParRole()

