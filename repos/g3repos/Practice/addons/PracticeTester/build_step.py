#!/usr/bin/python3
import os
import csv
import shutil

THIS_DIR = os.path.dirname(__file__)
SCENES_COPY_DIR = os.path.join(THIS_DIR, "practices_copy")


def load_csv(csv_file):
    with open(csv_file, "r") as f:
        reader = csv.DictReader(f)
        return list(reader)


def find_godot_project_dir():
    """Walks up until finding the directory containing the file project.godot"""
    directory = THIS_DIR
    for _ in range(10):
        directory = os.path.dirname(directory)
        if os.path.exists(os.path.join(directory, "project.godot")):
            return os.path.realpath(directory)


def main():
    data = load_csv(os.path.join(THIS_DIR, "practices_meta.csv"))

    scene_relative_directories = [os.path.dirname(entry["scene"]).replace("res://", "", 1) for entry in data]

    godot_project_dir = find_godot_project_dir()
    scene_folders = [os.path.join(godot_project_dir, d) for d in scene_relative_directories]

    if os.path.exists(SCENES_COPY_DIR):
        shutil.rmtree(SCENES_COPY_DIR)

    for f in scene_folders:
        target = os.path.join(SCENES_COPY_DIR, os.path.basename(f))
        shutil.copytree(f, target)

    # Create .gdignore file so scenes don't get imported by Godot
    with open(os.path.join(SCENES_COPY_DIR, ".gdignore"), "w") as f:
        f.write("")


if __name__ == "__main__":
    main()
