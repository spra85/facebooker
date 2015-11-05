class FacebookPostImporter
  def graph
    @graph
  end

  def page
    @page
  end

  def initialize(api_key, page_id)
    Koala.config.api_version = "v2.3"
    @graph = Koala::Facebook::API.new(api_key)
    @page = FacebookPage.find_by(id: page_id)
    raise "Invalid page id" if @page.nil?
  end

  def import_posts(from, to)
    # from = Time.new(2014, 1, 1)
    # # from = Time.new(2014, 12, 31)
    # to = Time.new(2014, 12, 31, 23, 59, 59)

    posts = @graph.get_connection(page.page_id, 'posts', {
      limit: 250,
      fields: ['id', 'message', 'name', 'created_time'],
      since: from.to_i,
      until: to.to_i
    })

    save_posts(posts)
    fetch_next_page(posts)
  end

  def fetch_next_page(posts)
    return if posts.nil? || posts.paging.nil? || posts.paging["next"].empty?

    posts = posts.next_page
    save_posts(posts)
    fetch_next_page(posts)
  end

  def save_posts(posts)
    return if posts.empty?

    posts.each do |post_meta|
      post = FacebookPost.new(
        facebook_page_id: page.id,
        post_id: post_meta["id"],
        name: post_meta["name"],
        message: post_meta["message"],
        post_time: post_meta["created_time"]
      )
      post.save

      if (!post.errors.empty?)
        Rails.logger.error(post.errors)
      else
        Rails.logger.info(post.attributes)
      end
    end
  end
end
