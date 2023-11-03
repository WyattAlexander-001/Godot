extends PracticeTests

var cookie := Book.new()
var initial_text := ""

var has_book := false

func _init() -> void:
	add_requirement(".", ["book"], ["_on_Button_pressed", "_on_AnimationPlayer_finished", "set_book"])
	add_requirement("AnimationPlayer", [], [], ["animation_finished"])
	add_requirement("VBoxContainer/PanelContainer/MarginContainer/Label")
	add_requirement("VBoxContainer/CenterContainer/Button", [], [], ["pressed"])


func _prepare_async():
	yield(get_tree(), "idle_frame")
	var script: GDScript = Book
	code = _preprocess_code(script)
	initial_text = scene_root.find_node("Label").text
	yield(get_tree().create_timer(0.5), "timeout")
	has_book = "book" in scene_root and scene_root.book and scene_root.book is Book


func test_fortune_cookie_has_get_random_line_method() -> String:
	if not cookie.has_method("get_random_line"):
		return tr("The Book resource does not have a get_random_line() method")
	return ""


func test_fortune_cookie_exports_lines_property() -> String:
	var correct_lines := [
		"export(Array,String)varlines*=[]"
	]
	var alternatives := [
		"export(Array,String)varlines*",
		"export(Array)varlines*",
		"exportvarlines*",
	]
	if not matches_code_line(correct_lines):
		if matches_code_line(alternatives):
			return tr("You are exporting the lines property, but it isn't the right type. Are you using the (Array, String) hint?")
		if "lines" in cookie:
			if cookie.lines is Array:
				return tr("There is a line property, but it isn't exported. Are you using the export keyword?")
			else:
				return tr("There is a line property, but it isn't an array. Are you sure you declared lines as an array?")
		return tr(
			"There doesn't seem to be a lines property in the resource. Did you set the resources properly?"
		)
	return ""


func test_fortune_cookie_has_a_book_resource() -> String:
	if not "book" in scene_root or not scene_root.book:
		return tr("The book property is not set. Did you provide a Book resource to the book property of the fortune cookie?")
	if not scene_root.book is Book:
		return tr("The book property of the main scene is not a Book. Did you set the correct resource?")
	return ""


func test_book_contains_at_least_two_lines() -> String:
	if not has_book or test_fortune_cookie_exports_lines_property():
		return tr("We could not test if the book contains lines because of other errors.")
	var book: Book = scene_root.book
	if book.lines.size() < 2:
		return tr("We counted the lines, and it looks like there aren't enough. Did you add at least two line?")
	if PoolStringArray(book.lines).join("") == "":
		return tr("There are lines in the used book, but they seem empty. Did you at least fill one line?")
	return ""


func test_book_gives_a_line_from_the_collection_of_lines() -> String:
	if not has_book or test_fortune_cookie_has_get_random_line_method() or\
		test_fortune_cookie_exports_lines_property():
		return tr("We could not test if the book gives a line because of other errors.")
	var book: Book = scene_root.book
	var line = book.get_random_line()
	if not line:
		return tr("get_random_line() returned an empty string. Did you make sure your lines all contain some text?") 
	if book.lines.find(line) < 0:
		return tr("When we used get_random_line, it did not give us a line from the collection of lines. Are you using the array?")
	return ""


func test_book_gives_a_different_line_every_time() -> String:
	if not has_book or\
		test_fortune_cookie_has_get_random_line_method() or\
		test_fortune_cookie_exports_lines_property():
		return tr("We could not test if the book gives a line because of other errors.")
	var book: Book = scene_root.book
	var line = book.get_random_line()
	var tests := 100
	while tests:
		tests -= 1
		if line != book.get_random_line():
			return ""
	return tr("get_random_line() returned the same quote every time we used it. Are you returning a different line every time?") 
	
	
func test_pressing_button_loads_a_line() -> String:
	scene_root._on_Button_pressed()
	var now = scene_root.label.text
	if initial_text == now:
		return tr("We pressed the button, but the text did not change. Did you change the quote in _on_Button_pressed?")
	return ""
