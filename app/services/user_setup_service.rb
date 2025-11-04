class UserSetupService
  # Default tasks
  DEFAULT_TASKS = [
    { name: 'Dyeing', days: 1 },
    { name: 'Cutting', days: 1 },
    { name: 'Embroidery Work', days: 2 },
    { name: 'Hand Work', days: 3 },
    { name: 'Stitching', days: 1 },
    { name: 'Ironing & Packing', days: 1 }
  ].freeze

  DEFAULT_SETTING = {
    measurement_unit: 1,
    show_measurements_to_customer: false,
    is_gst_enabled: false,
    order_number_format: 0,
    send_message_to_customer: false,
    show_standard_dress_to_customer: false,
    default_order_list_days: 90
  }.freeze

  def initialize(user)
    @user = user
  end

  def process
    create_default_tasks
    create_default_setting
  end

  private

  def create_default_tasks
    DEFAULT_TASKS.each do |task_attrs|
      @user.tasks.create(task_attrs)
    end
  end

  def create_default_setting
    @user.create_setting(DEFAULT_SETTING)
  end
end
