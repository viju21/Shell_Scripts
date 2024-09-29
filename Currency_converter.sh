
#Author: VS
#Script name: Currency_converter.sh
#Description:This script that prompts the user for an amount in their local currency and displays the equivalent value in another currency. Use a loop for continuous input and consider APIs for real-time conversion rates (may require additional research).


#!/bin/bash

# API key for exchangerate-api
API_KEY="df49c6171df96d6be3121403"
# Base URL for the API
BASE_URL="https://v6.exchangerate-api.com/v6/$API_KEY/latest"

# Function to get exchange rate
get_exchange_rate() {
  local from_currency=$1
  local to_currency=$2
  local amount=$3

  # Fetch exchange rate data
  response=$(curl -s "$BASE_URL/$from_currency")

  # Check if the response contains an error
  if echo "$response" | jq -e .error > /dev/null; then
    echo "Error fetching exchange rate: $(echo "$response" | jq -r .error)"
    return 1
  fi

  # Extract the exchange rate
  rate=$(echo "$response" | jq -r ".conversion_rates.$to_currency")

  # Check if the rate is available
  if [ "$rate" == "null" ]; then
    echo "Error: Invalid currency code or exchange rate not available."
    return 1
  fi

  # Calculate the converted amount
  converted_amount=$(echo "$amount * $rate" | bc)
  echo "$amount $from_currency = $converted_amount $to_currency"
}

# Main loop
while true; do
  # Prompt user for input
  read -p "Enter amount in your local currency (or 'exit' to quit): " amount
  if [ "$amount" == "exit" ]; then
    break
  fi

  read -p "Enter your local currency code (e.g., USD): " from_currency
  read -p "Enter the target currency code (e.g., EUR): " to_currency

  # Validate amount
  if ! [[ "$amount" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
    echo "Error: Invalid amount."
    continue
  fi

  # Validate currency codes
  if ! [[ "$from_currency" =~ ^[A-Z]{3}$ ]] || ! [[ "$to_currency" =~ ^[A-Z]{3}$ ]]; then
    echo "Error: Invalid currency code."
    continue
  fi

  # Get and display the exchange rate
  get_exchange_rate "$from_currency" "$to_currency" "$amount"
done

