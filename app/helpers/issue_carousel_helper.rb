module IssueCarouselHelper
  def attachment_carousel(issue)
    if issue.issue_attachments.count <= 1
      render inline: "<div class='media-attachment'>
                        <%= image_tag @issue.first_attached_image,
                        class: 'img-responsive' %>"
    else
      render template: 'issues/_issues_carousel'
    end
  end
end
