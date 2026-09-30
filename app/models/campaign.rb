class Campaign < ApplicationRecord
   validates :name, presence: true
  validates :campaign_type, presence: true
  validates :budget, presence: true, numericality: { greater_than_or_equal_to: 0 } 

  # For email campagins
  validates :subject, presence: true, if: :email_campaign?
  validates :content, presence: true, if: :email_campaign?
  
  # Optional: Add enum for campaign types
    enum :campaign_type, { email: "email", social_media: "social_media", sms: "sms" }

    private 
    
    def email_campaign? 
      campaign_type == 'email'
    end

    def banner_ad_campaign? 
      campaign_type == 'display_ads'
    end 

end
