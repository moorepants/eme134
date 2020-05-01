:title: Lab 3: Automobile Steering
:status: hidden
:slug: lab-03

.. contents::

Learning Objectives
===================

After completing this lab you will be able to:

- formulate the explicit first order ordinary differential equations for the
  lateral dynamics of an automobile
- translate ordinary differential equations into a computer function that
  evaluates the equations at any given point in time
- develop a function that evaluates state dependent input functions
- develop a function that evaluates state and input dependent output variables
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

In this lab, you will investigate the planar dynamics of a car being steered
through a lane change maneuver. The ability for the car to maneuver as expected
given a steering input depends on the car's ability to generate and direct the
lateral forces at the front and rear wheels. At a basic level the car designer
can manipulate the car's geometry, weight distribution, tire type to control
the base dynamics of the vehicle. The designer can then design and tune other
aspects in the suspension system to obtain even better performance. You will
investigate the dynamics without suspension considerations to get an
understanding of the car's basic motion and performance in a lane change.

The following video gives an introduction to rear wheel steering that can
provide some background to one of the simulations you will do:

.. raw:: html

   <iframe width="560" height="315"
   src="https://www.youtube.com/embed/0jXnHeH9GNg" frameborder="0"
   allow="accelerometer; autoplay; encrypted-media; gyroscope;
   picture-in-picture" allowfullscreen></iframe>

System Description
==================

You will model and simulate a car traveling on a planar surface. The car will
be able to steer both the front wheels and rear wheels relative to the chassis.
The normal force is assumed to be equal on all of the wheels, i.e.  no load
significant transfer from cornering. The tires will be assumed to be pure
rolling and the vehicle's forward velocity is constant. The lateral forces at
the wheels will be modeled using the linear relation to slip angle and thus the
model is only valid for small yaw and slip angles. You will investigate the
effects on vehicle behavior when it is setup as an understeering and
oversteering car. This model is called the "bicycle model of the car". The
derivation of the model and analysis are presented in Chapter 6 of the book.

.. figure:: https://objects-us-east-1.dream.io/eme134/2020s/lab-03-fig-01.png
   :width: 600px
   :align: center

   **Figure 1**: Schematics of the lateral car dynamics model.

Equations of Motion
-------------------

The equations of motion for the bicycle model of the car are presented below in
the canonical linear form. The factor of 2 accounts for the combined affect of
the pairs of tires at the front and rear, i.e. :math:`C_f` and :math:`C_r` are
the cornering coefficients of the individual front and rear tires,
respectively.

.. math::

   \begin{bmatrix}
     m & 0 \\
     0 & I
   \end{bmatrix}
   \begin{bmatrix}
     \dot{v} \\
     \dot{\omega}
   \end{bmatrix}
   +
   \begin{bmatrix}
     2(C_f + C_r)/U & 2(aC_f-bC_r)/U \\
     2(aC_f-bC_r)/U & 2(a^2C_f+b^2C_r)/U
   \end{bmatrix}
   \begin{bmatrix}
     v \\
     \omega
   \end{bmatrix}
   +
   \begin{bmatrix}
     0 & -2(C_f+C_r) \\
     0 & -2(aC_f-bC_r)
   \end{bmatrix}
   \begin{bmatrix}
     y \\
     \psi
   \end{bmatrix}
   =
   \begin{bmatrix}
     2C_f & 2C_r \\
     2C_f a & -2C_r b
   \end{bmatrix}
   \begin{bmatrix}
     \delta_f \\
     \delta_r
   \end{bmatrix}

These equations define expressions for the derivatives of the four time varying
state variables :math:`y,v,\psi,\omega` and the two time varying input
variables :math:`\delta_f,\delta_r` which are described below.

.. list-table::
   :class: table table-striped table-bordered
   :header-rows: 1

   * - Symbol
     - Description
     - Units
   * - :math:`y`
     - Lateral deviation of the car's mass center
     - :math:`\textrm{m}`
   * - :math:`\psi`
     - Yaw angle of the car
     - :math:`\textrm{rad}`
   * - :math:`v=\dot{y}`
     - Lateral velocity of the car's mass center
     - :math:`\textrm{m/s}`
   * - :math:`\omega=\dot{\psi}`
     - Yaw angular rate of the car
     - :math:`\textrm{rad/s}`
   * - :math:`\delta_f`
     - Steer angle of the front wheels
     - :math:`\textrm{rad}`
   * - :math:`\delta_r`
     - Steer angle of the rear wheels
     - :math:`\textrm{rad}`

You will need to write these equations of motion as four explicit ordinary
differential equations in first order form for your state derivative function.
You will use the section `Defining the State Derivative Function
<https://moorepants.github.io/eme171/ode-integration-best-practices-with-octavematlab.html#defining-the-state-derivative-function>`_
for these equations.

Inputs
------

The front :math:`\delta_f` and rear :math:`\delta_r` steering angles can be set
to desired functions of time in your input function. You will setup two input
functions that will steer the automobile through a lane change using for these
scenarios:

Only front steering
   Create a function that steers the front wheels to :math:`\delta` degrees for
   :math:`2\leq t \leq 4` and then :math:`-\delta` for :math:`6\leq t \leq 8`
   seconds where :math:`\delta` is the magnitude of the steering pulse.
Front and rear steering
   Create a function that steers the front wheels to :math:`\delta` degrees for
   :math:`2\leq t \leq 4` and then :math:`-\delta` for :math:`6\leq t \leq 8`
   seconds and simultaneously steers the rear wheels in the opposite direct the
   same amounts.

See `Time Varying Inputs
<https://moorepants.github.io/eme171/ode-integration-best-practices-with-octavematlab.html#time-varying-inputs>`_
for more information.

Outputs
-------

The output function should return all of the state variables, the two steering
angle inputs, the combined lateral force at the front and rear tires, the
travel distance in the :math:`x` direction, and the lateral acceleration. The
lateral forces at the combined tires can be calculated with:

.. math::

   F_{yf} = & 2C_f \alpha_f \\
   \alpha_f = & \frac{v + a\omega}{U} - \psi - \delta_f \\
   F_{yr} = & 2C_r \alpha_r \\
   \alpha_r = & \frac{v - b\omega}{U} - \psi - \delta_r

Your state derivative function can calculate the lateral acceleration. You will
use the section `Outputs Other Than The States
<https://moorepants.github.io/eme171/ode-integration-best-practices-with-octavematlab.html#outputs-other-than-the-states>`_
to compute these values.

Constant Parameters
-------------------

The majority of the variables in the differential equations and input equations
above do not vary with time, i.e. they are constant. Below is a table with an
explanation of each variable, its value, and its units. Note that the units are
a self consistent set of SI base units.

.. list-table::
   :class: table table-striped table-bordered
   :header-rows: 1

   * - Symbol
     - Description
     - Value
     - Units
   * - :math:`U`
     - Forward speed
     - :math:`10,20,30`
     - :math:`m/s`
   * - :math:`\delta`
     - Magnitude of the steer angle
     - 1
     - :math:`\textrm{deg}`
   * - :math:`I`
     - Car yaw moment of inertia (assumes inertia of a rectangle)
     - :math:`\frac{m}{12}(w^2+l^2)`
     - :math:`\textrm{kg}\cdot\textrm{m}^2`
   * - :math:`d\mu_y/d\alpha`
     - Slope of friction vs slip angle curve at :math:`\alpha=0`
     - 7.0
     - Unitless
   * - :math:`g`
     - Acceleration due to gravity
     - 9.81
     - :math:`\textrm{m/s}^2`
   * - :math:`m`
     - Mass of the car
     - 1200
     - :math:`\textrm{kg}`
   * - :math:`w`
     - Track
     - 1.54
     - :math:`\textrm{m}`
   * - :math:`l`
     - Wheelbase
     - 2.7
     - :math:`\textrm{m}`
   * - :math:`r`
     - Ratio of :math:`a/l`
     - :math:`0<r<1`
     - :math:`\textrm{unitless}`
   * - :math:`a`
     - Distance from mass center to front axle
     - :math:`rl`
     - :math:`\textrm{m}`
   * - :math:`b`
     - Distance from mass center to rear axle
     - :math:`(1-r)l`
     - :math:`\textrm{m}`
   * - :math:`F_{zf}`
     - Total normal force at the front wheels
     - :math:`F_z/2`
     - :math:`\textrm{N}`
   * - :math:`F_{zr}`
     - Total normal force at the rear wheels
     - :math:`F_z/2`
     - :math:`\textrm{N}`

You will use the section `Integrating the Equations
<https://moorepants.github.io/eme171/ode-integration-best-practices-with-octavematlab.html#integrating-the-equations>`_
to for these values.

Initial Conditions
==================

The initial condition will be the equilibrium state of the vehicle, i.e. all
initial conditions equal to zero. See `Integrating the Equations
<https://moorepants.github.io/eme171/ode-integration-best-practices-with-octavematlab.html#integrating-the-equations>`_
for how to set up the initial condition vector. Make sure that your initial
conditions are arranged in the same order as your state variables.

Time Steps
==========

Simulate the system for 10 seconds with time steps of 1/100th of a second.

Understeer, Oversteer, and Neutralsteer
=======================================

An automobile can be classified as oversteer, understeer, or neutralsteer based
on relationship between lateral force generation at the front and rear for the
vehicle. The so called understeer coefficient :math:`K` determines whether a
given car is one of the three:

.. math::

   K = \frac{m(bC_r-aC_f)}{(a+b)C_fC_r}

If :math:`K > 0` the car is an understeer; if :math:`K < 0` the car is
oversteer; and if :math:`K=0` the car is neutral steer. Note that these
characterizations only depend on :math:`m,a,b,C_f,C_r`. You will need to
indicate the values of :math:`K` that you calculate for each scenario and
specify if the car is over, under, or neutral.

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
   requested inputs: front steer and dual steer. See `Time Varying Inputs`_ for
   an explanation.
3. Create a function defined in an m-file that calculates the requested
   outputs. See `Outputs Other Than the States`_  and `Outputs Involving State
   Derivatives`_ for an explanation.
4. Create a script in an m-file that utilizes the above functions to
   simulate system for three comparison scenarios described below.  This should
   setup the constants, integrate the dynamics equations, and plot each state,
   and output versus time. See `Integrating the Equations`_ for an explanation.
5. Compare the lane change steering behavior with :math:`\delta=1` deg of the
   car for an understeer and oversteer configuration at speeds :math:`U=10` m/s
   using only front steering. Select a value of :math:`r`
   to obtain a suitable :math:`K` for each vehicle. Describe the differences in
   the state and output trajectories. Comment on why the terms "understeer" and
   "oversteer" are used to describe the configurations.
6. Repeat #5 with :math:`U=30` m/s.
7. Compare the lane change steering behavior with :math:`\delta=1` deg of an
   understeer car traveling at :math:`U=20` m/s for the front steering vs the
   dual front-rear steering. Describe the differences in the state and output
   trajectories. Comment on whether a dual steering has an any advantages or
   disadvantages based on the simulation results.

.. _Outputs Involving State Derivatives: https://moorepants.github.io/eme171/ode-integration-best-practices-with-octavematlab.html#outputs-involving-state-derivatives

Tips
====

- When plotting the path of the mass center :math:`y(x)` use the
  ``axis('image')`` command to set the aspect ratio.

Assessment Rubric
=================

.. list-table:: Score will be between 50 and 100.
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
       justified.
     - Parameters are defined in multiple places; Integration produces some
       correct state, input, and output trajectories; Poor choices in number of
       time steps and resolution are chosen
     - Constants defined redundantly; Integration produces incorrect
       trajectories; Poor choices in time duration and steps
   * - Explanations
     - Explanation of three simulation comparisons are correct and well
       explained; Plots of appropriate variables are used in the explanations
     - Explanation of three simulation comparisons is somewhat correct and
       reasonably explained; Plots of appropriate variables are used in the
       explanations, but some are missing
     - Explanation of three simulations are incorrect and poorly explained; Plots
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
   * - Contributions
     - Clear that all team members have made equitable contributions.
     - Not clear that contributions were equitable and you need to improve
       balance of contributions.
     - No indication of equitable contributions.
