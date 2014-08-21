require 'octopress-linkblog/version'
require 'octopress-linkblog/configuration'
require 'titlecase'

require 'octopress-hooks'

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

    class PageHook < Hooks::Page
      def post_init(page)
        if page.data['title']
          page.data['title'].titlecase! if LinkBlog.config['titlecase']
          page.data['title_html'] = LinkBlog.unorphan(page.data['title'])
        end
      end
    end

    class PostHook < Hooks::Post
      def post_init(post)
        add_post_vars(post)
      end

      def add_post_vars(post)
        linkpost = post.data['external-url']

        post.data['title'].titlecase! if LinkBlog.config['titlecase']

        if linkpost
          config = LinkBlog.config['linkpost']
        else
          config = LinkBlog.config['post']
        end

        post.data['title_text'] = LinkBlog.post_title_text(post.data['title'], config)
        post.data['title_html'] = LinkBlog.post_title_html(post.data['title'], config)
        post.data['title_url']  = linkpost || post.url
        post.data['linkpost']   = !linkpost.nil?
        post.data['title_link'] = LinkBlog.post_title_link(post.data)
        post.data['permalink']  = LinkBlog.post_link(LinkBlog.config['permalink_label'], post.url, 'article-permalink')
 
        post
      end

    end

    def self.unorphan(title)
      if LinkBlog.config['unorphan']
        title.sub(/\s+(\S+)\s*$/, '&nbsp;\1')
      else
        title
      end
    end

    def self.post_title_html(title, config)
      title = unorphan(title)

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

    def self.post_title_link(data)
      classname = "article-link"
      classname << " linkpost" if data['linkpost']
      post_link(data['title_html'], data['title_url'], classname)
    end

    def self.post_link(title, url, classnames)
      "<a href='#{url}' class='#{classnames}'>#{title}</a>"
    end

    def self.post_title_text(title, config)
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

