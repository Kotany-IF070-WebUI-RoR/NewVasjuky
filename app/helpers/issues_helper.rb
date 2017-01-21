module IssuesHelper
  def get_markers
    markers = []
    @issues.each do |issue|
      unless issue.geocode.nil?
      marker = {}
        marker['latlng'] = issue.geocode
        marker['popup'] = link_to( issue.title, issue_path(issue))
        markers << marker
      end
    end
    markers.to_json.to_s.html_safe
  end
end