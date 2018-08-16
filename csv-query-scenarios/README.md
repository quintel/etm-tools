<h1 align="center">csv-query-scenarios</h1>
<p align="center">Fetches GQuery results and saves to a CSV</p>

csv-query-scenarios queries one or more ETEngine scenarios and dumps the results
to a CSV file of your choosing.

Usage: `ruby query.rb [server] [comma-separated-ids] [comma-separated-gqueries]`

### Examples

You want to know the values of `gquery_one` and `gquery_two` for scenarios 5, 6,
and 10 on the beta server:

```sh
bin/query beta --scenarios 5,6,10 --gqueries gquery_one,gquery_two
```

Scenario IDs and gquery keys should be comma-separated without any spaces.

By default, `bin/query` will output the CSV one line at a time to your terminal.
Since you probably want the CSV contents in a file, redirect the output of the
command to a file of your choice by ending with `> path/to/output.csv`. The
file _should not_ already exist. For example:

```sh
bin/query beta --scenarios 5,6,10 --gqueries gquery_one,gquery_two > ~/Documents/output.csv
```

In this mode you won't see the CSV being output to your terminal, but instead a
progress bar will update you on the status of the script.
