class ParseBuild < Hashie::Trash
  property :project, required: true
  property :url, required: true
  property :type, required: true
  property :status, required: true
  property :branch, required: true

  property :startedAt, transform_with: lambda { |v| date_hash(v) }
  property :finishedAt, transform_with: lambda { |v| date_hash(v) }

  property :objectId
  property :commitSha
  property :commitEmail
  property :commitMessage
  property :commitAuthor
  property :createdAt
  property :updatedAt

  property :user
  property :ACL

  def self.date_hash(value)
    return value if value.is_a?(Hash)
    {
      "__type" => "Date",
      "iso" => value
    }
  end

  def output
    self.except("user", "ACL", "objectId", "createdAt", "updatedAt")
  end

  def to_s
    "ParseBuild objectId: #{objectId} project: #{project} branch: #{branch} type: #{type} status: #{status}"
  end

  def failure_description
    return "" unless status.include? "failed"
    "#{commitAuthor} broke the build for #{project} on #{branch}!"
  end
end
