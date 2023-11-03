static func load_scenes_metadata(path: String) -> Array:
	var result := []
	var file := File.new()

	var error_code := file.open(path, File.READ)
	if error_code != OK:
		printerr("Error opening file %s, unable to load data from CSV table." % path)
		return []

	var header := file.get_csv_line()
	while not file.eof_reached():
		var line := file.get_csv_line()
		if line.size() < 2:
			break

		result.append({header[0]: line[0], header[1]: line[1], header[2]: line[2], header[3]: line[3]})

	file.close()
	return result
