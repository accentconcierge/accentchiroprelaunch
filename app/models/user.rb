class User < ActiveRecord::Base
    belongs_to :referrer, :class_name => "User", :foreign_key => "referrer_id"
    has_many :referrals, :class_name => "User", :foreign_key => "referrer_id"
    
    attr_accessible :email

    validates :email, :uniqueness => true, :format => { :with => /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/i, :message => "Invalid email format." }
    validates :referral_code, :uniqueness => true

    before_create :create_referral_code
    after_create :send_welcome_email

    REFERRAL_STEPS = [
        {
            'count' => 5,
            "html" => "Exam<br> & Consultation FREE",
            "class" => "two",
            "image" =>  ActionController::Base.helpers.asset_path("http://i.imgur.com/v3TnQpb.png")
        },
        {
            'count' => 10,
            "html" => "One Month<br>Free Subscription",
            "class" => "three",
            "image" => ActionController::Base.helpers.asset_path("http://i.imgur.com/4rCBbBM.jpg")
        },
        {
            'count' => 25,
            "html" => "First 5 <br> treatments FREE",
            "class" => "four",
            "image" => ActionController::Base.helpers.asset_path("http://i.imgur.com/qPQAhfT.png")
        },
        {
            'count' => 50,
            "html" => "One Year<br>Free Subscription",
            "class" => "five",
            "image" => ActionController::Base.helpers.asset_path("http://i.imgur.com/O5tLCtq.jpg")
        }
    ]

    private

    def create_referral_code
        referral_code = SecureRandom.hex(5)
        @collision = User.find_by_referral_code(referral_code)

        while !@collision.nil?
            referral_code = SecureRandom.hex(5)
            @collision = User.find_by_referral_code(referral_code)
        end

        self.referral_code = referral_code
    end

    def send_welcome_email
        UserMailer.delay.signup_email(self)
    end
end
