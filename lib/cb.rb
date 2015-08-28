Dir[File.join(File.dirname(__FILE__), 'cb/client/*')].each { |file| require file }

module CB
  def self.configure
    yield configuration
  end

  def self.configuration
    @configuration ||= {}
  end
end
