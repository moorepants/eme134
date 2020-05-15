:title: Lab 4: Bicycle Stability and Control
:status: hidden
:slug: lab-04

.. contents::

Learning Objectives
===================

After completing this lab you will be able to:

- formulate the explicit first order ordinary differential equations for the
  roll and steer dynamics of a bicycle
- translate ordinary differential equations into a computer function that
  evaluates the equations at any given point in time
- develop a function that evaluates state dependent input functions
- develop a function that evaluates state and input dependent output variables
- numerically integrate ordinary differential equations with Octave/Matlab's
  ode45_
- create complete and legible plots of the resulting input, state, and output
  trajectories
- create a report with textual explanations and plots of the simulation
- evaluate a bicycle model for stability at different speeds
- design a feedback controller that stabilizes a bicycle at different speeds
- design a bicycle that is self-stable at low speeds

.. _ode45: https://www.mathworks.com/help/matlab/ref/ode45.html

.. topic:: Information
   :class: alert alert-info

   Extra information (asides) are in blue boxes.

.. topic:: Warnings
   :class: alert alert-warning

   Warnings are in yellow boxes.

Introduction
============

In this lab, you will investigate the dynamics of a bicycle with and without a
controller to assist in balancing. Bicycles and motorcycles share the same core
dynamic behavior, so this lab will introduce you to phenomena that apply to
both vehicles. Below is a video that demonstrates a bicycle's uncanny ability
to be self-stable, i.e. return to an upright configuration even when perturbed
from its equilibrium. This is, of course, not always possible as we know that a
bicycle will simply fall over if it has no forward speed and we also know that
bicycles require some control from the rider in general. In this lab, you will
simulate the Whipple-Carvallo bicycle model, investigate its dynamics, apply a
controller to stabilize it at low speeds, and design a bicycle that can
self-stabilize at lower speeds.

.. raw:: html

   <iframe width="560" height="315"
   src="https://www.youtube.com/embed/pOkDbXEJb8E" frameborder="0"
   allow="accelerometer; autoplay; encrypted-media; gyroscope;
   picture-in-picture" allowfullscreen></iframe>

System Description
==================

The Whipple-Carvallo bicycle model is essentially the simplest model that
behaves like a bicycle and can exhibit self-stability. "Self-stability" is
defined as open loop stability or  stability without any control inputs. The
model was developed by both Whipple and Carvallo around the turn of the 20th
century. In 2007, Meijaard, Papdopoulos, Ruina, and Schwab validated the model
and presented a benchmark formulation [Meijaard2007]_. You'll be using this
formulation for the lab. This model assumes no-slip non-deforming tires, a flat
level surface, frictionless revolute joints, and a human rider that is rigidly
fixed to the rear bicycle frame. See the cited paper for more details about the
history of the model, its derivation, and in-depth analysis. Figure 1 shows the
basic geometry and the four rigid bodies: [B] rear frame and human body, [H]
handlebar and fork, [R] rear wheel, and [F] front wheel.

.. figure:: https://moorepants.github.io/resonance/14/bicycle-model.jpg
   :align: center

   **Figure 1**: Schematic of the benchmark bicycle model.

.. [Meijaard2007] J.P Meijaard, Jim M Papadopoulos, Andy Ruina and A.L Schwab, 2007,
   Linearized dynamics equations for the balance and steer of a bicycle: a
   benchmark and review, Proc. R. Soc. A. 4631955–1982
   http://doi.org/10.1098/rspa.2007.1857

Equations of Motion
-------------------

The equations of motion for the Whipple-Carvallo benchmark bicycle model are
presented below in a canonical-like linear form:

.. math::

   \mathbf{M}\ddot{\bar{q}} + v\mathbf{C}_1\dot{\bar{q}} +
   \left[g\mathbf{K}_0 + v^2\mathbf{K}_2\right]\bar{q} = \bar{F}

where

.. math::

   \bar{q} = & [\phi \quad \delta]^T \\
   \bar{F} = & [T_\phi \quad T_\delta]^T

The time varying variables are:

.. list-table::
   :class: table table-striped table-bordered
   :header-rows: 1

   * - Symbol
     - Description
     - Units
   * - :math:`\phi`
     - Roll angle of the bicycle's rear frame relative to the ground. Positive
       about the x axis (rightward lean).
     - :math:`\textrm{rad}`
   * - :math:`\delta`
     - Steer angle; angle between handlebar + fork and rear frame. Positive is
       rotation about the ~z axis (rightward steer).
     - :math:`\textrm{rad}`
   * - :math:`\omega=\dot{\phi}`
     - Roll angular rate.
     - :math:`\textrm{rad/s}`
   * - :math:`\beta=\dot{\delta}`
     - Steer angular rate.
     - :math:`\textrm{rad/s}`
   * - :math:`T_\phi`
     - Roll torque (between ground and rear frame)
     - :math:`\textrm{N}\cdot\textrm{m}`
   * - :math:`T_\delta`
     - Steer torque (between rear frame and handlebar + fork)
     - :math:`\textrm{N}\cdot\textrm{m}`

You will need to formulate the equations of motion as four explicit linear
ordinary differential equations in first order form for your state derivative
function. The state space form is a good best way to do this:

.. math::

   \dot{\bar{x}} = \mathbf{A} \bar{x} + \mathbf{B} \bar{u}

where

.. math::

   \bar{x} = & [\phi \quad \delta \quad \omega \quad \beta]^T \\
   \bar{u} = & \bar{F}

Use matrix algebra to determine :math:`A` and :math:`B` from the canonical form
matrices.

You will use the section `Defining the State Derivative Function
<https://moorepants.github.io/eme171/ode-integration-best-practices-with-octavematlab.html#defining-the-state-derivative-function>`_
for these equations.

Inputs
------

You will examine two inputs scenarios:

No control
   :math:`T_\phi` and :math:`T_\delta` should both be set to zero for all time.
   These inputs will be used to examine the self-stability of the bicycle.
Roll rate feedback control
   Define an input function that applies a steer torque :math:`T_\delta`
   proportional to the negative roll angular rate. This is a classic "negative
   feedback" controller that will attempt to drive the roll rate to zero. The
   controller equation is:

   .. math::

      T_\delta = -k\omega

See `Time Varying Inputs
<https://moorepants.github.io/eme171/ode-integration-best-practices-with-octavematlab.html#time-varying-inputs>`_
for more information.

Outputs
-------

The output function should return all of the state variables and the steering
torque input. Include these five time varying variables in your simulation
plots. You will use the section `Outputs Other Than The States
<https://moorepants.github.io/eme171/ode-integration-best-practices-with-octavematlab.html#outputs-other-than-the-states>`_
to compute these values.

Constant Parameters
-------------------

The majority of the variables in the differential equations and input equations
above do not vary with time, i.e. they are constant. Below is a table with an
explanation of each variable, its value, and its units. Note that the units are
a self consistent set of SI base units. The values given represent a typical
bicycle and rider.

.. list-table::
   :class: table table-striped table-bordered
   :header-rows: 1

   * - Symbol
     - Matlab variable
     - Description
     - Value
     - Units
   * - :math:`I_{Bxx}`
     - ``IBxx``
     - Rear frame and human body x moment of inertia
     - 9.2
     - :math:`\textrm{kg}\cdot\textrm{m}^2`
   * - :math:`I_{Bxz}`
     - ``IBxz``
     - Rear frame and human body xz product of inertia
     - 2.4
     - :math:`\textrm{kg}\cdot\textrm{m}^2`
   * - :math:`I_{Byy}`
     - ``IByy``
     - Rear frame and human body y moment of inertia
     - 11.0
     - :math:`\textrm{kg}\cdot\textrm{m}^2`
   * - :math:`I_{Bzz}`
     - ``IBzz``
     - Rear frame and human body z moment of inertia
     - 2.8
     - :math:`\textrm{kg}\cdot\textrm{m}^2`
   * - :math:`I_{Fxx}`
     - ``IFxx``
     - Front wheel radial moment of inertia
     - 0.1405
     - :math:`\textrm{kg}\cdot\textrm{m}^2`
   * - :math:`I_{Fyy}`
     - ``IFyy``
     - Front wheel spin moment of inertia
     - 0.28
     - :math:`\textrm{kg}\cdot\textrm{m}^2`
   * - :math:`I_{Hxx}`
     - ``IHxx``
     - Handlebar and fork x moment of inertia
     - 0.05892
     - :math:`\textrm{kg}\cdot\textrm{m}^2`
   * - :math:`I_{Hxz}`
     - ``IHxz``
     - Handlebar and fork xz product of inertia
     - -0.00756
     - :math:`\textrm{kg}\cdot\textrm{m}^2`
   * - :math:`I_{Hyy}`
     - ``IHyy``
     - Handlebar and fork y moment of inertia
     - 0.06
     - :math:`\textrm{kg}\cdot\textrm{m}^2`
   * - :math:`I_{Hzz}`
     - ``IHzz``
     - Handlebar and fork z moment of inertia
     - 0.00708
     - :math:`\textrm{kg}\cdot\textrm{m}^2`
   * - :math:`I_{Rxx}`
     - ``IRxx``
     - Rear wheel radial moment of inertia
     - 0.0603
     - :math:`\textrm{kg}\cdot\textrm{m}^2`
   * - :math:`I_{Ryy}`
     - ``IRyy``
     - Rear wheel spin moment of inertia
     - 0.12
     - :math:`\textrm{kg}\cdot\textrm{m}^2`
   * - :math:`c`
     - ``c``
     - Trail
     - 0.08
     - :math:`\textrm{m}`
   * - :math:`g`
     - ``g``
     - Acceleration due to gravity
     - 9.81
     - :math:`\textrm{m/s}^2`
   * - :math:`\lambda`
     - ``lambda``
     - Steer axis tilt
     - :math:`\pi/10`
     - :math:`\textrm{rad}`
   * - :math:`m_B`
     - ``mB``
     - Mass of rear frame and human body
     - 85.0
     - :math:`\textrm{kg}`
   * - :math:`m_F`
     - ``mF``
     - Mass of front wheel
     - 3.0
     - :math:`\textrm{kg}`
   * - :math:`m_H`
     - ``mH``
     - Mass of handlebar and fork
     - 4.0
     - :math:`\textrm{kg}`
   * - :math:`m_R`
     - ``mR``
     - Mass of rear wheel
     - 2.0
     - :math:`\textrm{kg}`
   * - :math:`r_F`
     - ``rF``
     - Radius of front wheel
     - 0.35
     - :math:`\textrm{m}`
   * - :math:`r_R`
     - ``rR``
     - Radius of rear wheel
     - 0.3
     - :math:`\textrm{m}`
   * - :math:`w`
     - ``w``
     - Wheelbase
     - 1.02
     - :math:`\textrm{m}`
   * - :math:`x_B`
     - ``xB``
     - Rear frame and human body mass center x coordinate
     - 0.3
     - :math:`\textrm{m}`
   * - :math:`x_H`
     - ``xH``
     - Handlebar and fork mass center x coordinate
     - 0.9
     - :math:`\textrm{m}`
   * - :math:`z_B`
     - ``zB``
     - Rear frame and human body mass center z coordinate
     - -0.9
     - :math:`\textrm{m}`
   * - :math:`z_H`
     - ``zH``
     - Handlebar and fork mass center z coordinate
     - -0.7
     - :math:`\textrm{m}`
   * - :math:`v`
     - ``v``
     - Speed, positive is forward.
     - varies
     - :math:`\textrm{m/s}`
   * - :math:`k`
     - ``k``
     - Control gain
     - varies
     - :math:`\textrm{Nms}`

The following function |compute_benchmark_bicycle_matrices|_ computes
:math:`\mathbf{M,C1,K0,K2}` given a structure with the above constant
parameters defined. Use this function along with your m-files to setup your
model.

.. code-include:: ../scripts/compute_benchmark_bicycle_matrices.m
   :lexer: matlab

.. |compute_benchmark_bicycle_matrices| replace:: ``compute_benchmark_bicycle_matrices.m``
.. _compute_benchmark_bicycle_matrices: {filename}/scripts/compute_benchmark_bicycle_matrices.m

You will use the section `Integrating the Equations
<https://moorepants.github.io/eme171/ode-integration-best-practices-with-octavematlab.html#integrating-the-equations>`_
to for these values.

Initial Conditions
==================

For the simulations, set the initial conditions as:

.. math::

   \bar{x}(0) = [5 \textrm{ deg} \quad -2 \textrm{ deg} \quad 0 \quad 0]^T

This will start the vehicle off with a small roll and steer angle. See
`Integrating the Equations
<https://moorepants.github.io/eme171/ode-integration-best-practices-with-octavematlab.html#integrating-the-equations>`_
for how to set up the initial condition vector. Make sure that your initial
conditions are arranged in the same order as your state variables.

Time Steps
==========

Simulate the system for 5 seconds with time steps of 1/100th of a second.

Eigenvalues and Stability
=========================

Matlab and Octave can easily calculate the roots of the characteristic
equation, i.e. the eigenvalues, given a state dynamics matrix
:math:`\mathbf{A}`.  The ``eig()`` function calculates the eigenvalues. It is
used like so:

.. code-block:: matlab

   evals = eig(A);

The variable ``evals`` will then contain a vector of eigenvalues. The functions
``real()`` and ``imag()`` are also helpful to extract the real and imaginary
parts of the complex eigenvalues.

See the Matlab documentation for more about these functions:

- https://www.mathworks.com/help/matlab/ref/eig.html
- https://www.mathworks.com/help/matlab/ref/real.html
- https://www.mathworks.com/help/matlab/ref/imag.html

.. topic:: Plotting the eigenvalues
   :class: alert alert-warning

   The bicycle's stability is speed dependent, so it will be useful to plot the
   real part of the eigenvalues versus the speed :math:`v` to determine this
   relationship. Make sure to only plot a dot for each data point, otherwise
   you'll get a very hard to interpret plot, e.g.:

   .. code-block:: matlab

      plot(speeds, real_part_of_evals, '.')

Using a Root Locus To Choose a Feedback Gain
============================================

A `root locus`_ is a parametric plot of the complex plane that shows how the
roots of the characteristic equation change with respect to changes in a single
parameter in a linear model. Any parameter can be chosen but the most common
parameter is a proportional control gain of a closed loop negative feedback
controller. It turns out that the Whipple-Carvallo bicycle model can be
stabilized by "steering into the fall". One way to formalize this statement is
to apply steer torque in the direction of the roll angular rate, i.e. if you
roll towards the right, steer towards the right. You'll first need to determine
the transfer function that relates the steer torque input :math:`T_\delta` to
the roll angular rate :math:`\omega`:

.. math::

   \frac{\omega(s)}{T_\delta(s)}

You can use `Cramer's rule`_ to find this transfer function, as in the book, or
there are various Matlab/Octave functions that can help, for example
``ss2tf()`` can convert a state space system to equivalent transfer functions.
If you use Cramer's rule you'll need to use the ``tf()`` function to construct
the transfer function in Matlab/Octave. There isn't any reason to do any
algebra by hand, use Matlab/Octave to do the number crunching.

Once you have a transfer function you can use the ``rlocus()`` function to make
a standard root locus plot as a function of the negative feedback gain
:math:`k`. You'll need to examine this plot to determine what gain value
ensures that all roots are in the left half of the complex plane.

- https://www.mathworks.com/help/matlab/ref/ss2tf.html
- https://www.mathworks.com/help/matlab/ref/tf.html
- https://www.mathworks.com/help/control/ref/tf.rlocus.html

.. topic:: Sign of the feedback gain
   :class: alert alert-warning

   The root locus function assumes a negative feedback gain, i.e. that
   :math:`T_\delta=-k\omega`, thus you provide a positive value of the gain to
   get negative feedback. Think very carefully about the "steer into the fall"
   and the sign conventions of the state variables. You'll need to setup your
   root locus to examine gains that cause a "steer into the fall".

.. _root locus: https://en.wikipedia.org/wiki/Root_locus
.. _Cramer's rule: https://en.wikipedia.org/wiki/Cramer%27s_rule

Checking your work
==================

You can use the BicycleParameters web app to visualize the bicycle geometry and
to double check your eigenvalue plots. Visit the app here:

http://bicycleparameters.herokuapp.com/

This app was recently developed by a UCD physics undergraduate, Noah Sanders,
and is powered by similar calculations that you are doing in this lab. It is
still in beta and there may be some bugs, but you should be able to edit the
parameters in the table to see changes in the two figures.

Deliverables
============

In your lab report, show your work for creating and evaluating the simulation
model. Include any calculations you had to do, for example those for state
equations, initial conditions, input equations, time parameters, and any other
parameters. Additionally, provide the indicated plots and answer the questions
below. Append a copy of your Matlab/Octave code to the end of the report. The
report should follow the `report template and guidelines
<{filename}/pages/report-template.rst>`_.

Submit a report as a single PDF file to Canvas by the due date that addresses
the following items:

1. Create a function defined in an m-file that evaluates the right hand side of
   the ODEs, i.e. evaluates the state derivatives. See `Defining the State
   Derivative Function`_ for an explanation.
2. Create two functions defined each in an m-file that calculates the two
   requested inputs: no control and with control. See `Time Varying Inputs`_
   for an explanation.
3. Create a function defined in an m-file that calculates the requested
   outputs. See `Outputs Other Than the States`_  and `Outputs Involving State
   Derivatives`_ for an explanation.
4. Create a script in an m-file that utilizes the above functions to simulate
   system for the scenarios described below. This should setup the constants,
   integrate the dynamics equations, and plot each state, and output versus
   time. See `Integrating the Equations`_ for an explanation.
5. Make a plot where the Y axis is the real part of the eigenvalues (determines
   growth or decay and the rate) and the X axis is the bicycle speed. The
   speeds should vary from 0 to 10 m/s (0 to ~22 mph). Discuss how the bicycle's
   self-stability relates to the speed and discuss any speed values that stand
   out and what the eigenvalues at this speed tell you about the motion. Use
   simulation (states vs time: 0 to 5 seconds) plots to back up your
   explanations at the particular speeds of interest. Be sure to explain your
   simulation plots in terms of growth/decay rates, oscillation frequencies,
   and phase differences in the states. Limit your Y axis to +/- 90 degs for
   unstable simulations.
6. Develop two roll feedback controllers using a root locus to select an
   appropriate gain to stabilize the bicycle at 2 m/s and 8 m/s. At 2 m/s
   feedback roll rate. At 8 m/s feedback roll angle. Both controllers should
   control steer torque. Choose gains that give realistic decay rates and
   oscillation frequencies (a human's arm control bandwidth has an upper bound
   of about 10 rad/s).  Simulate the system at these speeds with the controller
   defined in an input function to show that the system is stable.  Discuss the
   sign of the gain values.
7. Design a bicycle by changing any number of the parameters values so that it
   is self-stable (no control) at a very low range of speeds. Try not to choose
   parameter values that would be impossible to actually build, e.g. a
   wheelbase that is 100 meters long or rear frame/human mass of 1 kg. There is
   no single solution to this. Once you chose a bike, simulate it at a very low
   speed and discuss the simulation results and the advantages/disadvantages of
   the bicycle design. A practical use of a bicycle that is self-stable at low
   speeds could be to make it easy for people to learn to ride a bicycle. The
   videos below show bicycles designed for low-speed stability:

   .. raw:: html

      <iframe width="560" height="315"
      src="https://www.youtube.com/embed/VFeNpyd7Ng8" frameborder="0"
      allow="accelerometer; autoplay; encrypted-media; gyroscope;
      picture-in-picture" allowfullscreen></iframe>

   .. raw:: html

      <iframe width="560" height="315"
      src="https://www.youtube.com/embed/YmtPNIu4WI0" frameborder="0"
      allow="accelerometer; autoplay; encrypted-media; gyroscope;
      picture-in-picture" allowfullscreen></iframe>

.. _Outputs Involving State Derivatives: https://moorepants.github.io/eme171/ode-integration-best-practices-with-octavematlab.html#outputs-involving-state-derivatives

Assessment Rubric
=================

.. list-table:: Score will be between 30 and 100.
   :class: table table-striped table-bordered
   :header-rows: 1

   * - Topic
     - [10 pts] Exceeds expectations
     - [5 pts] Meets expectatoins
     - [0 pts] Does not meet expectations
   * - Functions
     - All Matlab/Octave functions are present and take correct inputs and
       produce the expected outputs.
     - Some of the functions are present and mostly take correct inputs and
       produce the expected outputs
     - No functions are present or not working at all.
   * - Main Script
     - Constant parameters only defined once in main script(s);
       Integration produces the correct state, input, and output trajectories;
       Good choices in number of time steps and resolution are chosen and
       justified; Intermediate calculations present and functioning.
     - Parameters are defined in multiple places; Integration produces some
       correct state, input, and output trajectories; Poor choices in number of
       time steps and resolution are chosen; Intermediate calculations mostly
       present and functioning.
     - Constants defined redundantly; Integration produces incorrect
       trajectories; Poor choices in time duration and steps; Intermediate
       calculations not present or functioning.
   * - Eigenvalue plot
     - Eigenvalue vs. speed plot is correct; At least three unique speeds
       identified and the behavior at each speed is explained via simulation
       plots and a correct explanation.
     - Eigenvalue vs. speed plot is mostly correct; As least one unique speed
       is identified and the behavior at that speed is explained via
       simjulation plots and reasonably explanation.
     - No eigenvalue vs. speed plot present and no simulations created for
       unique speeds. No explanations.
   * - Control
     - Roll rate feedback controller functions and a root locus plot is shown
       and used to select an appropriate gain. Simulations show stability at
       each speed and comments on the gain values at each speed are provided.
     - Roll rate feedback controller functions but no root locus plot is shown
       and used to select an appropriate gain. Simulations mostly show
       stability at each speed or some speeds are missing; Comments on the gain
       values at most speeds are provided.
     - Roll rate feedback controller does not function; Not apparent that a
       root locus was used to select an appropriate gain; No comments on the
       gains at each speed.
   * - Bicycle design
     - A realistic bicycle design is selected that is self-stable at lower
       speeds and the parameter selection is explained and justified. Stability
       is proven by the eigevalues or simulations. Valid explanation of the
       design's advantages and disadvantages is present.
     - A non-realistic bicycle design is selected that is self-stable at lower
       speeds and the parameter selection may not be explained and justified.
       Stability is proven by the eigevalues or simulations. Explationan of the
       design's advantages and disadvantages is present.
     - No bicycle is shown that is self-stable at lower speeds. No explanation
       of the designs are present.
   * - Report and Code Formatting
     - All axes labeled with units, legible font sizes, informative captions;
       Functions are documented with docstrings which fully explain the inputs
       and outputs; Professional, very legible, quality writing; All report
       format requirements met
     - Some axes labeled with units, mostly legible font sizes,
       less-than-informative captions; Functions have docstrings but the inputs
       and outputs are not fully explained; Semi-professional, somewhat
       legible, writing needs improvement; Most report format requirements met
     - Axes do not have labels, legible font sizes, or informative captions;
       Functions do not have docstrings; Report is not professionally written
       and formatted; Report format requirements are not met
   * - Contributions
     - Clear that all team members have made equitable contributions.
     - Not clear that contributions were equitable and you need to improve
       balance of contributions.
     - No indication of equitable contributions.
