The first time you start working in the repository, set up a clean test
environment::

  virtualenv .venv

Next, each time you start working, enter the environment::

  source .venv/bin/activate

The HaaS has an unspecified dependency on the ``moc-rest`` library:

.. https://github.com/cci-moc/moc-rest

The recommended way for developers to satisfy this is to clone that repository,
and then (while in the virtual environment)::

  pip install -e ${path_to_moc_rest_clone}

Next, proceed with installing the HaaS and the rest of its dependencies into
the virtual environment::

  pip install -e .

On systems with older versions of ``pip``, such as Debian Wheezy and Ubuntu
12.04, this install will fail with the following error::

  AttributeError: 'NoneType' object has no attribute 'skip_requirements_regex'

Fix this by upgrading ``pip`` within the virtual environment::

  pip install --upgrade pip

Versions of python prior to 2.7 don't have importlib as part of their
standard library, but it is possible to install it separately. If you're
using python 2.6 (which is what is available on CentOS 6, for example),
you may need to run::

  pip install importlib


**Testing the HaaS**
====================


Now the ``haas`` executable should be in your path.  First, create a
configuration file by copying ``haas.cfg.example`` to ``haas.cfg``, and
editing it as appropriate.  (In particular, if you are testing deployment, you
should read the comments in ``haas.cfg.example`` to see what options are
relevant.)  Then initialize the database with the required tables, with ``haas
init_db``.  Run the server with ``haas serve``.  Finally, see ``haas help``
for the various API commands one can test.  Here is an example session,
testing ``headnode_delete_hnic``::

  haas project_create proj
  haas headnode_create hn proj
  haas headnode_create_hnic hn hn-eth0
  haas headnode_delete_hnic hn hn-eth0


Additionally, before each commit, run the automated test suite with ``py.test
tests``.  This will do only the most basic level of testing.  For additional
features, including coverage reporting, see ``docs/testing.md``
