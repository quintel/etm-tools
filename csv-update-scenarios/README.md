<h1 align="center">csv-update-scenarios</h1>
<p align="center">Updates scenarios using a CSV</p>

This is is a simple Ruby script which updates scenarios with input values
specified in a CSV file.

Usage: `ruby update.rb [server] [path-to-csv]`

The CSV should be in the format:

```csv
scenario_one_id,input_one: value,input_two: value,...
scenario_two_id,input_two: value,input_three: value,...
```

### Examples

Examples

You have a file called **values.csv** in the same directory as update.rb, and
you wish to update the values on the **beta** server:

```sh
ruby update.rb beta values.csv
```

You have a file called **scenarios.csv** in your downloads directory, and you
wish to update the values on the **production** server:

```sh
ruby update.rb production ~/Downloads/scenarios.csv
```

You have a file called **values.csv** in the same directory as update.rb, and
you wish to update the values into **your local ETEngine**:

```sh
ruby update.rb http://etengine.test values.csv   # if using "puma-dev"
ruby update.rb http://localhost:3000 values.csv  # if using "bundle exec r
```
