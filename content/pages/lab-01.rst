:title: Lab 1: Train Wheelset Hunting
:status: hidden
:slug: lab-01

.. contents::

Learning Objectives
===================

After completing this lab you will be able to:

- translate ordinary differential equations into a computer function that
  evaluates the equations at any given point in time
- numerically integrate ordinary differential equations with Octave/Matlab's
  ode45_
- create complete and legible plots of the resulting input, state, and output
  trajectories
- create a report with textual explanations and plots of the simulation

.. _ode45: https://www.mathworks.com/help/matlab/ref/ode45.html

.. topic:: Information
   :class: alert alert-info

   Extra information (asides) are in blue boxes.

.. topic:: Warnings
   :class: alert alert-warning

   Warnings are in yellow boxes.

Introduction
============

This lab assignment deals with using engineering computation to numerically
integrate the differential equations generated from modeling the dynamics of a
system. The process of integrating these time dependent equations is called
"simulation". Simulation is a powerful tool for studying both linear and
non-linear systems. In this case, the differential equations are provided to
you and your job is to translate them into correctly functioning m-files and
show through plots that the simulation is working as expected and make some
observations about the system's behavior. As we move forward in the course you
will apply this method to other problems.

We have created a `guide that explains how to create a working simulation of a
simple torque driven pendulum system
<https://moorepants.github.io/eme171/ode-integration-best-practices-with-octavematlab.html>`_.
Using this guide, your goal for this lab is to apply the same methods to the
vehicle dynamics example problem described below.

The Example System
==================

A train car is generally mounted atop two bogies_, one fore and one aft. The
fixed axle wheelsets_ are then mounted to the bogies. The bogies house the
suspension system that isolates the train car from the wheelsets. The nature of
the flexible coupling between the wheelsets and the train car as well as the
dynamics of the wheelset-track interaction can cause oscillations to occur.
These oscillations can even be unstable and cause derailments. The oscillations
are called "`Hunting Oscillation`_" or "truck hunting" ("truck" refers to the
bogie and wheelset). Take a look at these videos to see some examples and
explanations of hunting oscillations:

- Train car hunting @ 1:38 [1:51]: https://youtu.be/n-EfKFxGJc4k
- Damaged car hunting @ 1:08 [2:13]: https://youtu.be/JHT-WJWdjEk
- Several cars hunting [2:58]: https://youtu.be/3i-ViwHubeE
- Animation of train truck hunting [0:28]: https://youtu.be/5GwF6x7F1LM
- Bullet train wheel design, hunting @ 2:45 [9:34]:
  https://youtu.be/SRsm7mv0Oh8 (this is pretty unscientific and doesn't give
  precisely correct information but it has some good visuals regardless, so
  don't believe everything the host is saying)

.. _bogies: https://en.wikipedia.org/wiki/Bogie
.. _wheelsets: https://en.wikipedia.org/wiki/Wheelset_(rail_transport)
.. _Hunting Oscillation: https://en.wikipedia.org/wiki/Hunting_oscillation

Below is a schematic of a simple model of this system. This schematic is
explained in detail in Chapter 10 of the course textbook, but for the purposes
of this lab you will need to have a basic understanding of the geometry. The
fixed axle wheelset is connected to the car by four linear springs of
stiffnesses :math:`k_1` and :math:`k_2`. The car and the center of the wheelset
are moving at a constant speed :math:`V`. The wheelset can move laterally
relative to the car and tracks. This lateral deviation is tracked by the time
varying variable :math:`q_1`. The yaw rotation angle of the wheelset relative
to the car and tracks is measured by the time varying variable :math:`q_2`. The
wheel-track connection is modeled by concave wheel surfaces rolling on a convex
track surface with radii :math:`R` and :math:`R'`, respectively. When there is
no lateral deviation and no yaw angle, :math:`q_1=q_2=0`, the nominal radius at
the wheel-track contact location is :math:`r_0` and the angle of the line
tangent to the connecting surfaces is :math:`\delta_0`.

.. figure:: https://objects-us-east-1.dream.io/eme134/2020s/lab-01-fig-01.png
   :width: 600px
   :align: center

   **Figure 1**: Schematics of the train wheelset model. See figures 10.1,
   10.2, and 10.3 in the book for more detail. The upper figure is the top view
   and the lower figure is a rear view.

.. _yaw rotation: https://en.wikipedia.org/wiki/Yaw_(rotation)

Equations of Motion
-------------------

With careful attention to formulating the kinematics and dynamics, the explicit
coupled first order linear ordinary differential equations that describe how
the dynamics of the system change with respect to time can be found. You will
learn how to generate these equations as we move forward in this class. For
now, we provide you with the resulting four equations:

.. math::

   \dot{q}_1 & = u_1 \\
   \dot{q}_2 & = u_2 \\
   \dot{u}_1 & = -\left[\frac{2k_1}{m_W} + \frac{2N}{m_W(R-R')}\right]q_1 + \frac{2f_x}{m_W} q_2 - \frac{2f_x}{V m_W} u_1 \\
   \dot{u}_2 & = -\frac{2f_y\lambda d}{r_0 I_W}q_1 - \frac{2k_2d_1^2}{I_W} q_2 - \frac{2f_yd^2}{V I_W} u_2

These equations define expressions for the derivatives of the four time varying
state variables :math:`q_1(t),q_2(t),u_1(t),` and :math:`u_2(t)` which are
described below.

.. list-table::
   :class: table table-striped table-bordered
   :header-rows: 1

   * - Symbol
     - Description
     - Units
   * - :math:`q_1`
     - Wheelset lateral deviation
     - :math:`\textrm{m}`
   * - :math:`q_2`
     - Wheelset yaw angle
     - :math:`\textrm{rad}`
   * - :math:`u_1`
     - Wheelset lateral velocity
     - :math:`\textrm{m/s}`
   * - :math:`u_2`
     - Wheelset yaw angular velocity
     - :math:`\textrm{rad/s}`

You will use the section `Defining the State Derivative Function
<https://moorepants.github.io/eme171/ode-integration-best-practices-with-octavematlab.html#defining-the-state-derivative-function>`_
for these equations.

.. topic:: Terminology for differential equations
   :class: alert alert-info

   - differential equation: mathematical equation that relates functions and
     their derivatives
   - ordinary differential equation: differential equations that only have
     deriviatives of a single variable; in our case time is the variable
   - coupled: the same time varying variables appear in more than one equation
   - explicit: all the time derivatives are on the lefthand side of the
     equations
   - linear: the derivatives are strictly linear functions of the time varying
     variables on the right hand side

Constant Parameters
-------------------

The majority of the variables in the four differential equations above do not
vary with time, i.e. they are constant. Below is a table with an explanation of
each variable, its value, and its units. Note that the units are a self
consistent set of SI base units.

.. list-table::
   :class: table table-striped table-bordered
   :header-rows: 1

   * - Symbol
     - Description
     - Value
     - Units
   * - :math:`I_W`
     - Yaw moment of inertia of the wheelset
     - :math:`m_w d^2`
     - :math:`\textrm{kg}\cdot\textrm{m}^2`
   * - :math:`N`
     - One quarter of the weight of the train car
     - :math:`W/4`
     - :math:`\textrm{N}`
   * - :math:`R`
     - Wheel surface radius
     - 0.23
     - :math:`\textrm{m}`
   * - :math:`R'`
     - Rail surface radius
     - 0.2
     - :math:`\textrm{m}`
   * - :math:`V`
     - Car longitudinal speed
     - 40
     - :math:`\textrm{m/s}`
   * - :math:`W`
     - Train car weight
     - 80000
     - :math:`\textrm{N}`
   * - :math:`d`
     - Half the track width
     - 0.72
     - :math:`\textrm{m}`
   * - :math:`d_1`
     - Distance to yaw spring
     - :math:`d/2`
     - :math:`\textrm{m}`
   * - :math:`\delta_0`
     - Nominal wheel-rail contact angle
     - :math:`\pi/180`
     - :math:`\textrm{rad}`
   * - :math:`f_x`
     - Lateral creep coefficient
     - :math:`1\times10^6`
     - Unitless
   * - :math:`f_y`
     - Longitudinal creep coefficient
     - :math:`1\times10^6`
     - Unitless
   * - :math:`k_1`
     - Lateral spring stiffness
     - 13000
     - :math:`N/m`
   * - :math:`k_2`
     - Longitudinal spring stiffness
     - 13000
     - :math:`N/m`
   * - :math:`m_W`
     - Wheelset mass
     - 1000
     - :math:`\textrm{kg}`
   * - :math:`r_0`
     - Nominal wheel contact radius
     - 0.46
     - :math:`\textrm{m}`
   * - :math:`\lambda`
     - Conicity
     - :math:`\frac{R\delta_0}{R - R'}`
     - Unitless

You will use the section `Integrating the Equations
<https://moorepants.github.io/eme171/ode-integration-best-practices-with-octavematlab.html#integrating-the-equations>`_
to for these values.

Outputs
-------

A train designer may be interested in knowing how much force is applied to the
wheels at the contact location from the track so that they can size the
components appropriately. The lateral and longitudinal wheel contact forces on
the right wheel can be estimated by these functions:

.. math::

   F_x(t) = \frac{f_x}{V} u_1 \\
   F_y(t) = \frac{f_y}{V} d u_2

You will use the section `Outputs Other Than The States
<https://moorepants.github.io/eme171/ode-integration-best-practices-with-octavematlab.html#outputs-other-than-the-states>`_
to compute these values.

Initial Conditions
==================

Initial conditions are the starting values for the integrated state variables
in the systems. This system has four state variables, so there are four initial
conditions. For this lab, use the initial values shown below. See `Integrating
the Equations
<https://moorepants.github.io/eme171/ode-integration-best-practices-with-octavematlab.html#integrating-the-equations>`_
for how to set up the initial condition vector.  Make sure that your initial
conditions are arranged in the same order as your state variables.

.. math::

   q_1(0) & = 0.02 \textrm{m} \\
   q_2(0) & = 1 \textrm{deg} \\
   u_1(0) & = 0 \\
   u_2(0) & = 0

Time Steps
==========

You will also have to decide on how long your simulation will run and at what
time resolution you should report values of the states, inputs, and outputs.
Some rules of thumb for making these choices:

- If your system is stable and decays, choose a simulation duration such that
  the amplitude has decayed at least 95% of the maximum amplitude.
- If your system oscillates, show at least 5 full periodic oscillations.
- If your system oscillates, plot as least fifty time points for the shortest
  observed oscillation period.

Use these rules of thumb to select a simulation duration and time step spacing
for your simulations.

Deliverables
============

In your lab report, show your work for creating and evaluating the simulation
model. Include any calculations you had to do, for example those for initial
conditions, input equations, time parameters, and any other parameters.
Additionally, provide the indicated plots and answer the questions below.
Append a copy of your Matlab/Octave code to the end of the report. The report
should follow the `report template and guidelines
<{filename}/pages/report-template.rst>`_.

Submit a report as a single PDF file to Canvas by the due date that addresses
the following items:

1. Create a function defined in an m-file that evaluates the right hand side of
   the ODEs, i.e. evaluates the state derivatives. See `Defining the State
   Derivative Function`_ for an explanation.
2. Create a function defined in an m-file that calculates the two outputs:
   lateral and longitudinal force at the right wheel.  See `Outputs Other Than
   the States`_ for an explanation.
3. Create a script in an m-file that utilizes the above two functions to
   simulate the train system. This should setup the constants, integrate the
   dynamics equations, and plot each state, and output versus time. See
   `Integrating the Equations`_ for an explanation.
4. Simulate the system twice, first at V=20 m/s (72 km/h) and then at V=50 m/s
   (180 km/h). Plot all four state variables and the two output variables in a
   single subplot that has six rows, making one plot for each simulation. Use
   plots and written text to describe the differences in the observed motion at
   the two speeds.
5. Set the velocity back to V=20 m/s and make the wheel surface
   radius :math:`R` convex instead of concave by making the value negative.
   Plot the resulting simulation state and output trajectories in a single
   subplot. Describe the motion as compared to the simulation at 20 m/s with
   concave wheel surfaces and what you learn from it.

**Use the templates below for developing your code and fill in the missing
pieces.**

.. _Defining the State Derivative Function: https://moorepants.github.io/eme171/ode-integration-best-practices-with-octavematlab.html#defining-the-state-derivative-function
.. _Time Varying Inputs: https://moorepants.github.io/eme171/ode-integration-best-practices-with-octavematlab.html#time-varying-inputs
.. _Outputs Other Than the States: https://moorepants.github.io/eme171/ode-integration-best-practices-with-octavematlab.html#outputs-other-than-the-states
.. _Integrating the Equations: https://moorepants.github.io/eme171/ode-integration-best-practices-with-octavematlab.html#integrating-the-equations

Templates for Coding
====================

Provided below are templates to utilize in coding the first lab. Your code
should be identical to the templates, but it is your job to fill in the missing
information.

Defining the State Derivative Function
--------------------------------------

.. code-include:: ../scripts/eval_train_wheelset_rhs.m
   :lexer: matlab

Defining the Output Function
----------------------------

.. code-include:: ../scripts/eval_train_wheelset_outputs.m
   :lexer: matlab

Solving the Integration of ODEs
-------------------------------

.. code-include:: ../scripts/simulate_train_wheelset.m
   :lexer: matlab

Assessment Rubric
=================

.. list-table:: Score will be between 50 and 100.
   :class: table table-striped table-bordered
   :header-rows: 1

   * - Topic
     - [10 pts] Exceeds expectations
     - [5 pts] Needs improvement
     - [0 pts] Does not meet expectations
   * - Functions
     - Both functions (1 state derivative & 1 output) are present and take
       correct inputs and produce the expected outputs.
     - One or two functions are present and mostly take correct inputs and
       produce the expected outputs
     - No functions are present or not working at all.
   * - Main Script
     - Constant parameters only defined once in main script(s);
       Integration produces the correct state, input, and output trajectories;
       Good choices in number of time steps and resolution are chosen and
       justified.
     - Parameters are defined in multiple places; Integration produces some
       correct state, input, and output trajectories; Poor choices in number of
       time steps and resolution are chosen
     - Constants defined redundantly; Integration produces incorrect
       trajectories; Poor choices in time duration and steps
   * - Explanations
     - Explanation of two simulation comparisons are correct and well
       explained; Plots of appropriate variables are used in the explanations
     - Explanation of two simulation comparisons is somewhat correct and
       reasonably explained; Plots of appropriate variables are used in the
       explanations, but some are missing
     - Explanation of two simulations are incorrect and poorly explained; Plots
       are missing
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
