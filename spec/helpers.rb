module Helpers
  def api_double
    instance_double(
      'CPScenario::API',
      scenario_data: scenario_data_response,
      inputs: input_data
    )
  end

  def input_data
    [
      {
        'code' => 'abc',
        'min' => 0,
        'max' => 100,
        'unit' => '#',
        'user' => 10,
        'default' => 50
      },
      {
        'code' => 'xyz',
        'min' => 0,
        'max' => 100,
        'unit' => '%',
        'default' => 50
      }
    ]
  end

  def scenario_data_response
    {
      'scenario' =>  {
        'id' => 1,
        'title' => 'Scaler test scenario',
        'area_code' => 'nl',
        'start_year' => 2015,
        'end_year' => 2050,
        'url' => 'https://etengine.test/api/v3/scenarios/1',
        'scaling' => nil,
        'created_at' => '2018-07-25T16:04:04.000+02:00'
      },
      'gqueries' => {
        'households_number_of_residences' => {
          'present' => 7_587_964.0,
          'future' => 7_587_964.0,
          'unit' => '#'
        }
      }
    }
  end
end
