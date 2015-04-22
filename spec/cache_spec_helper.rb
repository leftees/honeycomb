RSpec.shared_examples "a private basic custom etag cacher" do
  it "sets the etag" do
    subject
    expect(response.etag).not_to be(nil)
  end

  it "does not set the last modified date" do
    subject
    expect(response.last_modified).to be(nil)
  end

  it "does not set a max-age other than 0" do
    subject
    cache_control = response.headers["Cache-Control"]
    unless cache_control.nil? || cache_control.match(/max-age/).nil?
      expect(cache_control.match(/max-age=0/)).not_to be(nil)
    end
  end

  it "does not set cache control to public" do
    subject
    cache_control = response.headers["Cache-Control"]

    unless cache_control.nil?
      expect(cache_control.match(/public/)).to be(nil)
    end
  end
end

RSpec.shared_examples "a private content-based etag cacher" do
  it "does not set the etag" do
    subject
    expect(response.etag).to be(nil)
  end

  it "does not set the last modified date" do
    subject
    expect(response.last_modified).to be(nil)
  end

  it "does not set a max-age other than 0" do
    subject
    cache_control = response.headers["Cache-Control"]

    unless cache_control.nil? || cache_control.match(/max-age/).nil?
      expect(cache_control.match(/max-age=0/)).not_to be(nil)
    end
  end

  it "does not set cache control to public" do
    subject
    cache_control = response.headers["Cache-Control"]

    unless cache_control.nil?
      expect(cache_control.match(/public/)).to be(nil)
    end
  end
end
