:title: Custom Integrator
:status: hidden
:slug: custom-integrator

We will use the same differential equations for the `SIR model`_ as previously
introduced. The right hand side of the ordinary differential equations are
evaluated with the following function |eval_SIR_rhs|_:

.. code-include:: ../scripts/eval_SIR_rhs.m
   :lexer: matlab

.. _SIR model: https://en.wikipedia.org/wiki/Compartmental_models_in_epidemiology#The_SIR_model
.. |eval_SIR_rhs| replace:: ``eval_SIR_rhs.m``
.. _eval_SIR_rhs: {filename}/scripts/eval_SIR_rhs.m

The following function |euler_integrate|_ implements `Euler's Method` of integration and is
designed to be a drop in replacement for ``ode45()``:

.. code-include:: ../scripts/euler_integrate.m
   :lexer: matlab

.. _Euler's Method: https://en.wikipedia.org/wiki/Euler_method
.. |euler_integrate| replace:: ``euler_integrate.m``
.. _euler_integrate: {filename}/scripts/euler_integrate.m

The ordinary differential equations are integrated (simulated) with the
following script |simulate_SIR_model_euler|_:

.. code-include:: ../scripts/simulate_SIR_model_euler.m
   :lexer: matlab

.. |simulate_SIR_model_euler| replace:: ``simulate_SIR_model_euler.m``
.. _simulate_SIR_model_euler: {filename}/scripts/simulate_SIR_model_euler.m

And produces the following figure:

.. image:: https://objects-us-east-1.dream.io/eme134/2020s/euler-ode45-comparison.png
   :width: 800px

The Euler Method deviates from the ``ode45()`` solution due to the poorer error
properties of the method.

A simple `Runga-Kutta Method`_ of order 4 can also be implemented and compared to
the Runga-Kutta method used by ``ode45()``. The file |runga_kutta_integrate|_
is shown below:

.. _Runga-Kutta Method: https://en.wikipedia.org/wiki/Runge%E2%80%93Kutta_methods

.. code-include:: ../scripts/runga_kutta_integrate.m
   :lexer: matlab

.. _Euler's Method: https://en.wikipedia.org/wiki/Euler_method
.. |runga_kutta_integrate| replace:: ``runga_kutta_integrate.m``
.. _runga_kutta_integrate: {filename}/scripts/runga_kutta_integrate.m

The ordinary differential equations are integrated (simulated) with the
following script |simulate_SIR_model_ode45_euler|_:

.. code-include:: ../scripts/simulate_SIR_model_ode45_euler.m
   :lexer: matlab

.. |simulate_SIR_model_ode45_euler| replace:: ``simulate_SIR_model_ode45_euler.m``
.. _simulate_SIR_model_ode45_euler: {filename}/scripts/simulate_SIR_model_ode45_euler.m

And produces the following figure:

.. image:: https://objects-us-east-1.dream.io/eme134/2020s/euler-ode45-runga-kutta-comparison.png
   :width: 800px

The custom Runga-Kutta method is essentially identical to the ``ode45()``
result for this system.
