<h1 align="center">csv-query-scenarios</h1>
<p align="center">Fetches GQuery results and saves to a CSV</p>

**Usage:** `bin/query [server] --scenarios [comma-separated-ids] --gqueries [comma-separated-queries]`

## Examples

You want to know the values of `gquery_one` and `gquery_two` for scenarios 5, 6,
and 10 on the beta server:

```sh
bin/query beta --scenarios 5,6,10 --gqueries gquery_one,gquery_two
```

Scenario IDs and gquery keys should be comma-separated without any spaces.

### Outputting to a CSV file

By default, `bin/query` will output the CSV one line at a time to your terminal.
Since you probably want the CSV contents in a file, redirect the output of the
command to a file of your choice by ending with `> path/to/output.csv`. The
file _should not_ already exist. For example:

```sh
bin/query beta --scenarios 5,6,10 --gqueries graph_year,renewability,total_costs > ~/Documents/output.csv
```

In this mode you won't see the CSV being output to your terminal, but instead a
progress bar will update you on the status of the script.

### Server

The server option may be shorthand or a full server address.

* `beta` or `staging` for the beta server.
  `bin/query beta --scenarios ...`

* `production`, `pro`, or `live` for the production server.
  `bin/query production --scenarios ...`

* A full URL to use your own ETEngine server.
  `bin/query http://localhost:3000 --scenarios ...`

### Scenarios in a file (`--scenarios-file`)

Instead of specifying each scenario on the command-line with `--scenarios`, you
may instead use a file with one scenario ID on each line using the
`--scenarios-file` option. For example:

```sh
# Create a scenarios.txt file listing four scenario IDs.
echo "916346\n916347\n916354\n916355\n" > ~/Documents/scenarios.txt

# Use the scenarios file instead of --scenarios
bin/query beta --scenarios-file ~/Documents/scenarios.txt --gqueries graph_year,renewability,total_costs
```

### Gqueries in a file (`--gqueries-file`)

Like `--scenarios-file` (above), you may also write your Gquery list in a
separate file – with each gquery on a new line – using `--gqueries-file`:

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
