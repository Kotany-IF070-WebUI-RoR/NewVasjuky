# Encoding: utf-8
module Issues
  class SocializationsController < ApplicationController
    def follow
      @issue = Issue.find(params[:issue_id])
      if current_user.follow!(@issue)
        redirect_to @issue
      else
        redirect_to @issue,
                    alert: 'Щось пішло не так. Ви не змогли почати слідкування.'
      end
    end

    def unfollow
      @issue = Issue.find(params[:issue_id])
      if current_user.unfollow!(@issue)
        redirect_to @issue
      else
        redirect_to @issue,
                    alert: 'Щось пішло не так. Ви не змогли відписатися.'
      end
    end
  end
end
