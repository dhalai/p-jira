module Users
  class Create
    def initialize(model: AuthIdentity, user_model: User)
      @model = model
      @user_model = user_model
    end

    def call(payload:)
      existing_user = user(payload)
      return existing_user if existing_user.present?

      create_new_user(payload)
    end

    private

    attr_reader :model, :user_model

    def user(payload)
      model.joins(:user).find_by(
        provider: payload.dig(:provider),
        login: payload.dig(:info, :email)
      )
    end

    def create_new_user(payload)
      model.transaction do
        identity = model.create(identity_params(payload))
        existing_user = user_model.find_by(email: payload.dig(:info, :email))

        if existing_user.present?
          identity.update(user_id: existing_user.id)
        else
          identity.user.create(payload.dig(:info).slice(:full_name, :public_id, :email, :role))
        end
      end
    end

    def identity_params(payload)
      {
        uid: payload.dig(:uid),
        provider: payload.dig(:provider),
        login: payload.dig(:info, :email),
        token: payload.dig(:credentials, :token)
      }
    end
  end
end
