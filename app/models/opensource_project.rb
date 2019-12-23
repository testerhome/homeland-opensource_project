class OpensourceProject < ApplicationRecord

  include SoftDelete

  belongs_to :user
  has_many :comments

  enum status: %i(upcoming published rejected)

  validates :slug, uniqueness: true, if: Proc.new { |opensource_project| opensource_project.slug.present? }
  validates :title, :summary, :body, :doc_url, :proj_url, :avatar, presence: true
  validates_format_of :doc_url, :with => URI.regexp
  validates_format_of :proj_url, :with => URI.regexp

  counter :hits

  mount_uploader :avatar, PhotoUploader

  scope :latest, -> { order(published_at: :desc) }
  scope :hotest, -> { order(likes_count: :desc) }
  scope :suggest,            -> { where('suggested_at IS NOT NULL').order(suggested_at: :desc) }
  scope :without_suggest,    -> { where(suggested_at: nil) }

  before_save :generate_summary
  before_create :generate_published_at
  before_validation :safe_slug

  def to_param
    self.slug.blank? ? self.id : self.slug
  end

  def self.find_by_slug!(slug)
    OpensourceProject.find_by(slug: slug) || OpensourceProject.find_by(id: slug) || raise(ActiveRecord::RecordNotFound.new(slug: slug))
  end

  def published_at
    super || self.updated_at
  end

  def published!
    self.update(published_at: Time.now)
    super
    # 通知用户审核通过
    if self.user_id
      Notification.create(notify_type: 'opensource_project_published',
                          user_id: self.user_id,
                          target: self)
    end

    # 通知管理员审核通过
    admin_users = User.admin_users
    default_note = {notify_type: 'admin_opensource_project_published',
                    target_type: OpensourceProject,
                    target_id: self.id}
    Notification.bulk_insert(set_size: 100) do |worker|
      admin_users.each do |admin_user|
        note = default_note.merge(user_id: admin_user[:id])
        worker.add(note)
      end
    end
  end

  private

  def safe_slug
    self.slug.downcase!
    self.slug.gsub!(/[^a-z0-9]/i, '-')
  end

  def generate_published_at
    self.published_at = Time.now
  end

  def generate_summary
    if self.summary.blank?
      self.summary = self.body.split("\n").first(10).join("\n")
    end
  end
end
