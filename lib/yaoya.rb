Dir[File.join(File.dirname(__FILE__), 'yaoya/*.rb')].each { |lib| require lib }

$BASE_DIR = File.expand_path(File.dirname(__FILE__)) + "/../"
