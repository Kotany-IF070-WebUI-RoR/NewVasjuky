module IssuesHelper

  def get_markers
    markers = []
    @issues.each do |issue| 
      markers << issue.geocode unless issue.geocode.nil?
    end
    markers.to_json
  end
end