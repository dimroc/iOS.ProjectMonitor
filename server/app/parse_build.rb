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
    {
      "__type" => "Date",
      "iso" => value
    }
  end
end
