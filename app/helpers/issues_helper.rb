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
end
