require 'octopress-linkblog/version'
require 'octopress-linkblog/configuration'
require 'titlecase'

require 'octopress-hooks'
require 'jekyll'

module Octopress
  module LinkBlog

    def self.config
      LinkBlog::Configuration.config
    end

    class SiteHook < Hooks::Site
      def merge_payload(payload, site)
        {
          'site' => {
            'linkposts' => site.posts.select {|p| p.data['linkpost']},
            'articles'  => site.posts.reject {|p| p.data['linkpost']}
          }
        }
      end
    end

    class PostHook < Hooks::Post
      def post_init(post)
        add_post_vars(post)
      end

      def add_post_vars(post)
        linkpost = post.data['external-url']

        if LinkBlog.config['titlecase']
          post.data['title'].titlecase!
        end

        if linkpost
          config = LinkBlog.config['linkpost']
        else
          config = LinkBlog.config['post']
        end

        post.data['title_text'] = title_text(post.data['title'], config)
        post.data['title_html'] = title_html(post.data['title'], config)
        post.data['title_url']  = linkpost || post.url
        post.data['linkpost']   = !linkpost.nil?
        post.data['title_link'] = title_link(post.data)
        post
      end

      def unorphan(title)
        title.sub(/\s+(\S+)\s*$/, '&nbsp;\1')
      end

      def title_html(title, config)
        if LinkBlog.config['unorphan']
          title = unorphan(title)
        end

        return title if !config['marker']

        marker = "<span class='post-marker post-marker-#{config['marker_position']}'>#{config['marker']}</span>"
        position = config['marker_position']

        if config['marker_position'] == 'before'
          title = "#{marker}&nbsp;#{title}"
        else
          title = "#{title}&nbsp;#{marker}"
        end

        title
      end

      def title_link(data)
        classname = "article-link"
        classname << " linkpost" if data['linkpost']
        "<a href='#{data['title_url']}' class='#{classname}'>#{data['title_html']}</a>"
      end

      def title_text(title, config)
        return title if !config['marker']
        position = config['marker_position']

        if config['marker_position'] == 'before'
          "#{config['marker']} #{title}"
        else
          "#{title} #{config['marker']}"
        end
      end
    end
  end
end

