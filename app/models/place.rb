class Place < ApplicationRecord
  has_many :varieties
  validates :name, presence: true
  validate :phone_or_address
  private
  def phone_or_address
    if phone.blank? and address.blank? 
      errors.add(:phone_or_address, I18n.t('errors.messages.blank'))
    end
  end
end