import sys, os, datetime, json
from jinja2 import Template, Environment
from typing import Dict, List

# read the template from the standard input
input = "".join(sys.stdin.readlines())

def tif_filter(time: float, value: float, *function_name) -> str:
    """ Creates time-initial fluent if time>0, or plain initialization otherwise """
    assignment = "(= ({}) {})".format(' '.join(function_name), value)
    return "(at {} {})".format(time, assignment) if time > 0\
        else assignment

def load_template_from_string(template_text: str) -> Template:
    jinja2_env = Environment(trim_blocks = False, lstrip_blocks = False)
    jinja2_env.filters['tif'] = tif_filter

    return jinja2_env.from_string(template_text)

def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)

def remove_doubled_whitespace(text: str) -> str:
    lines = text.splitlines(True)

    output = ''
    was_white_space = False

    for line in lines:
        is_white_space = len(line.strip()) == 0
        if not is_white_space:
            output = output + line
        elif not was_white_space:
            output = output + line
        
        was_white_space = is_white_space

    return output

def transform(name: str, amounts: List, template_string: str) -> str:
    """ transforms the template; this function may be called from other Python code, e.g. Flask web service """

    data = {}
    data['name'] = name
    data['amount'] = sum(amounts)

    template = load_template_from_string(template_string)
    transformed = template.render(data=data)
    compacted = remove_doubled_whitespace(transformed)
    return compacted

def main(args):
    """ transforms the problem file template """
    if len(args) < 1:
        # print errors to the error stream
        eprint("Usage: {0} <amounts-to-sum>".format(os.path.basename(sys.argv[0])))
        exit(-1)

    # this is a simple example of an input data transformation in Python:
    amounts = [float(a.strip()) for a in args]

    name = 'pumps_' + '-'.join(args)

    # render the values into the template
    transformed = transform(name, amounts, input)

    # output the template to the standard output
    print(transformed)
    print("; This PDDL problem file was generated on", str(datetime.datetime.now()))

if __name__ == "__main__":
    main(sys.argv[1:])
