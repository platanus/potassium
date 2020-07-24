module Potassium
  class NodeVersionEnsurer
    def ensure!
      raise VersionError.new(install_message) if installed_node_version.nil?
      raise VersionError.new(update_message) if Potassium::NODE_VERSION != installed_node_version
    end

    private

    def installed_node_version
      node_version = `node -v 2>&1`
      return node_version.delete('^[0-9\.]').split('.').first if $?.success?
    end

    def install_message
      <<~HERE
        Node doesn't appear to be installed.
        Please make sure you have node #{Potassium::NODE_VERSION} installed.
      HERE
    end

    def update_message
      <<~HERE
        An unsupported version of node was found.
        Please make sure you have node #{Potassium::NODE_VERSION} installed. Newer versions may work but potassium only supports that one.
        If you really need to run potassium with a different version of node, re-run this command with the `--no-node-version-check` flag.
      HERE
    end
  end
end
