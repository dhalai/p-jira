class Topics
  FILENAME = 'event_topics.yml'.freeze

  def initialize(yaml: YAML, file: File, root_path: Rails.root)
    @yaml = yaml
    @file = file
    @root_path = root_path
  end

  def call
    yaml.load(
      file.read(root_path.join('config', FILENAME))
    ).deep_symbolize_keys
  end

  private

  attr_reader :yaml, :file, :root_path
end
