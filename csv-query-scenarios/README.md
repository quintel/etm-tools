<h1 align="center">csv-query-scenarios</h1>
<p align="center">Fetches GQuery results and saves to a CSV</p>

**Usage:** `bin/query [server] --scenarios [comma-separated-ids] --gqueries [comma-separated-queries]`

## Examples

Fetching the values of `gquery_one` and `gquery_two` for scenarios 5, 6, and 10
on the beta server:

```sh
bin/query beta --scenarios 5,6,10 --gqueries gquery_one,gquery_two
```

Scenario IDs and gquery keys should be comma-separated without any spaces.

### Outputting to a CSV file

By default, the CSV contents will be output one line at a time to the terminal.
Redirect the output of the command to a CSV file by ending with
`> path/to/output.csv`. For example:

```sh
bin/query beta --scenarios 5,6,10 --gqueries graph_year,renewability,total_costs > ~/Documents/output.csv
```

The CSV contents will no longer appear in in the terminal, but instead a
progress bar will show the status of the script.

### Server

The server option may be shorthand or a full server address.

* `beta` or `staging` for the beta server.
  `bin/query beta --scenarios ...`

* `production`, `pro`, or `live` for the production server.
  `bin/query production --scenarios ...`

* A full URL to use a custom ETEngine server.
  `bin/query http://localhost:3000 --scenarios ...`

### Scenarios in a file (`--scenarios-file`)

Instead of providing each scenario on the command-line with `--scenarios`, the
`--scenarios-file` option may be used to specify a path to a file containing
scenario IDs. Each scenario ID should be on a separate line.

```sh
# Create a scenarios.txt file listing four scenario IDs.
echo "916346\n916347\n916354\n916355\n" > ~/Documents/scenarios.txt

# Use the scenarios file instead of --scenarios
bin/query beta --scenarios-file ~/Documents/scenarios.txt --gqueries renewability,total_costs
```

### Gqueries in a file (`--gqueries-file`)

Like `--scenarios-file` (above), `--gqueries-file` permits the use of a file to
list the gqueries:

```sh
# Create a gqueries.txt file listing four gqueries.
echo "graph_year\nrenewability\ntotal_costs\n" > ~/Documents/gqueries.txt

# Use the gqueries file instead of --gqueries
bin/query beta --scenarios 916346,916347 --gqueries-file ~/Documents/gqueries.txt
```

Both the `--scenarios-file` and `--gqueries-file` may be used together

```sh
bin/query beta --scenarios-file ~/Documents/scenarios.txt --gqueries-file ~/Documents/gqueries.txt
```
