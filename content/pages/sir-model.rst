:title: SIR Epidemic Model
:status: hidden
:slug: sir-model

The simplest ordinary differential equations that describe the spread of
disease in a population are:

.. math::

   \dot{S} = -\beta I \frac{S}{N} \\
   \dot{I} = \beta I \frac{S}{N} - \frac{I}{\tau} \\
   \dot{R} = \frac{I}{\tau}

where:

.. math::

   N = S + I + R

This is the so called `SIR model`_. The time varying variables are:

- :math:`S`: number of people susceptible to infection
- :math:`I`: number of people infected
- :math:`R`: number of people recovered (i.e. no longer susceptible)
- :math:`N`: total number of people

.. _SIR model: https://en.wikipedia.org/wiki/Compartmental_models_in_epidemiology#The_SIR_model

The constant parameters are:

- :math:`\beta`: the time rate of infectious transmissions
- :math:`\tau`: the mean infectious period
- :math:`R_0 = \beta\tau`: the basic reproduction number

The right hand side of the ordinary differential equations are evaluated with
the following function |eval_SIR_rhs|_:

.. code-include:: ../scripts/eval_SIR_rhs.m
   :lexer: matlab

.. |eval_SIR_rhs| replace:: ``eval_SIR_rhs.m``
.. _eval_SIR_rhs: {filename}/scripts/eval_SIR_rhs.m

The ordinary differential equations are integrated (simulated) with the
following script |simulate_SIR_model|_:

.. code-include:: ../scripts/simulate_SIR_model.m
   :lexer: matlab

.. |simulate_SIR_model| replace:: ``simulate_SIR_model.m``
.. _simulate_SIR_model: {filename}/scripts/simulate_SIR_model.m
