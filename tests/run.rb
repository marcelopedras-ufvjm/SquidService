base_dir = File.expand_path(File.join(File.dirname(__FILE__), ".."))
lib_dir  = File.join(base_dir, "models")
test_dir = File.join(base_dir, "tests")

$LOAD_PATH.unshift(lib_dir)

require 'test/unit'

exit Test::Unit::AutoRunner.run(true, test_dir)