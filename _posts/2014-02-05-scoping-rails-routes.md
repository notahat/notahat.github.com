---
title: Scoping Rails Routes
layout: article
date: 2014-02-05
published: true
---

I always forget how `namespace` and `scope` in the Rails routes file affect the controller names, URIs, and named routes.

## Scope

The `scope` method gives you fine-grained control:

{% highlight ruby %}
scope 'url_path_prefix',
  module: 'module_prefix',
  as: 'named_route_prefix'
do
  resources :posts
end
{% endhighlight %}

For example:

{% highlight ruby %}
scope 'foo', module: 'bar', as: 'baz' do
  resources :posts
end
{% endhighlight %}

produces these routes:

    $ rake routes
           Prefix Verb   URI Pattern                   Controller#Action
        baz_posts GET    /foo/posts(.:format)          bar/posts#index
                  POST   /foo/posts(.:format)          bar/posts#create
     new_baz_post GET    /foo/posts/new(.:format)      bar/posts#new
    edit_baz_post GET    /foo/posts/:id/edit(.:format) bar/posts#edit
         baz_post GET    /foo/posts/:id(.:format)      bar/posts#show
                  PATCH  /foo/posts/:id(.:format)      bar/posts#update
                  PUT    /foo/posts/:id(.:format)      bar/posts#update
                  DELETE /foo/posts/:id(.:format)      bar/posts#destroy

## Namespace

The `namespace` method is the simple case --- it prefixes everything.

{% highlight ruby %}
namespace :foo do
  resources :posts
end
{% endhighlight %}

produces:

    $ rake routes
           Prefix Verb   URI Pattern                   Controller#Action
        foo_posts GET    /foo/posts(.:format)          foo/posts#index
                  POST   /foo/posts(.:format)          foo/posts#create
     new_foo_post GET    /foo/posts/new(.:format)      foo/posts#new
    edit_foo_post GET    /foo/posts/:id/edit(.:format) foo/posts#edit
         foo_post GET    /foo/posts/:id(.:format)      foo/posts#show
                  PATCH  /foo/posts/:id(.:format)      foo/posts#update
                  PUT    /foo/posts/:id(.:format)      foo/posts#update
                  DELETE /foo/posts/:id(.:format)      foo/posts#destroy

See [Controller Namespaces and Routing](http://guides.rubyonrails.org/routing.html#controller-namespaces-and-routing) in the Rails Routing guide for more details.
