# -*- coding: utf-8 -*-
"""
Json Analyzer to determine the max size of each field

Created on Wed Feb 18 22:53:38 2015

@author: Owner
"""

import json

content = open('all_courses.json').read()

data = json.loads(content.decode('utf-8', 'replace').encode('utf-8'))

record = {}

for key in data.keys():
    for field in data[key].keys():
        if field == 'code' and len(unicode(data[key][field])) > 10:
            print unicode(data[key][field])
        if field not in record.keys():
            record[field] = len(unicode(data[key][field]))
        else:

           record[field] = max(record[field], len(unicode(data[key][field])))

print record
