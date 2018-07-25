# PDDL samples demonstrating features of the VS Code PDDL Extension

Planning Domain Definition Language [PDDL](https://en.wikipedia.org/wiki/Planning_Domain_Definition_Language) samples demonstrating VS Code PDDL extension features.

## Getting started

1. Install [Visual Studio Code](https://code.visualstudio.com/download) the free and light-weight editor for developers
1. Install the [PDDL Extension](https://marketplace.visualstudio.com/items?itemName=jan-dolejsi.pddl)
1. Clone this repository and open the folder in Visual Studio Code
1. Open the Test Explorer (View > Open View ... > Test)
1. Unfold the folders in the Test Explorer and run the samples by right-clicking on them...

## Samples

### GettingStarted

Start from empty files by using the domain and problem snippets.

### Airport

This is a sample showing airport ground operations planning. It has an intentional bug. Can you find it?

Run the _1plane_ problem. The test case shows as failed. Export the plan to `1plane.pddl`, save the file to disk. Select both `1plane.pddl` and `1plane-expected.pddl` in the _File Explorer_ and select _Compare selected_. See the difference? The aircraft is not getting re-fueled.

Now go back to the plan visualization and click on the action that is missing a pre-condition. If you select a correct one, you will see a hint.

Fix the bug and re-run the test case - it should pass now.

Export the plan to a `.plan` file keeping the proposed default name. Run Tasks > Run task... > validate (with report) and observe that a `.tex` file got created. Install [LaTeX Preview](https://marketplace.visualstudio.com/items?itemName=ajshort.latex-preview) extension to open the preview.

### Trucking

This domain is interesting, because it generates a small search space and the planner does not run out of available memory even when you ask it to search for a more optimal plan (e.g. by using the `-n` flag in `popf`).

Open the PDDL files of one of the test case and pres `Alt + P`. When prompted, select _specific options..._ and then type `-n` as the command-line option (or equivalent in your planner).

The plan visualization shows multiple plans and you can select the plan you want (the bar visualizes plan metric of the plan) and compare them easily.

### Blocksworld

This classic planning benchmark domain is plemented here using the problme templating approach. See the `.ptest.json` file for definition of the generated test cases. Each test case i generated from a `.json` file defining the initial and goal state.
This demonstrates a regression test suite.

### Driver log

This domain demonstrates the problem file templating and a programatic generation of scalability test suite.

Run the `generate_tests.py` script (requires Python 3.5+ to be installed) and refresh the _Test Explorer_. You will see a list of _Scalability tests_ for your planner. Run the suite to see how your planner struggles (or does not :-]). See how the _.json_ files are concise to capture the test case definitions. Check the logic in the _problem.pddl_ template.

### Scripted Templating

For any more advanced data transformation during the problem file generation, refer to the ScriptedTemplate sample. It shows how the same `problem.pddl` template may be populated by a static .json file, or, by contrast, the template may be populated using data dynamically queried/transformed by a custom Python script.
The `transform.py` script takes the arguments supplied via the `.ptest.json` test case manifest (i.e. numbers 1, 2 and 3) and sums them up before outputting the result to the PDDL problem. The `transform.py` script (or for that matter any custom program you may write) takes the templated problem from its standard input stream and outputs the rendered template to the standard output. VS Code just orchestrates the data flow during PDDL domain authoring and testing.
When such a solution is deployed (e.g. as a planning service), it is easy to wrap the `transform` function `transform.py` with a Python Flask service.

This is an important pattern, which helps externalize calculations or decision making from the planning domain, when it is more efficient (or less complex) to perform it outside the planning problem. This helps making the planning process faster.