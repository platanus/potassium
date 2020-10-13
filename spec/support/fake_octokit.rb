class FakeOctokit
  RECORDER = File.expand_path(File.join('..', '..', 'tmp', 'octokit'), File.dirname(__FILE__))

  def initialize(options); end

  def create_repository(repo_name, options)
    File.open(RECORDER, 'a') do |file|
      file.write "#{repo_name}, #{options.map { |key, value| "#{key}: #{value}" }}"
    end
  end

  def self.clear!
    FileUtils.rm_rf RECORDER
  end

  def self.has_created_repo?(repo_name)
    File.read(RECORDER).include? repo_name
  end

  def self.has_created_private_repo?(repo_name)
    has_created_repo?(repo_name) && File.read(RECORDER).include?("private: true")
  end

  def self.has_created_repo_for_org?(repo_name, org_name)
    has_created_repo?(repo_name) && File.read(RECORDER).include?("organization: #{org_name}")
  end

  def self.has_created_private_repo_for_org?(repo_name, org_name)
    has_created_private_repo?(repo_name) && has_created_repo_for_org?(repo_name, org_name)
  end
end
