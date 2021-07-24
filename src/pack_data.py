#!/usr/bin/env python
# # -*- coding: utf-8 -*-

import os
from pathlib import Path
import base64

output = "\ntype file = { name: string; text: string }"
output += "\nlet files = ["

directory = os.fsencode("data/")
first = True


pathlist = Path("data/").glob('**/*.*')
for path in pathlist:
    # because path is object not string we use str
    # path.relative_to(*path.parts[:1]) removes the data/ part
    filename = str(path.relative_to(*path.parts[:1]))
    if not first: output += "; "
    output += "{ name = \""
    output += filename
    output += "\"; text = \""
    with open(bytes(path), 'r') as content_file:
        content = os.fsdecode(content_file.read())
    output += (base64.b64encode(content.encode())).decode()
    output += "\" }"
    first = False

output += "]"
output += "\n let load () = List.iter (fun f -> Js_of_ocaml.Sys_js.create_file ~name:f.name ~content:(Base64.decode_exn f.text)) files"
print(output)
