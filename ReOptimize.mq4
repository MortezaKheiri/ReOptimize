// Function to optimize EA parameters using a grid search and back test for the Best result
int OptimizeEAParameters(string symbol, int period, int start, int end, int step, string EA_name, array params[])
{
  // Get the number of parameters to optimize
  int num_params = ArraySize(params);

  // Create a grid of parameter values
  double param_values[num_params];
  for (int i = 0; i < num_params; i++)
  {
    param_values[i] = params[i][0];
    for (int j = 1; j < ArraySize(params[i]); j++)
    {
      param_values[i] += step;
    }
  }

  // Back test the EA for each set of parameter values
  double best_result = -1.0;
  double result;
  for (int i = 0; i < ArraySize(param_values[0]); i++)
  {
    // Set the EA parameters
    for (int j = 0; j < num_params; j++)
    {
      SetIndexBuffer(i, param_values[j]);
    }

    // Back test the EA
    result = BackTestEA(symbol, period, start, end, EA_name, SetIndexBuffer, true);

    // If the result is better than the best result so far, update the best result
    if (result > best_result)
    {
      best_result = result;
    }
  }

  // Return the best result
  return best_result;
}

// Optimize the EA parameters for the EURUSD symbol, over the period 2023-01-01 to 2023-11-01, using a step size of 0.1
double best_result = OptimizeEAParameters("EURUSD", PERIOD_H4, 20230101, 20231101, 0.1, "MyEA", { { 0.1, 0.2, 0.3 }, { 10, 20, 30 } });

// Print the best result
Print("The best result is:", best_result);
