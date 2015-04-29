# Octopress Linkblog

Adds link blogging features, along with some other niceties to any Jekyll site.

[![Build Status](https://travis-ci.org/octopress/linkblog.svg)](https://travis-ci.org/octopress/linkblog)
[![Gem Version](http://img.shields.io/gem/v/octopress-linkblog.svg)](https://rubygems.org/gems/octopress-linkblog)
[![License](http://img.shields.io/:license-mit-blue.svg)](http://octopress.mit-license.org)

## Installation

### Using Bundler

Add this gem to your site's Gemfile in the `:jekyll_plugins` group:

    group :jekyll_plugins do
      gem 'octopress-linkblog'
    end

Then install the gem with Bundler

    $ bundle

### Manual Installation

    $ gem install octopress-linkblog

Then add the gem to your Jekyll configuration.

    gems:
      - octopress-linkblog

## Usage

### Post features

With the gem installed, your site's posts will automatically have new data attributes.

- `post.title` - The post title, properly capitalized with titlecase.
- `post.title_html` - The post title, unorphaned and with html wrapping any post markers. 
- `post.title_text` - The post title with markers, but all in plain text (great for RSS).
- `post.title_url` - The URL that post titles should link to.
- `post.title_link` - A `<a>` tag filled with the `title_html` pointing to the `title_url`.
- `post.permalink` - A `<a>` tag containing your configuration's `pearmalink_label` pointing to the post's URL.
- `post.linkpost` - A boolean indicating whether the post is a link post.

Here is an example. Given the following YAML front-matter:

```
---
title: cats are awesome
external_url: http://cats.example.com
---
```

The post would have these attributes:

```
title        => Cats Are Awesome
title_html   => Cats Are&nbsp;Awesome&nbsp;<span class='post-marker post-marker-after'>→</span>
title_text   => Cats Are Awesome →
title_url    => http://cats.example.com
title_link   => <a href='http://cats.example.com' class='article-link linkpost'>...</a>
permalink    => <a href='http://your-site.com/posts/1' class='permalink'>Permalink</a>
linkpost     => true
```

Note: the `<a>` in this demo has been shortened, but it will contain the `title_html`.


### Site features

In addition, the site payload will have two new post arrays:

- `site.articles` - Will contain standard posts only.
- `site.linkposts` - Will contain only posts with an `external_url`

This may have many uses, but one in particular is the option to allow RSS feeds for each type
of post.

## Configuration

You can configure this plugin in your site's `_config.yml` under the `linkblog` key. Here are the defaults.

```ruby
linkblog:
  linkpost:
    marker: →
    marker_position: after
  posts:
    marker: false
    marker_position: before

  titlecase: true
  unorphan: true
  permalink_label: Permalink
```

## Contributing

1. Fork it ( https://github.com/octopress/linkblog/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

