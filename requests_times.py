#!/usr/local/bin/python3

# Ask the user for the name of the file
filename = input("Enter the name of the file to process: ")

up_to_1 = 0
between_1_5 = 0
between_5_10 = 0
between_10_20 = 0
between_20_30 = 0
over_30 = 0

# Open the file
with open(filename, "r") as f:  
  for line in f:
    columns = line.split()    
    if len(columns) >= 12:
      # Extract the time from the 12th column
      time = float(columns[11])
      # Check which category the time falls into and increment the appropriate counter
      if time < 1000:
        up_to_1 += 1
      elif 1000 <= time < 5000:
        between_1_5 += 1
      elif 5000 <= time < 10000:
        between_5_10 += 1
      elif 10000 <= time < 20000:
        between_10_20 += 1
      elif 20000 <= time < 30000:
        between_20_30 += 1
      else:
        over_30 += 1

# Print the results
print("Up to 1 second: {}".format(up_to_1))
print("Between 1 second and 5 seconds: {}".format(between_1_5))
print("Between 5 seconds and 10 seconds: {}".format(between_5_10))
print("Between 10 seconds and 20 seconds: {}".format(between_10_20))
print("Between 20 seconds and 30 seconds: {}".format(between_20_30))
print("Over 30 seconds: {}".format(over_30))
