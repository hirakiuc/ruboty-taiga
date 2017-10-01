module Ruboty
  module Taiga
    module Actions
      class Auth < Base
        def call
          auth!
        end
      end
    end
  end
end
