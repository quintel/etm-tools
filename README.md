<h1 align="center">Tools</h1>
<p align="center">Miscellaneous tools for working with the ETM</p>

### cp-scenario

cp-scenario is a small application which reads data from an ETEngine scenario
and creates a new scenario with the same input values. It optionally allows you
to specify a different dataset for the new scenario, in which case the inputs
are scaled to suit the new region.

### csv-update-scenarios

A simple Ruby script which reads a CSV file and updates scenarios, assigning the
user values contained in the CSV.

### csv-query-scenarios

Queries an ETEngine server, requesting the GQuery values for one or more
scenarios, providing the results for all scenarios in CSV format.
