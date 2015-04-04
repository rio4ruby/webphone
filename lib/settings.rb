class Setting
  attr_reader :settings
  def initialize(settings = self.class.settings)
    @settings = settings
  end
  def self.settings
    @settings ||= ActiveSupport::HashWithIndifferentAccess.new YAML.load_file(settings_file)[Rails.env]
  end
  def self.settings_file
    Rails.root.join('config','settings.yml')
  end
  def [](key)
    if ::Hash === settings[key]
      Setting.new(settings[key])
    else
      settings[key].present? ? settings[key] : nil
    end
  end
  def inspect
    settings.inspect
  end
  def to_s
    settings.to_s
  end
  def method_missing(sym,*args)
    if sym.to_s.end_with?('?')
      val = settings[sym.to_s.chop.to_sym] 
      (args.empty? || val.blank?) ? val.present? : args.first.split.any?{|arg| arg.in?(val) }
    else
      self[sym]
    end
  end
end
Settings = Setting.new

