extends VBoxContainer

const lines := [
	"If you know",
	"that 6 Hours of debugging",
	"can save you 5 minutes of reading documentation",
	"",
	"If you try to automate",
	"for 10 days",
	"a task needs 10 minutes",
	"",
	"If you think, once again,",
	"that you can finish in 1 hour",
	"a task that's always taken you 9",
	"",
	"You'll be a gamedev, my student"
]


func _ready() -> void:
	for text in lines:
		add_poetry_line(text)


func add_poetry_line(text: String) -> void:
	var poetry_line := preload("PoetryLine.tscn").instance()
	add_child(poetry_line)
	# Set the text of the poetry line instance. Open PoetryLine.gd to learn how.
