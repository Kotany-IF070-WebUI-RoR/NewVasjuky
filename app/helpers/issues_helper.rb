module IssuesHelper
  def get_stylized_status_style(status, text)
    type = case status
           when 'opened' then 'success'
           when 'pending' then 'warning'
           when 'declined' then 'danger'
           when 'closed' then 'default'
           else 'info'
           end
    content_tag :span, text,
                class: "label label-#{type}"
  end
end
