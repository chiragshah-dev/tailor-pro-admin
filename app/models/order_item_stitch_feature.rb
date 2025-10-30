class OrderItemStitchFeature < ApplicationRecord
  belongs_to :order_item
  belongs_to :stitch_feature

  validate :validate_stitch_feature_value

  private

  def validate_stitch_feature_value
    case stitch_feature.value_selection_type
    when 'radio'
      if stitch_option_ids.present? && stitch_option_ids.size > 1
        errors.add(:stitch_option_ids, 'must contain exactly one option for radio selection')
      elsif stitch_option_ids.present? && (invalid_ids = stitch_option_ids - stitch_feature.stitch_options.pluck(:id)).any?
        errors.add(:stitch_option_ids, "contains invalid option IDs: #{invalid_ids.join(', ')}")
      end
      errors.add(:text_value, 'is not allowed for radio selection') if text_value.present?
    when 'multiple'
      if stitch_option_ids.present? && (invalid_ids = stitch_option_ids - stitch_feature.stitch_options.pluck(:id)).any?
        errors.add(:stitch_option_ids, "contains invalid option IDs: #{invalid_ids.join(', ')}")
      end
      errors.add(:text_value, 'is not allowed for multiple selection') if text_value.present?
    when 'textbox'
      errors.add(:stitch_option_ids, 'is not allowed for textbox selection') if stitch_option_ids.present?
    end
  end
end
