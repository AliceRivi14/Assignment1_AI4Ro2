# Assignment1_AI4Ro2

In a warehouse, there are two robots that move crates around. The crates are to be loaded on the conveyor belt by an additional robot. The idea is that when the warehouse receives new orders, the corresponding crates to be moved are communicated to the robots, that take them to a loading bay where a dedicated robot can put them on the conveyor belt. Usually, one robot is enough to move light crates in the warehouse. However, in the presence of heavy (>50kg) crates, two robots are required.

## Goal

In the warehouse, there are three robots: one loader and two movers. The loader is in charge of loading crates on the conveyor belt. It cannot move, as it is basically only a robotic arm.
The mover robots are in charge of moving crates from their initial position in the warehouse to the loading bay, so that they can then be loaded on the conveyor belt by the loader.

The goal of the assignment is to move the movers from the loading bay to the position of the crates, load the crates and transport them to the loading bay where they are loaded on the conveyor belt.

The weight and initial position of each crate are of course known. The position of a crate is only given in terms of its distance from the loading bay. 
Light crates, which weigh less than 50kg, can be moved around by a single mover robot, while heavy crates, which weigh more than 50kg, need 2 mover robots.

The time needed to move a crate around depends on its weight and can be calculated as: `distance * weight / 100`; moreover, when moving around with no crates, mover robots cover 10 distance units per time unit.

It takes the loader robot 4 time units to load a crate on the conveyor belt, and it can load a single crate at a time. The loading bay must be kept free while the loader is in the process of loading a crate on the belt.

The code is organised in four problem and a general domain, which also considers the four optional extensions.

## Installing and running

The planner ENHSP reads in input a PDDL domain and problem file and it provides with a plan. 
In the case of planning with processes, the plan is a time-stamped plan.

The ENHSP Planning transforms the PDDL descriptions into a graph-search problem where nodes represent states visited by the planner.
To download the planner, you need to go to the following link https://sites.google.com/view/enhsp/ .

Before compiling make sure to have the Java machine installed on your computer (in particular it works with Java 15).
Choosing "binary", you'll just have to download the .zip file; instead choosing "source" you'll have to execute the following commands from the bash:

`sudo apt-get install openjdk-15`

To compile the software just go to the root folder and run `./compile`, and this will generate a big JAR file in the enhsp-dist folder.

The planner can be executed from the root folder using the following command:

`java -jar /enhsp-dist/enhsp.jar -o /<domain_file> -f /<problem_file>`

where domain_file and problem_file are the PDDL input files.

Should you wish to use a configuration other than the standard planner configuration, simply add it in the command line of the terminal as follows:

`java -jar /enhsp-dist/enhsp.jar -o /<domain_file> -f /<problem_file> -planner <configuration>`

## PDDL+

PDDL+ introduced processes and events, to the domain of PDDL. PDDL+ is the first to consider essentially actions which must be applied when their preconditions are met.

Processes directly correspond to a durative action and last for as long as their pre-condition is met. A process is something like gravity’s effect on a ball, increases the velocity of the ball until it either reaches terminal velocity or indeed, it hits the ground

Events directly correspond to instantaneous actions, and happen the instant their preconditions are met, usually with the effect of transforming their state such that their precondition is no longer met. Events are uncontrollable, and in the ball example, you might consider an event to be the ball hitting the ground. In that instance, the velocity of the ball is negated, and multiply by some bounce coefficient.

Processes and events are still very much a challenge for some planners, and support is somewhat patch, with certain planners losing support for earlier features in PDDL in order to support this new feature.
  
## Domain
  
The code is structured in a sequence of actions, processes and events.
Planning is about deciding which actions the user should perform by anticipating the effects of actions before they are executed.
In particular:

•	Action changes the world state in some way.

•	Processes execute continuously under the direction of the world: the world decides whether a process is active or not. 

•	Events are the world’s version of actions: the world performs them when conditions are met.
  
### Explanation of the code - domain.pddl ###
  
In the first part, predicates and functions are defined, then each movement is presented.
  
•	action m-move_to_crate 

  process m-moving_to_crate

  event m-at_crates: 

through these fluents the first movement of the movers is described. From the loading bay the mover moves to the selected crate. The time taken by the process and the amount of battery consumption depends on the crate distance. At the end of this movement, the distance between the crate and the mover will be zero.
The same sequence is also repeated for crates belonging to group A and B.

•	action m-load:

this action describes the loading movement of the crate on the mover. If the crate is light it is loaded on a single mover, if it is heavy or fragile, two movers are loaded. 
The same action is also repeated for crates heavy, light or fragile belonging to group A and group B.

•	action m-move_crate_to_loading_bay

  process m-moving_crate_to_loading

  event crate_at_loading_bay:

these fluents describe the transport of the loaded crates on the mover from the crate position to the loading bay. If the crate is fragile or heavy, two movers are considered to return to their initial position carrying the crate. The time taken by the process and the amount of battery consumption depends on the crate distance. At the end of this movement, the distance between the crate and the loading bay will be zero.
The same sequence is also repeated for crates belonging to group A and B.

•	action m-download:

this action describes the downloading movement of the crate from the mover to the ground. If the crate is light, only one mover is downloaded, if it is heavy or fragile, two movers are downloaded.

•	action l-load

  process l-loading

  event crate_on_conveyot_belt:

these fluents describe the loading of the crates onto the conveyor belt by the loader. If the first loader is used, there is no distinction based on the type of crates, if the second, less powerful loader is used, it must be considered that it can only load light crates (weight<50kg). If the crate is fragile, the loading time will be longer for both loaders.

•	action m-charging:

this action represents the loading of the mover. Whenever free movers consume a certain amount of battery power, they return to the loading bay to recharge and be able to restart.

## Problem

The code shows 4 types of problems:

•	Problem 1: 3 crates

  Crate 1: weight 70kg, 10 distance from loading bay

  Crate 2: fragile, weight 20kg, 20 distance from loading bay, in group A

  Crate 3: weight 20kg, 20 distance from loading bay, in group A

•	Problem 2: 4 crates

  Crate 1: weight 70kg, 10 distance from loading bay, in group A

  Crate 2: fragile, weight 80kg, 20 distance from loading bay, in group A

  Crate 3: weight 20kg, 20 distance from loading bay, in group B

  Crate 4: weight 30kg, 10 distance from loading bay, in group B

•	Problem 3: 4 crates

  Crate 1: weight 70kg, 20 distance from loading bay, in group A

  Crate 2: fragile, weight 80kg, 20 distance from loading bay, in group A

  Crate 3: weight 60kg, 30 distance from loading bay, in group A

  Crate 4: weight 30kg, 10 distance from loading bay

•	Problem 4: 6 crates

  Crate 1: weight 30kg, 20 distance from loading bay, in group A

  Crate 2: fragile, weight 20kg, 20 distance from loading bay, in group A

  Crate 3: fragile, weight 30kg, 10 distance from loading bay, in group B

  Crate 4: fragile, weight 20kg, 20 distance from loading bay, in group B

  Crate 5: fragile, weight 30kg, 30 distance from loading bay, in group B

  Crate 6: weight 20kg, 10 distance from loading bay

### Explanation of the code - problem.pddl ###

In these four codes, the objects are presented at the beginning, then the initial conditions of each problem are described and finally the goals are defined.
Extensions

There are a few optional ways in which the model can be extended:

•	Some crates go together: some crates, characterized by the same letter, need to be loaded subsequently on the conveyor belt to help the delivery guy.

•	There are 2 loaders: the second loader uses the same loading by as the other one, and can used while other one is loading, but it is not capable of loading heavy crates (with weight >50kg).

•	More robots need recharging: mover robots have a limited battery capacity of 20 power units, so they need to be recharged in the recharging station, that is positioned at the loading bay.
  A robot consumes a power unit for each time unit in which it is actively doing something (moving around or moving crates).

•	This is fragile:  some crates are “fragile”, so they always need 2 movers to be taken to the loading bay, and the loader robot works at reduced speed to avoid any potential damage. This means that loading a fragile crate on the conveyor belt takes 6 time units instead of the usual 4

## Planning engine
  
In order to check how best to optimise planning, we compared different planner configurations. In particular, we compared the standard configuration with the optimal-hrmax configuration and the optimal-blind configuration.

The opt-hrmax configuration should be used for optimal simple numeric planning problem, and it works same as opt-max configuration, but with redundant constraints. The opt-hrmax configuration is based on A* algorithm with numeric heuristic.

The opt-blind is a baseline blind heuristic that gives 1 to state where the goal is not satisfied and 0 to state where the goal is satisfied. This can work very well when the structure of the problem is very complex and plans not very long (such as ~20 actions top).

In all 4 problems the 2 optimal configurations are both better than the standard one. We can see that both take less time to reach the goal, once the best plan is found.
  
• Problem 1:

  The opt-hmax configuration has a longer planning, heuristic and search time, but it expands a lower number of nodes and evaluates a lower number of states comparing to the opt-blind configuration.
  The plan-length, the duration and metric (search) are the same for both configurations. The number of dead ends is 0 in the opt-blind configuration and 1198 in the opt-hmax, but the number of duplicates is far lower in the former (1 order of magnitude).
  
• Problem 2:

  In this case the plan lengths are very slightly different (1 unit) because the opt-blind configuration plan starts from the charging of m1, despite both movers are charge at the beginning.
  The opt-hmax configuration has a shorter planning and search time, but a longer heuristic time, and it expands a lower number of nodes and evaluates a lower number of states (1 order of magnitude) comparing to the opt-blind configuration.
  The plan-length and metric (search) are the same for both configurations. The number of dead ends is 0 in the opt-blind configuration and 194 in the opt-hmax, but the number of duplicates is far lower in the former (1 order of magnitude).
  
• Problem 3:

  Also in this problem the plan lengths are very slightly different (1 unit) because the opt-blind configuration plan starts from the charging of m1, despite both movers are charge at the beginning.
  The opt-hmax configuration has a longer planning and search time and a longer heuristic time, but it expands a lower number of nodes (1 order of magnitude) and evaluates a lower number of states (only double) comparing to the opt-blind configuration.
  The plan-length and metric (search) are almost the same for both configurations. The number of dead ends is 0 in the opt-blind configuration and 1484 in the opt-hmax, but the number of duplicates is far lower in the former (1 order of magnitude).
  
• Problem 4:

  The opt-hmax configuration has a longer planning, heuristic and search time (3 orders of magnitude), but it expands a lower number of nodes and evaluates a lower number of states (same order of magnitude) comparing to the opt-blind configuration.
  The plan-length and metric (search) are the same for both configurations. The number of dead ends is 0 in the opt-blind configuration and 462944 in the opt-hmax, but the number of duplicates is far lower in the former.
  All these solutions can be further explored by analysing the documents in the output folder.

## Note
  
Each mover consumes one unit of battery power each time it performs a movement, i.e. when heading towards the crates and during the return to the loading bay by transporting the crate. The time taken by the movers in these movements depends on the distance the crate is from the loading bay. In particular, the movement back to the loading bay with the crate is a function of the weight of the crate.

In Problem 3, the third crate is at a distance of 30 and weighs 60kg. Doing the calculations, 21 units of time and 21 units of power are consumed to transport the crate to the loading bay. Since no conditions have been placed on the minimum battery value of the mover, the planner does not have a problem if this falls under zero, so to perform the charging action it only cares that the mover is free, at the loading bay and discharges a certain amount.

This cannot happen in reality, so the conditions under which the mover must recharge must be modified. One solution would be to add fluents that take into account that the mover's battery level cannot be less than a certain amount. That way, when the movers realise they do not have enough battery to complete a movement, they stop, discharge the crate if necessary, and head to the loading bay to recharge.
In this way, in the case of Problem 3, while transporting crate 3 to the loading bay, the movers should stop and unload the load when the battery level is at least at 1, so the last unit of battery is consumed to reach the loading bay where they recharge. Once recharged, both movers head to where they left the crate 3, recharge it and carry it to the loading bay.

This part of the code was not included in our domain because the planner encounters problems, especially when solving Problem 4, probably due to the poor processor performance of the machine used.
