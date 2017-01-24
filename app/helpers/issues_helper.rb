# encoding: UTF-8
module IssuesHelper
  require 'json'
  def collect_markers
    markers = []
    @issues.each do |issue|
      next if issue.geocode.nil?
      marker = {}
      marker['latlng'] = issue.geocode
      marker['popup'] = popup_layout(issue)
      markers << marker
    end
    markers.to_json.to_s.html_safe
  end

  def popup_layout(issue)
    %( <h4 class='text-center'>#{issue.title}</h4>
       <img src="#{issue.attachment.url}"></img>
       <p>#{truncate(issue.description, length: 100, separator: ' ')}</p>
       <p class='text-right'><a href="#{issue_path(issue)}">Переглянути</a></p>
      )
  end
end
