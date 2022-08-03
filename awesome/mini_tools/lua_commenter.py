from pathlib import Path
from re import sub


def comment_line(index):
	global contents
	if comment_file:
		contents[index] = "-- " + contents[index]
	elif contents[index].startswith("-- "):
		contents[index] = (contents[index])[3:]
	elif contents[index].startswith("--"):
		contents[index] = (contents[index])[2:]


file_path = input("Enter the file path\n> ")

if not Path(file_path).exists():
	print("Invalid file path!")
	exit(1)

contents = None

with open(file_path, "r") as file:
	contents = file.read()

if not contents:
	print("Cannot read file!")
	exit(1)

contents = contents.split("\n")

comment_file = input("What do you want to do?\n1. Comment\n2. Uncomment\n> ") == "1"

print(f"This file contents {len(contents)} lines")
start = int(input("Enter the first line to (un)comment\n> "))
end = int(input("Enter the last line to (un)comment\n> "))

if (start <= 0 or start > len(contents)) or (end <= 0 or end > len(contents)):
	print("Invalid limits!")
	exit(1)

if start > end:
	# Limits were given wrong :v
	start, end = end, start

# I'm asking for code line, since index starts with 0
# code line != array index
start -= 1

if start != end:
	for i in range(start, end):
		contents[i] = str(contents[i])
		comment_line(i)
else:
	comment_line(start)

contents = "\n".join(contents)

with open(file_path, "w") as file:
	file.write(contents)

print("Done!")
