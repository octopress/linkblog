# encoding: UTF-8

module Octopress
  module Linkblog
    DEFAULT_OPTIONS = {
      'linkblog' => {
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
    }

    def self.config(options={})
      @config ||= Jekyll::Utils.deep_merge_hashes(DEFAULT_OPTIONS, options)
      @config['linkblog']
    end

  end
end
