# encoding: utf-8
module Octopress
  unless defined? Octopress.config
    def self.config
      file = '_octopress.yml'
      if File.exist?(file)
        SafeYAML.load_file(file) || {}
      else
        {}
      end
    end
  end

  module LinkBlog
    module Configuration
      DEFAULTS = {
        'linkpost' => {
          'marker' => "→",
          'marker_position' => 'after'
        },

        'post' => {
          'marker' => false,
          'marker_position' => 'before'
        },

        'titlecase' => true,
        'unorphan'  => true,
        'permalink_label' => 'Permalink'
      }

      def self.config
        @config ||= Jekyll::Utils.deep_merge_hashes(DEFAULTS, Octopress.config)
      end
    end
  end
end
