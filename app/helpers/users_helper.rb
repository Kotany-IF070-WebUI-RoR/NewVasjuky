module UsersHelper
  def show_issue_status(issue)
    type = case issue.status
           when 'open' then 'success'
           when 'pending' then 'warning'
           when 'declined' then 'danger'
           when 'closed' then 'default'
           else 'info'
           end
    content_tag :span, issue.status_name,
                class: "label label-#{type}"
  end
end
