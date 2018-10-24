import pandas as pd
from jinja2 import Template

tr_stats = pd.read_csv('output.csv')
tr_stats = tr_stats.rename(columns=lambda x: x.strip())
tr_stats['repository'] = tr_stats.Filename.str[3:-6]
tr_stats['language'] = tr_stats.Filename.str[-5:-3]

tr_stats = tr_stats.sort_values(by=['repository', 'Translated Messages'])


with open('dashboard.jinja.html') as file_:
    template = Template(file_.read())

with open('dashboard.html', 'w') as out_:
    out_.write(template.render(repositories=tr_stats))
