module UsersHelper
  def show_issue_status(issue)
    type = case issue.status
           when 'open' then 'success'
           when 'pending' then 'info'
           when 'declined' then 'danger'
           when 'closed' then 'primary'
           else 'default'
           end
    content_tag :span, issue.status_name,
                class: "label label-#{type}"
  end
end
