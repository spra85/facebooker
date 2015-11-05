class FacebookPostMetricsImporter
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

  def import_one(post)
    info = @graph.get_connection(post.post_id, "insights")

    return if info.nil?

    impressions = info.find{ |meta| meta["name"] == "post_impressions" }

    if impressions
      values = impressions.fetch("values", [])

      if !values.empty?
        post.impressions = values[0]["value"]
      end
    end

    consumptions = info.find{ |meta| meta["name"] == "post_consumptions_by_type_unique" }

    if consumptions
      values = consumptions.fetch("values", [])

      if !values.empty?
        post.clicks = values[0]["value"]["link clicks"]
      end
    end

    post.save!
  end

  def import_counts
    FacebookPost.where(impressions: nil, facebook_page_id: page.id).find_each do |post|
      import_one(post)
    end
  end
end
