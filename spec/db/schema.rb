ActiveRecord::Schema.define(:version => 0) do

  create_table :servers, force: true do |t|
    t.string   :state
    t.datetime :created_at
    t.datetime :updated_at
  end

end
