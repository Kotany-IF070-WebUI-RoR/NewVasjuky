module IssuesHelper
  def get_stylized_status_style(status, text)
    type = case status
           when 'opened' then 'warning'
           when 'pending' then 'info'
           when 'declined' then 'danger'
           when 'closed' then 'success'
           end
    content_tag :span, text,
                class: "label label-#{type}"
  end

  def issue_map_url
    "//maps.googleapis.com/maps/api/staticmap?center=
     #{@issue.latitude},#{@issue.longitude}&markers=#{@issue.latitude},
     #{@issue.longitude}&zoom=17&size=640x350&key=#{ENV['GOOGLE_MAPS_API_KEY']}"
  end

  def status_control_link(text, path, style)
    button_tag text, class: "btn btn-#{style} btn-sm change_status_link",
                     method: :patch, 'data-target': '#change_status_form',
                     'data-toggle': 'modal', 'data-path': path
  end
end
