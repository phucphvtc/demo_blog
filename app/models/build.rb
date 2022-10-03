class Build < ApplicationRecord
  belongs_to :user

  def check_complete
    return false if cpu.blank?
    return false if main.blank?
    return false if psu.blank?
    return false if ram.blank?
    return false if cooler.blank?
    return false if ssd.blank?
    return false if gpu.blank?
    return false if hdd.blank?

    true
  end
end
