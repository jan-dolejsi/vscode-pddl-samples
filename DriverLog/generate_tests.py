import sys, os, json, random
from typing import List, Dict

class ProblemDef(object):
    def __init__(self, line: str):
        arg_list = [arg.strip() for arg in line.split(' ')]

        self.seed = int(arg_list[2])
        self.locations = int(arg_list[3])
        self.drivers = int(arg_list[4])
        self.packages = int(arg_list[5])
        self.trucks = int(arg_list[6])
        self.max = int(arg_list[7])
        self.name = arg_list[9]

def select_random(inputs: List[str]) -> str:
    """ Selects random element from the supplied string list. """
    return inputs[random.randint(0, len(inputs)-1)]

def create_driver(index: int, buildings: List[str]) -> Dict[str, object]:
    """ Creates a driver structure """
    return {
        "name": "driver{}".format(index),
        "initLocation": select_random(buildings),
        "goalLocation": select_random(buildings)
    }

def create_truck(index: int, lots: List[str]) -> Dict[str, object]:
    """ Creates a truck structure """
    return {
        "name": "truck{}".format(index),
        "initLocation": select_random(lots),
        "goalLocation": select_random(lots),
        "empty": True
    }

def create_package(index: int, lots: List[str]) -> Dict[str, object]:
    """ Creates a package structure """
    return {
        "name": "package{}".format(index),
        "initLocation": select_random(lots),
        "goalLocation": select_random(lots)
    }

def create_paths(lots: List[str], buildings: List[str], p: ProblemDef) -> Dict[str, object]:
    """ Creates a graph of paths between lots and buildings """
    paths = []

    # add paths between some buildings and some lots
    for building in buildings:
        for lot in random.sample(lots, random.randint(1, len(lots))):
            paths.append({
                "a": building,
                "b": lot,
                "timeToWalk": random.randint(0, p.max)
            })

    return paths

def create_links(lots: List[str], p: ProblemDef) -> Dict[str, object]:
    """ Creates a graph of road links between lots """
    links = []

    # add links betwen (parking) lots
    for i1 in range(0, len(lots)):
        lot1 = lots[i1]
        for i2 in range(i1+1, len(lots)):
            lot2 = lots[i2]
            links.append({
                "a": lot1,
                "b": lot2,
                "timeToDrive": random.randint(0, p.max)
            })

    return links

def generate_case(manifest: Dict[str,object], p: ProblemDef) -> None:

    # seed the random number generator
    random.seed(p.seed)

    problem_name = "{}-{}-{}".format(p.drivers, p.trucks, p.packages)
    file_name = p.name + ".json"

    case = {
        "label": problem_name,
        "description": "locations: {}, drivers: {}, trucks: {}, packages: {}".format(p.locations, p.drivers, p.trucks, p.packages),
        "preProcess": {
            "kind": "nunjucks",
            "data": os.path.join("..", file_name)
        }
    }

    lots = [f"lot{n}" for n in range(0, p.locations)]
    buildings = ["bldg{}".format(n) for n in range(0, 2*(p.locations))]
    drivers = [create_driver(n, buildings) for n in range(0, p.drivers)]
    trucks = [create_truck(n, lots) for n in range(0, p.trucks)]
    packages = [create_package(n, lots) for n in range(0, p.packages)]
    paths = create_paths(lots, buildings, p)
    links = create_links(lots, p)

    problem = {
        "$schema": "./driverlog-schema.json",
        "name": "p" + problem_name,
        "locations": lots + buildings,
        "drivers": drivers,
        "trucks": trucks,
        "packages": packages,
        "paths": paths,
        "links": links
    }

    manifest['cases'].append(case)

    with open(file_name, mode='w', encoding="utf-8") as fp:
        json.dump(problem, fp, indent=4)

def main(args):
    with open('probs', mode='r', encoding="utf-8") as fp:
        problem_def_lines = fp.readlines()

    problem_defs = [ProblemDef(problem_def) for problem_def in problem_def_lines if problem_def.startswith('dlgen')]

    manifest = { 
        "defaultDomain": "domain.pddl",
        "defaultOptions": "",
        "defaultProblem": "problem.pddl",
        "cases": [
        ]
    }

    for p in problem_defs:
        generate_case(manifest, p)

    ptestName = 'Scalability.ptest.json';

    # generate scalability test cases for the 'numeric' domain encoding
    with open(os.path.join('numeric', ptestName), mode='w', encoding="utf-8") as fp:
        json.dump(manifest, fp, indent=4)

    # generate scalability test cases for the 'numeric with object-fluents' domain encoding
    with open(os.path.join('numeric_with_object-fluents', ptestName), mode='w', encoding="utf-8") as fp:
        json.dump(manifest, fp, indent=4)

if __name__ == "__main__":
    main(sys.argv[1:])
