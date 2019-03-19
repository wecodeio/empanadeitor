class Place < ApplicationRecord
  has_many :varieties
  validates :name, presence: true
  validate :phone_or_address
  private
  def phone_or_address
    if phone.blank? and address.blank? 
      errors.add(I18n.t('activerecord.models.place.phone'), I18n.t('errors.messages.or') + " #{I18n.t('activerecord.models.place.address')}")
    end
  end
end
