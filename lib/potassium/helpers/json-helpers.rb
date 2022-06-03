require 'json'

module JsonHelpers
  def merge_to_json_file(path, new_hash_content)
    json_file = File.read Pathname.new(path)

    parsed_file_content = JSON.parse(json_file)
    parsed_file_content = parsed_file_content.deep_merge(new_hash_content.deep_stringify_keys)
    stringified_output = JSON.pretty_generate(parsed_file_content)

    create_file path, stringified_output, force: true
  end
end
