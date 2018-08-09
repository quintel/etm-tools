<h1 align="center">CPScenario</h1>
<p align="center">Clones ETEngine scenarios</p>

CPScenario is a small application which reads data from an ETEngine scenario and
creates a new scenario with the same input values. It optionally allow you to
specify a different dataset for the new scenario, in which case the inputs are
scaled to suit the new region.

### Setup

1. Clone the repository.
2. Run `bundle install` to fetch the dependencies.
3. Use the `bin/cp-scenario` command to clone scenarios.

### Usage

`bin/cp-scenario` requires at least two arguments in order to clone a scenario:

1. The name of the ETEngine server to be used ("beta" or "production").
2. The ID of the scenario to be cloned.

For example, to clone scenario 906768 on the beta server, run:

```sh
bin/cp-scenario beta 906768

# Saved new scenario: 906769
#
# ETEngine: https://beta-engine.energytransitionmodel.com/data/906769/scenarios/906769
# ETModel:  https://beta-model.energytransitionmodel.com/scenarios/906769
#
# 13 inputs, 0 bounded
```

The output indicates that a new scenario was created, and that the 13 inputs
from the original were all saved with their expected values.

#### Changing the dataset

You may optionally tell CPScenario to save the new scenario with a different
dataset with the `--dataset` option, in which case the inputs will be scaled to
suit the size of the new region:

```sh
bin/cp-scenario beta 906768 --dataset uk

# Saved new scenario: 906770
#
# ETEngine: https://beta-engine.energytransitionmodel.com/data/906770/scenarios/906770
# ETModel:  https://beta-model.energytransitionmodel.com/scenarios/906770
#
# 13 inputs, 0 bounded
```

Once again, the scenario was saved as expected.

Sometimes the new region cannot apply the (scaled) input values from the
original scenario, due to differences in the region attributes. For example,
cloning a Netherlands scenario with a large number of offshore wind turbines to
the Poland dataset will not work as expected, due to Poland not having enough
space for the turbines:

```sh
bin/cp-scenario beta 906772 --dataset pl

# Saved new scenario: 906774
#
# ETEngine: https://beta-engine.energytransitionmodel.com/data/906774/scenarios/906774
# ETModel:  https://beta-model.energytransitionmodel.com/scenarios/906774
#
# Bounded:
#
#   1) number_of_energy_hydrogen_wind_turbine_offshore
#
#           wanted: 160839.5875362614
#          allowed: 0.0 - 44462.0
#       bounded to: 44462.0
#
# 13 inputs, 1 bounded
```

On this occasion, the scenario *has* been cloned, but CPScenario had to reduce
the number of wind turbines from the desired 161k to 44k in order for the
scenario to be valid.

Copy to multiple datasets simultaneously by separating the dataset keys with a
comma. In this mode, cp-scenario will produce shorter output, listing the
datasets and the status of the cloned scenarios: green for success, yellow
indicating one or more inputs were bounded, red for errors.

```sh
bin/cp-scenario beta 906772 --dataset uk,de

# de: 909478 (13 inputs, 1 bounded)
# uk: 909480
```

For more details on bounded inputs or errors, re-run cp-scenario specifying only
the one (affected) dataset.

#### Custom servers

Instead of supplying "beta" or "production" as the server name, you may instead
provide a URL to the ETEngine server:

```sh
bin/cp-scenario https://etengine.test 898650
```
