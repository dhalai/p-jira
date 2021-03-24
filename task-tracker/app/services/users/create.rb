module Users
  class Create
    def initialize(model: AuthIdentity)
      @model = model
    end

    def call(payload:)
      existing_user = user(payload)
      return existing_user if existing_user.present?

      create_new_user(payload)
      #TODO: send a user.created CUD event
    end

    private

    attr_reader :model

    def user(payload)
      model.joins(:user).find_by(
        provider: payload.dig(:provider),
        login: payload.dig(:info, :email)
      )
    end

    def create_new_user(payload)
      model.create(
        identity_params(payload).merge(user_params(payload))
      )
    end

    def identity_params(payload)
      {
        uid: payload.dig(:uid),
        provider: payload.dig(:provider),
        login: payload.dig(:info, :email),
        token: payload.dig(:credentials, :token)
      }
    end

    def user_params(payload)
      {
        user_attributes: payload.dig(:info).slice(:full_name, :public_id, :email, :role)
      }
    end
  end
end
