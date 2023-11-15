class Api::V1::UsersController < ApplicationController
    def show
        user = User.find_by(name: params[:user_name])

        # すべてのステージのIDを取得
        stage_ids = Stage.pluck(:id)

        # ユーザーに関連するUserStageProgressを一度のクエリで取得
        user_stage_progresses = UserStageProgress.where(user_id: user.id, stage_id: stage_ids).index_by(&:stage_id)

        progresses = stage_ids.map do |stage_id|
            user_stage_progresses[stage_id]&.progress || -1
        end

        data = {
            progresses: progresses
        }

        render json: data.as_json
    end
end
