require 'octopress-linkblog/version'
require 'octopress-linkblog/configuration'
require 'titlecase'

require 'octopress-hooks'

module Octopress
  module Linkblog

    class SiteHook < Hooks::Site
      def pre_read(site)
        Linkblog.config(site.config)
      end

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
          page.data['title'].titlecase! if Linkblog.config['titlecase']
          page.data['title_html'] = Linkblog.unorphan(page.data['title'])
        end
      end
    end

    class PostHook < Hooks::Post
      def post_init(post)
        add_post_vars(post)
      end

      def add_post_vars(post)
        # Grab external url from post data, reading dashed value for legacy pattern support
        linkpost = post.data['external_url'] || post.data['external-url']

        post.data['title'].titlecase! if Linkblog.config['titlecase']

        if linkpost
          config = Linkblog.config['linkpost']
        else
          config = Linkblog.config['post']
        end

        post_url = File.join('/',post.site.config['baseurl'], post.url)

        post.data['title_text'] = Linkblog.post_title_text(post.data['title'], config)
        post.data['title_html'] = Linkblog.post_title_html(post.data['title'], config)
        post.data['title_url']  = linkpost || post_url
        post.data['linkpost']   = !linkpost.nil?
        post.data['title_link'] = Linkblog.post_title_link(post.data)
        post.data['permalink']  = Linkblog.post_link(Linkblog.config['permalink_label'], post_url, 'article-permalink')

        post
      end

    end

    def self.unorphan(title)
      if Linkblog.config['unorphan']
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

if defined? Octopress::Docs
  Octopress::Docs.add({
    name:        "Octopress Linkblog",
    gem:         "octopress-linkblog",
    description: "Add link-blogging features to any Jekyll site",
    path:        File.expand_path(File.join(File.dirname(__FILE__), "../")),
    source_url:  "https://github.com/octopress/linkblog",
    version:     Octopress::Linkblog::VERSION
  })
end

