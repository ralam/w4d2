class CatRentalRequest < ActiveRecord::Base
  STATUS = ["PENDING", "APPROVED", "DENIED"]

  after_initialize do |crr|
    crr.status ||= "PENDING"
  end
  validates :cat_id, :start_date, :end_date, :presence => true
  validates :status, inclusion: {in: STATUS}
  validate :overlapping_approved_requests

  belongs_to(
    :cat,
    :foreign_key => :cat_id,
    :primary_key => :id,
    :class_name => "Cat"
  )

  def approve!
    self.status = "APPROVED" if self.status = "PENDING"
    self.save!
    deny_overlapping_pending_requests
  end

  def deny!
    self.status = "DENIED"
    self.save!
  end

  def pending?
    self.status == "PENDING"
  end

  private

  def overlapping_requests(requests)
    requests.all? do |request|
      !overlaps?(request)
    end
  end

  def overlaps?(other)
    (start_date - other.end_date) * (other.start_date - end_date) >= 0
  end

  def overlapping_approved_requests
    results = CatRentalRequest.where cat_id:cat_id, status:"APPROVED"
    return true if results.length <= 1
    overlapping_requests(results)
  end

  def deny_overlapping_pending_requests
    results = CatRentalRequest.where cat_id:cat_id, status:"PENDING"
    results.each do |result|
      result.deny! if overlaps?(result)
    end
  end


end
