require 'rails_helper'

RSpec.describe PageTitle do
  subject { described_class.new("title")}

  it "uses the page_title partial" do
    expect(subject.h).to receive(:render).with({:partial=>"shared/page_title", :locals=>{:title=>"title", :small_title=>"", :settings_link=>""}})
    subject.display
  end

  it "sets the title in the partial " do
    expect(subject.h).to receive(:render).with({:partial=>"shared/page_title", :locals=>{:title=>"title", :small_title=>"", :settings_link=>""}})
    subject.display
  end

  it "allows me to add link to the title" do
   expect(subject.h).to receive(:render).with({:partial=>"shared/page_title", :locals=>{:title=>"<a href=\"href\">title</a>", :small_title=>"", :settings_link=>""}})

    subject.display do | pt |
      pt.title_href = 'href'
    end
  end

  it "allows me to set a small_title" do
    expect(subject.h).to receive(:render).with({:partial=>"shared/page_title", :locals=>{:title=>"title", :small_title=>"/ small title", :settings_link=>""}})

    subject.display do | pt |
      pt.small_title = 'small title'
    end
  end


  it "allows me to set a small_title link" do
    expect(subject.h).to receive(:render).with({:partial=>"shared/page_title", :locals=>{:title=>"title", :small_title=>"/ <a href=\"href\">small title</a>", :settings_link=>""}})

    subject.display do | pt |
      pt.small_title = 'small title'
      pt.small_title_href = 'href'
    end
  end

  it "allows me to add a settings link" do
    expect(subject.h).to receive(:render).with({:partial=>"shared/page_title", :locals=>{:title=>"title", :small_title=>"", :settings_link=>"<a class=\"btn btn-sm\" href=\"href\" role=\"button\"><i class=\"glyphicon glyphicon-cog\"></i> Settings</a>"}})

    subject.display do | pt |
      pt.settings_href = 'href'
    end
  end
end
