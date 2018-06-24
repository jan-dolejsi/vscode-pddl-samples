# PDDL samples demonstrating features of the VS Code PDDL Extension

Planning Domain Definition Language [PDDL](https://en.wikipedia.org/wiki/Planning_Domain_Definition_Language) samples demonstrating VS Code PDDL extension features.

## Getting started

1. Install [Visual Studio Code](https://code.visualstudio.com/download) the free and light-weight editor for developers
1. Install the [PDDL Extension](https://marketplace.visualstudio.com/items?itemName=jan-dolejsi.pddl)
1. Clone this repository and open the folder in Visual Studio Code
1. Open the Test Explorer (View > Open View ... > Test)
1. Unfold the folders in the Test Explorer and run the samples by right-clicking on them...

## Samples

### Airport

This is a sample showing airport ground operations planning. It has an intentional bug. Can you find it?

Run the _1plane_ problem. The test case shows as failed. Export the plan to `1plane.pddl`, save the file to disk. Select both `1plane.pddl` and `1plane-expected.pddl` in the _File Explorer_ and select _Compare selected_. See the difference? The aircraft is not getting re-fueled.

Now go back to the plan visualization and click on the action that is missing a pre-condition. If you select a correct one, you will see a hint.

Fix the bug and re-run the test case - it should pass now.

### Trucking

This domain is interesting, because it generates a small search space and the planner does not run out of available memory even when you ask it to search for a more optimal plan (e.g. by using the `-n` flag in `popf`). 

Open the PDDL files of one of the test case and pres `Alt + P`. When prompted, select _specific options..._ and then type `-n` as the command-line option (or equivalent in your planner).

The plan visualization shows multiple plans and you can select the plan you want (the bar visualizes plan metric of the plan) and compare them easily.

### Blocksworld

This classic planning benchmark domain is plemented here using the problme templating approach. See the `.ptest.json` file for definition of the generated test cases. Each test case i generated from a `.json` file defining the initial and goal state.
This demonstrates a regression test suite.

### Driver log

This domain demonstrates the problem file templating and a programatic generation of scalability test suite.

Run the `generate_tests.py` script and refresh the _Test Explorer_. You will see a list of _Scalability tests_ for your planner. Run the suite to see how your planner struggles (or not :-]). See how the _.json_ files are concise to capture the test cases. Check the logic in the _problem.pddl_ template. 