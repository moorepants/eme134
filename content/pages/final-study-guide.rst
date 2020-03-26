:title: Final Study Guide
:sortorder: 3
:status: hidden

Chapter by Chapter Big Picture Ideas
====================================

1. Introduction: Elementary Vehicles

   1. Stability of tapered wheelset
   2. Stability of shopping cart
   3. Physical parameters affect stability and motion (period, damping, etc)

2. Rigid Body Motion

   1. Why are body fixed coordinate systems are useful for vehicle equations of motion?
   2. What is the standard notation for body fixed coordinates?
   3. What do Newton and Euler’s equations look like in body fixed notation for 3D rigid body?
   4. What do the Newton/Euler body fixed equations reduce to for planar motion and simplified inertia.

3. Stability of Motion

   1. What is the difference between static stability and dynamic stability?
   2. What is the general solution to a set of coupled ordinary linear differential equations?
   3. What are the eigenvalues and how to they govern the motion of linear systems?
   4. Routh’s stability criterion allows you to determine dynamic stability/instability without finding eigenvalues. How do you apply it?

4. Pneumatic Tires

   1. What is the difference in slip and slide/skid for a tire?
   2. What does no-slip mean?
   3. What is the characteristic non-linear relationship between lateral force generation and slip angle?
   4. What is a lateral cornering coefficient?
   5. How does accelerating and braking affect lateral force generation?

5. Stability of Trailers

   1. How complex of a model do you need to explain observable phenomena? For trailer: 1 Dof? 2 Dof? 3 Dof?
   2. Calculation of slip angles.
   3. What are Lagrange’s equations and how do you formulate them?
   4. Analyzing a model’s characteristic equation for stability?
   5. What is a critical speed? How do you find it?

6. Automobiles

   1. Body fixed vs inertial coordinates: why does body fixed give you a reduced (in complexity) model?
   2. What is a transfer function and what does it tell us? Look at steady state (s=0) or step response (S goes to infinity). What are steady state gains?
   3. What do right half plane zeros cause?
   4. What does under, over, and neutral steer mean? What are consequences for cars that are over, under, or neutral?
   5. What does over, under, neutral mean for steady turning?

7. Two-wheel and Tilting Vehicles

   1. Derivation of 3D model: how to handle velocity and angular velocity vectors.
   2. What is a proportional controller?
   3. How to create a closed loop transfer function and analyze for stability.
   4. Facts from videos:

      1. Is a bicycle stable? What causes stability/instability? What is essential for stability?
      2. What is countersteering?
      3. What is the difference in the bicycle model of the car and the bicycle model?

8. NA

9. Aerodynamics and the Stability of Aircraft

   1. How do forces and moments act on an airfoil with change in angle of attack?
   2. What is the aerodynamic center? What is the moment about the aerodynamic center?
   3. How to determine the trim state of an aircraft?
   4. How to determine if an aircraft is statically stable?
   5. Calculating the phugoid period.

Learning Objectives
===================

After completing the course students will be able to:

create simple mathematical models of a variety of vehicles
   * able to draw a free body diagram
   * abe to utilize body fixed coordinate systems
   * able to general 3D EoMs for single rigid body
   * able to draw a velocity diagram
   * able to determine important velocities
   * able to determine important inertia terms
   * able to formulate equations of motion with the Newton-Euler method
   * able to formulate equations of motion with the Lagrange method
   * able to write equations of motion in transfer function form
   * able to identify type of linear ODE: m/k, m/c/k, overdamped/underdamped/critically damped
identify when vehicles are stable/unstable
   * able to write the characteristic equation for a dynamic system
   * able to apply Routh’s criteria to determine if a system is stable or unstable
   * able to calculate the eigenvalues of a dynamic system
   * able to determine vehicle critical speeds
   * able to identify parameters that affect stability
   * able to simplify and assess the linear equations of motion for important parameters
   * able to draw and interpret a root locus
understand typical modes of motion for various vehicles
   * tire force behavior
   * able to interpret tire force data
   * able to calculate the lateral slip angle
   * able to interpret and explain under/over/neutral-steer in an automobile straight running
   * able to interpret and explain under/over/neutral-steer in an automobile cornering
   * able to balance forces with respect to airfoil angle of attack, trim, and aerodynamic center
   * able to differentiate between static and dynamic stability of an aircraft
   * able to utilize lift, drag, and moment coefficients in an aircraft static force balance
apply simple automatic control to stabilize vehicles
   * formulate a closed loop transfer function
   * evaluate proportional control stability
