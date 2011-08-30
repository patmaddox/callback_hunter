ActiveRecord::Schema.define(:version => 0) do
  create_table :model_with_create_callbacks, :force => true do |t|
    t.column :name, :string
  end
end
