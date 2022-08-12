# This script waits for a file to be written
# and prints its contents

from sys import argv
from time import sleep
from pathlib import Path

argv = argv[1:]

if not argv:
	print("Missing argument!")
	print("Usage:")
	print("    response.py [options]")
	print("")
	print("Options")
	print("        <response_name>, this is the given name to communicate, files will be named as")
	print("                         \"response_<response_name>\" and \"stop_<response_name>\"")
	print("    response.py \"urgent\"")
	print()
	exit(1)

response = Path(".config/awesome/mini_tools/response_" + argv[0])

# Since user can just reload awesome, this process will be 
# stuck looking for a response, so, when awesome is restarted
# a flag is created to stop this script
stop_process = Path(".config/awesome/mini_tools/stop_" + argv[0])
stop_all = Path(".config/awesome/mini_tools/stop_all")

while not response.exists():
	sleep(0.5)
	if stop_process.exists():
		stop_process.unlink()
		exit(1)
	if stop_all.exists():
		exit(1)

with open(response, "r") as file:
	print(file.read())

response.unlink()
