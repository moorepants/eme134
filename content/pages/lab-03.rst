:title: Lab 3: Automobile Steering
:status: hidden
:slug: lab-03

.. topic:: Warnings
   :class: alert alert-warning

   Lab description is still a draft! It will be finalized by Monday April 27th.

.. contents::

Learning Objectives
===================

After completing this lab you will be able to:

- formulate the explicit first order ordinary differential equations for the
  longitudinal dynamics of a drag racing car
- translate ordinary differential equations into a computer function that
  evaluates the equations at any given point in time
- develop a function that evaluates state dependent input functions
- numerically integrate ordinary differential equations with Octave/Matlab's
  ode45_
- implement and tune a longitudinal traction control system
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

In this lab, you will investigate the planar dynamics of a car being steered.

System Description
==================

Here we will model and simulate a car traveling on a planar surface. The car
will be able to steer the front wheels and rear wheels relative to the chassis
and the normal force is assumed to be equal on the left and right wheels, i.e.
no load significant transfer from cornering. The tires will be assumed to be
pure rolling and the vehicles forward velocity constant. The lateral forces at
the wheels will be modeled using the linear relation to slip angle. You will
investigate the effects on vehicle behavior under steering when the vehicle is
considered under-, over-, and neutral-steer.

..
   .. figure:: https://objects-us-east-1.dream.io/eme134/2020s/lab-02-fig-01.png
      :width: 400px
      :align: center

      **Figure 1**: Schematics of the longitudinal car dynamics model.

Equations of Motion
-------------------

The equations of motion for the bicycle model of the car are presented below in
the canonical linear form:

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
     C_f & C_r \\
     C_f a & -C_r b
   \end{bmatrix}
   \begin{bmatrix}
     \delta_f \\
     \delta_r
   \end{bmatrix}

These equations define expressions for the derivatives of the four time varying
state variables :math:`y,v,\psi,\omega` which are described below.

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

You will need to write these equations of motion as four explicit ordinary
differential equations in first order form for your state derivative function.
You will use the section `Defining the State Derivative Function
<https://moorepants.github.io/eme171/ode-integration-best-practices-with-octavematlab.html#defining-the-state-derivative-function>`_
for these equations.

Inputs
------

The front :math:`\delta_f` and rear :math:`\delta_r` steering angles can be set
desired functions of time in your input function. You will setup input
functions that will steer the automobile through a lane change.

Only front steering
   Create a function that steers the front wheels to :math:`\beta` degrees for
   :math:`2\leq t \leq 4` and then :math:`-\beta` for :math:`6\leq t \leq 8`
   seconds.
Front and rear steering
   Create a function that steers the front wheels to :math:`\beta` degrees for
   :math:`2\leq t \leq 4` and then :math:`-\beta` for :math:`6\leq t \leq 8`
   seconds and simultaneously steers the rear wheels in the opposite direct the
   same amounts.

See `Time Varying Inputs
<https://moorepants.github.io/eme171/ode-integration-best-practices-with-octavematlab.html#time-varying-inputs>`_
for more information.

Outputs
-------

The output function should return all of the state variables, the two steering
angle inputs, the lateral forces at the front and rear tires, the travel
distance in the :math:`x` direction, and the lateral acceleration. You will use
the section `Outputs Other Than The States
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
     - :math:`0 < U < 50`
     - :math:`m/s`
   * - :math:`I`
     - Car yaw moment of inertia
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
     - Ratio of :math:`a/b`
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
     - :math:`rmg/2`
     - :math:`\textrm{N}`
   * - :math:`F_{zr}`
     - Total normal force at the rear wheels
     - :math:`(1-r)mg/2`
     - :math:`\textrm{N}`
   * - :math:`\beta`
     - Steer angle magnitude
     - Varies
     - :math:`\textrm{rad}`

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

An automobile can be classified as oversteer, understeer, or neutrally steer
based on relationship between lateral force generation at the front and rear
for the vehicle. The so called understeer coefficient :math:`K` determines
whether a given car is one of the three:

.. math::

   K = \frac{m(bC_r-aC_f)}{(a+b)C_fC_r}

If :math:`K > 0` the car is an understeer; if :math:`K < 0` the car is
oversteer; and if :math:`K=0` the car is neutral steer. Note that these
characterizations only depend on :math:`m,a,b,C_f,C_r`.

Deliverables
============

Compare the lane change steering behavior of the car for understeer, oversteer,
and neutralsteer configurations at speeds :math:`U=5,10,15` m/s.

Compare the lane change steering behavior of an understeer car traveling at
:math:`U=10` m/s for the only front steering and simultaneous front and rear
steering.

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
   requested inputs. See `Time Varying Inputs`_ for an explanation.
3. Create a function defined in an m-file that calculates the requested
   outputs. See `Outputs Other Than the States`_ for an explanation.
4. Create a script in an m-file that utilizes the above functions to
   simulate system for the two scenarios: with and without traction control.
   This should setup the constants, integrate the dynamics equations, and plot
   each state, and output versus time. See `Integrating the Equations`_ for an
   explanation.
5. Make a plot of the coefficients of friction versus slip ratio which includes
   the curves for the dry and icy conditions. Indicate what slip ratios were
   chosen for the peak traction.
6. Make plots of the outputs versus time of the scenario without traction
   control and explain why you think the simulation is behaving realistically
   or unrealistically.
7. Make plots to compare outputs versus time between the two scenarios: with
   and without traction control. Plotting the each trajectory on its own or in
   subplots with one color line for each scenario.
8. Report the time to the 200 m mark for each scenario and discuss the results
   and explain why the vehicle that wins won. Report the input energy consumed
   at the 200 m mark and discuss the differences in energy consumption, why it
   is, and what the implications are. You can present the joules of energy in
   equivalent liters of gasoline to help get a idea of the quantity.

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
   * - Contributions
     - Clear that all team members have made equitable contributions.
     - Not clear that contributions were equitable and you need to improve
       balance of contributions.
     - No indication of equitable contributions.
